import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/tables/accounts_table.dart';
import 'package:ufm/core/database/tables/categories_table.dart';
import 'package:ufm/core/database/tables/payment_attempts_table.dart';
import 'package:ufm/core/database/tables/transactions_table.dart';
import 'in_memory_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('AccountsDao', () {
    test('insert, retrieve, archive, and unarchive account', () async {
      final id = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('ICICI Bank'),
          type: Value(AccountType.bank),
          openingBalancePaise: Value(500000), // ₹5,000.00
          iconKey: Value('account_balance'),
        ),
      );

      final account = await db.accountsDao.getAccountById(id);
      expect(account, isNotNull);
      expect(account!.name, equals('ICICI Bank'));
      expect(account.openingBalancePaise, equals(500000));
      expect(account.isArchived, isFalse);

      // Active accounts list
      final active = await db.accountsDao.getActiveAccounts();
      expect(active.any((a) => a.id == id), isTrue);

      // Archive account
      await db.accountsDao.archiveAccount(id);
      final archivedAcc = await db.accountsDao.getAccountById(id);
      expect(archivedAcc!.isArchived, isTrue);

      final activeAfterArchive = await db.accountsDao.getActiveAccounts();
      expect(activeAfterArchive.any((a) => a.id == id), isFalse);

      // Unarchive account
      await db.accountsDao.unarchiveAccount(id);
      final restoredAcc = await db.accountsDao.getAccountById(id);
      expect(restoredAcc!.isArchived, isFalse);
    });
  });

  group('CategoriesDao', () {
    test('insert custom category and filter by kind', () async {
      final id = await db.categoriesDao.insertCategory(
        const CategoriesCompanion(
          name: Value('Coffee & Cafes'),
          kind: Value(CategoryKind.expense),
          iconKey: Value('local_cafe'),
        ),
      );

      final cat = await db.categoriesDao.getCategoryById(id);
      expect(cat, isNotNull);
      expect(cat!.name, equals('Coffee & Cafes'));
      expect(cat.isDefault, isFalse);

      // Archive category
      await db.categoriesDao.archiveCategory(id);
      final archived = await db.categoriesDao.getCategoryById(id);
      expect(archived!.isArchived, isTrue);

      final active = await db.categoriesDao.getActiveCategories();
      expect(active.any((c) => c.id == id), isFalse);
    });
  });

  group('TransactionsDao', () {
    test('insert transaction, filter by account, and retrieve by attemptId',
        () async {
      final accId = await db.accountsDao.insertAccount(
        const AccountsCompanion(
          name: Value('Cash Wallet'),
          type: Value(AccountType.cash),
        ),
      );

      final attemptId = await db.paymentAttemptsDao.insertAttempt(
        PaymentAttemptsCompanion.insert(
          status: PaymentAttemptStatus.confirmed,
          payeeName: 'Chai Wala',
          payeeVpa: 'chai@upi',
          amountPaise: 2000,
          amountWasProvidedByQr: true,
          intendedAccountId: accId,
        ),
      );

      final txId = await db.transactionsDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: accId,
          type: TransactionType.expense,
          amountPaise: 2000,
          occurredAt: DateTime.now(),
          source: TransactionSource.upiQr,
          paymentMethod: PaymentMethod.upi,
          merchant: const Value('Chai Wala'),
          paymentAttemptId: Value(attemptId),
        ),
      );

      final tx = await db.transactionsDao.getTransactionById(txId);
      expect(tx, isNotNull);
      expect(tx!.amountPaise, equals(2000));
      expect(tx.merchant, equals('Chai Wala'));

      final byAttempt =
          await db.transactionsDao.getTransactionByPaymentAttemptId(attemptId);
      expect(byAttempt, isNotNull);
      expect(byAttempt!.id, equals(txId));

      final accountTxs =
          await db.transactionsDao.getTransactionsForAccount(accId);
      expect(accountTxs.length, equals(1));

      // Delete transaction
      final deleted = await db.transactionsDao.deleteTransaction(txId);
      expect(deleted, equals(1));

      final deletedTx = await db.transactionsDao.getTransactionById(txId);
      expect(deletedTx, isNull);
    });
  });

  group('TransfersDao', () {
    test('insert and query transfers for account', () async {
      final acc1 = await db.accountsDao.insertAccount(
        const AccountsCompanion(name: Value('A'), type: Value(AccountType.bank)),
      );
      final acc2 = await db.accountsDao.insertAccount(
        const AccountsCompanion(name: Value('B'), type: Value(AccountType.bank)),
      );

      final transferId = await db.transfersDao.insertTransfer(
        TransfersCompanion.insert(
          sourceAccountId: acc1,
          destinationAccountId: acc2,
          amountPaise: 15000,
          occurredAt: DateTime.now(),
          note: const Value('Rent share'),
        ),
      );

      final transfer = await db.transfersDao.getTransferById(transferId);
      expect(transfer, isNotNull);
      expect(transfer!.amountPaise, equals(15000));
      expect(transfer.note, equals('Rent share'));

      // Both accounts see this transfer
      final transfersForA =
          await db.transfersDao.getTransfersForAccount(acc1);
      final transfersForB =
          await db.transfersDao.getTransfersForAccount(acc2);

      expect(transfersForA.length, equals(1));
      expect(transfersForB.length, equals(1));
      expect(transfersForA.first.id, equals(transferId));
      expect(transfersForB.first.id, equals(transferId));
    });
  });

  group('PaymentAttemptsDao', () {
    test('insert attempt, query unverified, update status, and link transaction',
        () async {
      final accId = await db.accountsDao.insertAccount(
        const AccountsCompanion(name: Value('Bank'), type: Value(AccountType.bank)),
      );

      final attemptId = await db.paymentAttemptsDao.insertAttempt(
        PaymentAttemptsCompanion.insert(
          status: PaymentAttemptStatus.unverified,
          payeeName: 'Supermarket',
          payeeVpa: 'supermarket@upi',
          amountPaise: 45000,
          amountWasProvidedByQr: true,
          intendedAccountId: accId,
        ),
      );

      final unverified = await db.paymentAttemptsDao.getUnverifiedAttempts();
      expect(unverified.any((a) => a.id == attemptId), isTrue);

      // Create ledger transaction
      final txId = await db.transactionsDao.insertTransaction(
        TransactionsCompanion.insert(
          accountId: accId,
          type: TransactionType.expense,
          amountPaise: 45000,
          occurredAt: DateTime.now(),
          source: TransactionSource.upiQr,
          paymentMethod: PaymentMethod.upi,
          paymentAttemptId: Value(attemptId),
        ),
      );

      // Link transaction and update status to confirmed
      await db.paymentAttemptsDao.linkTransaction(attemptId, txId);
      await db.paymentAttemptsDao.updateAttemptStatus(
        attemptId,
        PaymentAttemptStatus.confirmed,
      );

      final updated = await db.paymentAttemptsDao.getAttemptById(attemptId);
      expect(updated!.status, equals(PaymentAttemptStatus.confirmed));
      expect(updated.linkedTransactionId, equals(txId));

      final unverifiedAfter =
          await db.paymentAttemptsDao.getUnverifiedAttempts();
      expect(unverifiedAfter.any((a) => a.id == attemptId), isFalse);
    });
  });
}

