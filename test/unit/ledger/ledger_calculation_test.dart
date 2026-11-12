import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/tables/accounts_table.dart';
import 'package:ufm/core/database/tables/payment_attempts_table.dart';
import 'package:ufm/core/database/tables/transactions_table.dart';
import 'package:ufm/data/services/ledger_service_impl.dart';
import 'package:ufm/domain/services/ledger_service.dart';
import '../database/in_memory_database.dart';

void main() {
  late AppDatabase db;
  late LedgerService ledgerService;

  setUp(() {
    db = createTestDatabase();
    ledgerService = LedgerServiceImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Ledger Calculation Service', () {
    test('account with zero transactions returns its opening balance', () async {
      final accId = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Savings'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(100000), // ₹1,000.00
        ),
      );

      final balance = await ledgerService.getAccountBalance(accId);
      expect(balance.openingBalancePaise, equals(100000));
      expect(balance.confirmedIncomePaise, equals(0));
      expect(balance.confirmedExpensePaise, equals(0));
      expect(balance.transfersInPaise, equals(0));
      expect(balance.transfersOutPaise, equals(0));
      expect(balance.currentBalancePaise, equals(100000));
    });

    test(
        'calculates: openingBalance + confirmedIncome - confirmedExpense + transfersIn - transfersOut',
        () async {
      final accId = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Primary Bank'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(25000), // ₹250.00
        ),
      );
      final otherAccId = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Other Bank'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(100000), // ₹1,000.00
        ),
      );

      // 1. Confirmed Income: ₹500 (50,000 paise)
      await db.transactionsDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: accId,
          type: TransactionType.income,
          amountPaise: 50000,
          occurredAt: DateTime.now(),
          source: TransactionSource.manual,
          paymentMethod: PaymentMethod.other,
        ),
      );

      // 2. Confirmed Expense: ₹120 (12,000 paise)
      await db.transactionsDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: accId,
          type: TransactionType.expense,
          amountPaise: 12000,
          occurredAt: DateTime.now(),
          source: TransactionSource.manual,
          paymentMethod: PaymentMethod.upi,
        ),
      );

      // 3. Transfer In from other account: ₹100 (10,000 paise)
      await db.transfersDao.insertTransfer(
        TransfersCompanion.insert(
          sourceAccountId: otherAccId,
          destinationAccountId: accId,
          amountPaise: 10000,
          occurredAt: DateTime.now(),
        ),
      );

      // 4. Transfer Out to other account: ₹40 (4,000 paise)
      await db.transfersDao.insertTransfer(
        TransfersCompanion.insert(
          sourceAccountId: accId,
          destinationAccountId: otherAccId,
          amountPaise: 4000,
          occurredAt: DateTime.now(),
        ),
      );

      // Expected calculation:
      // 25,000 + 50,000 - 12,000 + 10,000 - 4,000 = 69,000 paise (₹690.00)
      final balance = await ledgerService.getAccountBalance(accId);
      expect(balance.openingBalancePaise, equals(25000));
      expect(balance.confirmedIncomePaise, equals(50000));
      expect(balance.confirmedExpensePaise, equals(12000));
      expect(balance.transfersInPaise, equals(10000));
      expect(balance.transfersOutPaise, equals(4000));
      expect(balance.currentBalancePaise, equals(69000));
    });

    test('supports negative balance when expenses exceed opening + income',
        () async {
      final accId = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Credit Account'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(1000), // ₹10.00
        ),
      );

      await db.transactionsDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: accId,
          type: TransactionType.expense,
          amountPaise: 5000, // ₹50.00 expense
          occurredAt: DateTime.now(),
          source: TransactionSource.manual,
          paymentMethod: PaymentMethod.cash,
        ),
      );

      final balance = await ledgerService.getAccountBalance(accId);
      expect(balance.currentBalancePaise, equals(-4000)); // -₹40.00
    });

    test(
        'unconfirmed payment attempts (pending, failed, unverified) do not alter balance',
        () async {
      final accId = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Test Bank'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(50000), // ₹500.00
        ),
      );

      // Pending attempt
      await db.paymentAttemptsDao.insertAttempt(
        PaymentAttemptsCompanion.insert(
          status: PaymentAttemptStatus.pending,
          payeeName: 'P1',
          payeeVpa: 'p1@upi',
          amountPaise: 10000,
          amountWasProvidedByQr: true,
          intendedAccountId: accId,
        ),
      );

      // Failed attempt
      await db.paymentAttemptsDao.insertAttempt(
        PaymentAttemptsCompanion.insert(
          status: PaymentAttemptStatus.failed,
          payeeName: 'P2',
          payeeVpa: 'p2@upi',
          amountPaise: 15000,
          amountWasProvidedByQr: true,
          intendedAccountId: accId,
        ),
      );

      // Unverified attempt
      await db.paymentAttemptsDao.insertAttempt(
        PaymentAttemptsCompanion.insert(
          status: PaymentAttemptStatus.unverified,
          payeeName: 'P3',
          payeeVpa: 'p3@upi',
          amountPaise: 20000,
          amountWasProvidedByQr: true,
          intendedAccountId: accId,
        ),
      );

      final balance = await ledgerService.getAccountBalance(accId);
      expect(balance.currentBalancePaise, equals(50000));
      expect(balance.confirmedExpensePaise, equals(0));
    });

    test(
        'getTotalConfirmedBalancePaise aggregates all non-archived accounts accurately',
        () async {
      final acc1 = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Bank 1'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(100000), // ₹1,000
        ),
      );
      final acc2 = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Bank 2'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(50000), // ₹500
        ),
      );

      // Add expense to Bank 1: ₹200
      await db.transactionsDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: acc1,
          type: TransactionType.expense,
          amountPaise: 20000,
          occurredAt: DateTime.now(),
          source: TransactionSource.manual,
          paymentMethod: PaymentMethod.cash,
        ),
      );

      // Add income to Bank 2: ₹300
      await db.transactionsDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: acc2,
          type: TransactionType.income,
          amountPaise: 30000,
          occurredAt: DateTime.now(),
          source: TransactionSource.manual,
          paymentMethod: PaymentMethod.cash,
        ),
      );

      // Bank 1 balance = 100,000 - 20,000 = 80,000
      // Bank 2 balance = 50,000 + 30,000 = 80,000
      // Total = 160,000
      final total = await ledgerService.getTotalConfirmedBalancePaise();
      expect(total, equals(160000));

      // Archiving Bank 2 excludes it from total net worth
      await db.accountsDao.archiveAccount(acc2);
      final totalAfterArchive =
          await ledgerService.getTotalConfirmedBalancePaise();
      expect(totalAfterArchive, equals(80000));
    });

    test('watchAccountBalance emits updated balance reactively', () async {
      final accId = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Reactive Acc'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(10000), // ₹100
        ),
      );

      final emissions = <int>[];
      final subscription = ledgerService
          .watchAccountBalance(accId)
          .map((b) => b.currentBalancePaise)
          .listen(emissions.add);

      // Wait for initial emission
      while (emissions.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(emissions, equals([10000]));

      // First update: income ₹50
      await db.transactionsDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: accId,
          type: TransactionType.income,
          amountPaise: 5000,
          occurredAt: DateTime.now(),
          source: TransactionSource.manual,
          paymentMethod: PaymentMethod.other,
        ),
      );

      while (emissions.length < 2) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(emissions, equals([10000, 15000]));

      // Second update: expense ₹30
      await db.transactionsDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: accId,
          type: TransactionType.expense,
          amountPaise: 3000,
          occurredAt: DateTime.now(),
          source: TransactionSource.manual,
          paymentMethod: PaymentMethod.other,
        ),
      );

      while (emissions.length < 3) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(emissions, equals([10000, 15000, 12000]));

      await subscription.cancel();
    });
  });
}
