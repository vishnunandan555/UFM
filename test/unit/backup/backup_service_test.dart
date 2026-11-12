import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/backup/backup_service.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/tables/accounts_table.dart';
import 'package:ufm/core/database/tables/transactions_table.dart';
import '../database/in_memory_database.dart';

void main() {
  late AppDatabase db;
  late BackupService service;

  setUp(() {
    db = createTestDatabase();
    service = BackupService(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('BackupService exports and restores database round-trip accurately',
      () async {
    // 1. Populate DB with test data
    final accId = await db.accountsDao.insertAccount(
      const AccountsCompanion(
        name: drift.Value('ICICI Salary'),
        type: drift.Value(AccountType.bank),
        openingBalancePaise: drift.Value(500000), // ₹5,000.00
      ),
    );

    await db.transactionsDao.insertTransaction(
      TransactionsCompanion.insert(
        accountId: accId,
        type: TransactionType.expense,
        amountPaise: 45000,
        merchant: const drift.Value('Grocery Supermarket'),
        occurredAt: DateTime.now(),
        source: TransactionSource.manual,
        paymentMethod: PaymentMethod.other,
      ),
    );

    // 2. Export
    final jsonExport = await service.exportToJson();
    expect(jsonExport, contains('ICICI Salary'));
    expect(jsonExport, contains('Grocery Supermarket'));
    expect(jsonExport, contains('500000'));
    expect(jsonExport, contains('45000'));

    // 3. Clear DB by opening a fresh in-memory database
    final freshDb = createTestDatabase();
    final freshService = BackupService(freshDb);

    final initialAccounts = await freshDb.accountsDao.getAllAccounts();
    expect(initialAccounts.isEmpty, isTrue);

    // 4. Restore into fresh DB
    final restoreResult = await freshService.restoreFromJson(jsonExport);
    expect(restoreResult.isSuccess, isTrue);

    final restoredAccounts = await freshDb.accountsDao.getAllAccounts();
    expect(restoredAccounts.length, 1);
    expect(restoredAccounts.first.name, 'ICICI Salary');
    expect(restoredAccounts.first.openingBalancePaise, 500000);

    final restoredTxs = await freshDb.transactionsDao.getAllTransactions();
    expect(restoredTxs.length, 1);
    expect(restoredTxs.first.merchant, 'Grocery Supermarket');
    expect(restoredTxs.first.amountPaise, 45000);

    await freshDb.close();
  });

  test('BackupService rejects invalid or malformed JSON gracefully', () async {
    final result1 = await service.restoreFromJson('not valid json');
    expect(result1.isSuccess, isFalse);
    expect(result1.errorMessage, contains('Invalid JSON'));

    final result2 = await service.restoreFromJson('{"randomKey": 123}');
    expect(result2.isSuccess, isFalse);
    expect(result2.errorMessage, contains('Missing required metadata'));
  });
}
