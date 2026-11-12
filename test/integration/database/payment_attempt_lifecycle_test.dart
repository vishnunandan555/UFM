import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart' show SqliteException;
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/tables/accounts_table.dart';
import 'package:ufm/core/database/tables/payment_attempts_table.dart';
import 'package:ufm/core/database/tables/transactions_table.dart';
import 'package:ufm/data/services/ledger_service_impl.dart';
import 'package:ufm/domain/services/ledger_service.dart';
import '../../unit/database/in_memory_database.dart';

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

  group('Payment Attempt Lifecycle & Ledger Linkage', () {
    test('flow: pending attempt does not affect balance or create transaction',
        () async {
      final acc = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Primary Checking'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(100000), // ₹1,000.00
        ),
      );

      final attemptId = await db.paymentAttemptsDao.insertAttempt(
        PaymentAttemptsCompanion.insert(
          status: PaymentAttemptStatus.pending,
          payeeName: 'Coffee Shop',
          payeeVpa: 'coffee@upi',
          amountPaise: 25000, // ₹250.00
          amountWasProvidedByQr: true,
          intendedAccountId: acc,
        ),
      );

      final balance = await ledgerService.getAccountBalance(acc);
      expect(balance.currentBalancePaise, equals(100000)); // Unaffected!

      final tx = await db.transactionsDao
          .getTransactionByPaymentAttemptId(attemptId);
      expect(tx, isNull);
    });

    test('flow: failed confirmation (user answered No) leaves ledger untouched',
        () async {
      final acc = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Bank'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(50000), // ₹500.00
        ),
      );

      final attemptId = await db.paymentAttemptsDao.insertAttempt(
        PaymentAttemptsCompanion.insert(
          status: PaymentAttemptStatus.pending,
          payeeName: 'Electronics Store',
          payeeVpa: 'electronics@upi',
          amountPaise: 30000,
          amountWasProvidedByQr: true,
          intendedAccountId: acc,
        ),
      );

      // User answered "No"
      await db.paymentAttemptsDao.updateAttemptStatus(
        attemptId,
        PaymentAttemptStatus.failed,
        resolvedAt: DateTime.now(),
      );

      final attempt = await db.paymentAttemptsDao.getAttemptById(attemptId);
      expect(attempt!.status, equals(PaymentAttemptStatus.failed));
      expect(attempt.linkedTransactionId, isNull);

      final balance = await ledgerService.getAccountBalance(acc);
      expect(balance.currentBalancePaise, equals(50000));
      expect(balance.confirmedExpensePaise, equals(0));
    });

    test(
        'flow: unverified attempt can later be confirmed and alters balance exactly once',
        () async {
      final acc = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Salary Account'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(200000), // ₹2,000.00
        ),
      );

      // Payment app closed or user dismissed dialog -> status unverified
      final attemptId = await db.paymentAttemptsDao.insertAttempt(
        PaymentAttemptsCompanion.insert(
          status: PaymentAttemptStatus.unverified,
          payeeName: 'Grocery Store',
          payeeVpa: 'grocery@upi',
          amountPaise: 40000, // ₹400.00
          amountWasProvidedByQr: true,
          intendedAccountId: acc,
        ),
      );

      // Verify it appears in unverified attempts
      final unverifiedList =
          await db.paymentAttemptsDao.getUnverifiedAttempts();
      expect(unverifiedList.any((a) => a.id == attemptId), isTrue);

      // Balance still unaffected
      var balance = await ledgerService.getAccountBalance(acc);
      expect(balance.currentBalancePaise, equals(200000));

      // User navigates to unverified list and confirms "Yes"
      await db.transaction(() async {
        final txId = await db.transactionsDao.insertTransaction(
          TransactionsCompanion.insert(
            accountId: acc,
            type: TransactionType.expense,
            amountPaise: 40000,
            occurredAt: DateTime.now(),
            source: TransactionSource.upiQr,
            paymentMethod: PaymentMethod.upi,
            paymentAttemptId: Value(attemptId),
          ),
        );

        await db.paymentAttemptsDao.linkTransaction(attemptId, txId);
        await db.paymentAttemptsDao.updateAttemptStatus(
          attemptId,
          PaymentAttemptStatus.confirmed,
        );
      });

      // Status is confirmed, attempt is linked
      final confirmedAttempt =
          await db.paymentAttemptsDao.getAttemptById(attemptId);
      expect(confirmedAttempt!.status, equals(PaymentAttemptStatus.confirmed));
      expect(confirmedAttempt.linkedTransactionId, isNotNull);

      // No longer unverified
      final remainingUnverified =
          await db.paymentAttemptsDao.getUnverifiedAttempts();
      expect(remainingUnverified.any((a) => a.id == attemptId), isFalse);

      // Balance reflects the expense: 200,000 - 40,000 = 160,000 paise (₹1,600.00)
      balance = await ledgerService.getAccountBalance(acc);
      expect(balance.currentBalancePaise, equals(160000));
      expect(balance.confirmedExpensePaise, equals(40000));
    });

    test(
        'funding account correction: debits actual funding account instead of intended account',
        () async {
      final intendedAcc = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('SBI Intended'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(100000), // ₹1,000
        ),
      );
      final actualAcc = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('HDFC Actual'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(100000), // ₹1,000
        ),
      );

      final attemptId = await db.paymentAttemptsDao.insertAttempt(
        PaymentAttemptsCompanion.insert(
          status: PaymentAttemptStatus.pending,
          payeeName: 'Bookstore',
          payeeVpa: 'books@upi',
          amountPaise: 30000, // ₹300
          amountWasProvidedByQr: true,
          intendedAccountId: intendedAcc,
        ),
      );

      // User selected HDFC inside GPay instead of SBI:
      // Insert transaction debited against actualAcc
      await db.transaction(() async {
        final txId = await db.transactionsDao.insertTransaction(
          TransactionsCompanion.insert(
            accountId: actualAcc, // Actual account used
            type: TransactionType.expense,
            amountPaise: 30000,
            occurredAt: DateTime.now(),
            source: TransactionSource.upiQr,
            paymentMethod: PaymentMethod.upi,
            paymentAttemptId: Value(attemptId),
            actualFundingAccountId: Value(actualAcc),
          ),
        );

        await db.paymentAttemptsDao.linkTransaction(attemptId, txId);
        await db.paymentAttemptsDao.updateAttemptStatus(
          attemptId,
          PaymentAttemptStatus.confirmed,
        );
      });

      final intendedBalance =
          await ledgerService.getAccountBalance(intendedAcc);
      final actualBalance = await ledgerService.getAccountBalance(actualAcc);

      // Intended account balance is untouched
      expect(intendedBalance.currentBalancePaise, equals(100000));
      // Actual funding account is debited
      expect(actualBalance.currentBalancePaise, equals(70000));
    });

    test('duplicate payment confirmation is rejected at SQLite constraint level',
        () async {
      final acc = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Bank'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(100000),
        ),
      );

      final attemptId = await db.paymentAttemptsDao.insertAttempt(
        PaymentAttemptsCompanion.insert(
          status: PaymentAttemptStatus.pending,
          payeeName: 'Store',
          payeeVpa: 'store@upi',
          amountPaise: 15000,
          amountWasProvidedByQr: true,
          intendedAccountId: acc,
        ),
      );

      // First confirmation creates transaction
      await db.transactionsDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: acc,
          type: TransactionType.expense,
          amountPaise: 15000,
          occurredAt: DateTime.now(),
          source: TransactionSource.upiQr,
          paymentMethod: PaymentMethod.upi,
          paymentAttemptId: Value(attemptId),
        ),
      );

      // Rapid double-tap or repeated resume callback trying to insert another transaction
      // for the SAME payment attempt MUST throw SqliteException due to UNIQUE constraint
      expect(
        () => db.transactionsDao.insertTransaction(
          TransactionsCompanion.insert(
            accountId: acc,
            type: TransactionType.expense,
            amountPaise: 15000,
            occurredAt: DateTime.now(),
            source: TransactionSource.upiQr,
            paymentMethod: PaymentMethod.upi,
            paymentAttemptId: Value(attemptId),
          ),
        ),
        throwsA(isA<SqliteException>()),
      );
    });
  });
}
