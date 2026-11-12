import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/database_provider.dart';
import 'package:ufm/core/database/tables/accounts_table.dart';
import 'package:ufm/features/transactions/presentation/add_transaction_dialog.dart';
import 'package:ufm/features/transactions/presentation/transfer_dialog.dart';
import '../unit/database/in_memory_database.dart';

void main() {
  late AppDatabase db;
  late int acc1;
  late int acc2;

  setUp(() async {
    db = createTestDatabase();
    acc1 = await db.accountsDao.insertAccount(
      const AccountsCompanion(
        name: drift.Value('Bank A'),
        type: drift.Value(AccountType.bank),
        openingBalancePaise: drift.Value(50000), // ₹500.00
      ),
    );
    acc2 = await db.accountsDao.insertAccount(
      const AccountsCompanion(
        name: drift.Value('Cash Wallet'),
        type: drift.Value(AccountType.cash),
        openingBalancePaise: drift.Value(20000), // ₹200.00
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('AddTransactionDialog saves expense and debits ledger correctly',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: AddTransactionDialog(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Enter amount ₹150.00
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Amount (₹)'), '150');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Merchant / Payee (Optional)'),
        'Cafe Coffee Day');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify transaction in DB
    final txs = await db.transactionsDao.getAllTransactions();
    expect(txs.length, 1);
    expect(txs.first.amountPaise, 15000);
    expect(txs.first.merchant, 'Cafe Coffee Day');

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('TransferDialog executes transfer between two accounts',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: TransferDialog(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Enter transfer amount ₹100.00
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Amount (₹)'), '100');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Note (Optional)'),
        'ATM Cash Withdrawal');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Transfer'));
    await tester.pumpAndSettle();

    // Verify transfer recorded
    final transfers = await db.transfersDao.getAllTransfers();
    expect(transfers.length, 1);
    expect(transfers.first.sourceAccountId, acc1);
    expect(transfers.first.destinationAccountId, acc2);
    expect(transfers.first.amountPaise, 10000);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
