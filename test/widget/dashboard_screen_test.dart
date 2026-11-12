import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/database_provider.dart';
import 'package:ufm/core/database/tables/accounts_table.dart';
import 'package:ufm/features/dashboard/presentation/dashboard_screen.dart';
import 'package:ufm/features/transactions/presentation/add_transaction_dialog.dart';
import '../unit/database/in_memory_database.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = createTestDatabase();
    await db.accountsDao.insertAccount(
      const AccountsCompanion(
        name: drift.Value('HDFC Bank'),
        type: drift.Value(AccountType.bank),
        openingBalancePaise: drift.Value(100000), // ₹1,000.00
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('DashboardScreen renders balance and quick action buttons',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Total Confirmed Balance'), findsOneWidget);
    expect(find.text('₹1,000.00'), findsWidgets);
    expect(find.text('Expense'), findsOneWidget);
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Transfer'), findsOneWidget);
    expect(find.text('HDFC Bank'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('Tapping Expense opens AddTransactionDialog', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Expense'));
    await tester.pumpAndSettle();

    expect(find.byType(AddTransactionDialog), findsOneWidget);
    expect(find.text('Add Expense'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
