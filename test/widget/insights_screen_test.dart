import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/database_provider.dart';
import 'package:ufm/core/database/tables/accounts_table.dart';
import 'package:ufm/core/database/tables/transactions_table.dart';
import 'package:ufm/features/insights/presentation/insights_screen.dart';
import '../unit/database/in_memory_database.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = createTestDatabase();
    final acc = await db.accountsDao.insertAccount(
      const AccountsCompanion(
        name: drift.Value('Primary Bank'),
        type: drift.Value(AccountType.bank),
        openingBalancePaise: drift.Value(500000),
      ),
    );

    // Insert income for current month
    await db.transactionsDao.insertTransaction(
      TransactionsCompanion.insert(
        accountId: acc,
        type: TransactionType.income,
        amountPaise: 80000, // ₹800.00
        merchant: const drift.Value('Client Payment'),
        occurredAt: DateTime.now(),
        source: TransactionSource.manual,
        paymentMethod: PaymentMethod.other,
      ),
    );

    // Insert expense for current month
    await db.transactionsDao.insertTransaction(
      TransactionsCompanion.insert(
        accountId: acc,
        type: TransactionType.expense,
        amountPaise: 30000, // ₹300.00
        merchant: const drift.Value('Utilities Bill'),
        occurredAt: DateTime.now(),
        source: TransactionSource.manual,
        paymentMethod: PaymentMethod.other,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets(
      'InsightsScreen calculates and displays monthly Income, Expense, and Savings',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: InsightsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Expense'), findsOneWidget);
    expect(find.text('Savings'), findsOneWidget);

    // Income ₹800.00
    expect(find.text('₹800.00'), findsOneWidget);
    // Expense ₹300.00
    expect(find.text('₹300.00'), findsWidgets);
    // Savings ₹500.00
    expect(find.text('₹500.00'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('InsightsScreen displays empty state when navigating to past month',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: InsightsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap previous month chevron button
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();

    expect(find.text('No expenses recorded for this month'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
