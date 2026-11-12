import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/tables/accounts_table.dart';
import 'package:ufm/core/errors/failures.dart';
import 'package:ufm/data/services/atomic_transfer_service_impl.dart';
import 'package:ufm/data/services/ledger_service_impl.dart';
import 'package:ufm/domain/services/ledger_service.dart';
import 'package:ufm/domain/services/transfer_service.dart';
import '../../unit/database/in_memory_database.dart';

void main() {
  late AppDatabase db;
  late TransferService transferService;
  late LedgerService ledgerService;

  setUp(() {
    db = createTestDatabase();
    transferService = AtomicTransferServiceImpl(db);
    ledgerService = LedgerServiceImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Atomic Transfer Service Invariance & Mechanics', () {
    test(
        'transfer debits source, credits destination, and preserves total funds strictly',
        () async {
      final acc1 = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Bank A'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(100000), // ₹1,000.00
        ),
      );
      final acc2 = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Bank B'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(50000), // ₹500.00
        ),
      );

      final initialTotal =
          await ledgerService.getTotalConfirmedBalancePaise();
      expect(initialTotal, equals(150000)); // ₹1,500.00 combined

      // Execute transfer: ₹350 (35,000 paise) from Bank A to Bank B
      final transferId = await transferService.executeTransfer(
        sourceAccountId: acc1,
        destinationAccountId: acc2,
        amountPaise: 35000,
        occurredAt: DateTime.now(),
        note: 'Inter-bank fund shift',
      );

      expect(transferId, isPositive);

      final balanceA = await ledgerService.getAccountBalance(acc1);
      final balanceB = await ledgerService.getAccountBalance(acc2);
      final finalTotal =
          await ledgerService.getTotalConfirmedBalancePaise();

      // Bank A decreased by 35,000
      expect(balanceA.currentBalancePaise, equals(65000)); // ₹650.00
      expect(balanceA.transfersOutPaise, equals(35000));
      expect(balanceA.transfersInPaise, equals(0));

      // Bank B increased by 35,000
      expect(balanceB.currentBalancePaise, equals(85000)); // ₹850.00
      expect(balanceB.transfersInPaise, equals(35000));
      expect(balanceB.transfersOutPaise, equals(0));

      // Invariance: 65,000 + 85,000 = 150,000 paise
      expect(finalTotal, equals(initialTotal));
    });

    test('multiple reciprocal transfers preserve total funds across 3 accounts',
        () async {
      final acc1 = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Account 1'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(100000), // ₹1,000
        ),
      );
      final acc2 = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Account 2'),
          type: Value(AccountType.cash),
          openingBalancePaise: Value(50000), // ₹500
        ),
      );
      final acc3 = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Account 3'),
          type: Value(AccountType.other),
          openingBalancePaise: Value(25000), // ₹250
        ),
      );

      final initialTotal =
          await ledgerService.getTotalConfirmedBalancePaise();
      expect(initialTotal, equals(175000)); // ₹1,750

      // 1 -> 2: ₹200
      await transferService.executeTransfer(
        sourceAccountId: acc1,
        destinationAccountId: acc2,
        amountPaise: 20000,
        occurredAt: DateTime.now(),
      );

      // 2 -> 3: ₹150
      await transferService.executeTransfer(
        sourceAccountId: acc2,
        destinationAccountId: acc3,
        amountPaise: 15000,
        occurredAt: DateTime.now(),
      );

      // 3 -> 1: ₹50
      await transferService.executeTransfer(
        sourceAccountId: acc3,
        destinationAccountId: acc1,
        amountPaise: 5000,
        occurredAt: DateTime.now(),
      );

      final balance1 = await ledgerService.getAccountBalance(acc1);
      final balance2 = await ledgerService.getAccountBalance(acc2);
      final balance3 = await ledgerService.getAccountBalance(acc3);
      final finalTotal =
          await ledgerService.getTotalConfirmedBalancePaise();

      // Acc 1: 100,000 - 20,000 + 5,000 = 85,000
      expect(balance1.currentBalancePaise, equals(85000));
      // Acc 2: 50,000 + 20,000 - 15,000 = 55,000
      expect(balance2.currentBalancePaise, equals(55000));
      // Acc 3: 25,000 + 15,000 - 5,000 = 35,000
      expect(balance3.currentBalancePaise, equals(35000));

      // Combined total invariant: 85,000 + 55,000 + 35,000 = 175,000
      expect(finalTotal, equals(175000));
    });

    test('rejects transfer when source and destination are identical', () async {
      final accId = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Solo Bank'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(50000),
        ),
      );

      expect(
        () => transferService.executeTransfer(
          sourceAccountId: accId,
          destinationAccountId: accId,
          amountPaise: 10000,
          occurredAt: DateTime.now(),
        ),
        throwsA(isA<SameAccountTransferFailure>()),
      );
    });

    test('rejects transfer with zero or negative amount', () async {
      final acc1 = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Bank 1'),
          type: Value(AccountType.bank),
        ),
      );
      final acc2 = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Bank 2'),
          type: Value(AccountType.bank),
        ),
      );

      expect(
        () => transferService.executeTransfer(
          sourceAccountId: acc1,
          destinationAccountId: acc2,
          amountPaise: 0,
          occurredAt: DateTime.now(),
        ),
        throwsA(isA<InvalidAmountFailure>()),
      );

      expect(
        () => transferService.executeTransfer(
          sourceAccountId: acc1,
          destinationAccountId: acc2,
          amountPaise: -5000,
          occurredAt: DateTime.now(),
        ),
        throwsA(isA<InvalidAmountFailure>()),
      );
    });

    test('rejects transfer with non-existent accounts', () async {
      final validAcc = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Valid'),
          type: Value(AccountType.bank),
        ),
      );

      expect(
        () => transferService.executeTransfer(
          sourceAccountId: 9999, // Non-existent
          destinationAccountId: validAcc,
          amountPaise: 5000,
          occurredAt: DateTime.now(),
        ),
        throwsA(isA<AccountNotFoundFailure>()),
      );

      expect(
        () => transferService.executeTransfer(
          sourceAccountId: validAcc,
          destinationAccountId: 9999, // Non-existent
          amountPaise: 5000,
          occurredAt: DateTime.now(),
        ),
        throwsA(isA<AccountNotFoundFailure>()),
      );
    });

    test('rejects transfer involving archived accounts', () async {
      final activeAcc = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Active'),
          type: Value(AccountType.bank),
        ),
      );
      final archivedAcc = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Archived'),
          type: Value(AccountType.bank),
        ),
      );
      await db.accountsDao.archiveAccount(archivedAcc);

      expect(
        () => transferService.executeTransfer(
          sourceAccountId: archivedAcc,
          destinationAccountId: activeAcc,
          amountPaise: 5000,
          occurredAt: DateTime.now(),
        ),
        throwsA(isA<DatabaseFailure>()),
      );

      expect(
        () => transferService.executeTransfer(
          sourceAccountId: activeAcc,
          destinationAccountId: archivedAcc,
          amountPaise: 5000,
          occurredAt: DateTime.now(),
        ),
        throwsA(isA<DatabaseFailure>()),
      );
    });
  });
}

