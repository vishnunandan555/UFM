import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/database_provider.dart';
import 'package:ufm/core/database/tables/accounts_table.dart';
import 'package:ufm/core/database/tables/transactions_table.dart';
import 'package:ufm/features/history/presentation/history_screen.dart';
import '../unit/database/in_memory_database.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = createTestDatabase();
    final acc = await db.accountsDao.insertAccount(
      const AccountsCompanion(
        name: drift.Value('Savings'),
        type: drift.Value(AccountType.bank),
        openingBalancePaise: drift.Value(50000),
      ),
    );

    // Insert an expense
    await db.transactionsDao.insertTransaction(
      TransactionsCompanion.insert(
        accountId: acc,
        type: TransactionType.expense,
        amountPaise: 25000,
        merchant: const drift.Value('Supermarket'),
        occurredAt: DateTime.now(),
        source: TransactionSource.manual,
        paymentMethod: PaymentMethod.other,
      ),
    );

    // Insert an income
    await db.transactionsDao.insertTransaction(
      TransactionsCompanion.insert(
        accountId: acc,
        type: TransactionType.income,
        amountPaise: 100000,
        merchant: const drift.Value('Freelance Client'),
        occurredAt: DateTime.now(),
        source: TransactionSource.manual,
        paymentMethod: PaymentMethod.other,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('HistoryScreen renders filter chips and lists transactions',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: HistoryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('All'), findsOneWidget);
    expect(find.text('Expenses'), findsOneWidget);
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Transfers'), findsOneWidget);

    expect(find.text('Supermarket'), findsOneWidget);
    expect(find.text('Freelance Client'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('HistoryScreen filters by Expenses chip', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: HistoryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Expenses'));
    await tester.pumpAndSettle();

    expect(find.text('Supermarket'), findsOneWidget);
    expect(find.text('Freelance Client'), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
