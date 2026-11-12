import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/database_provider.dart';
import 'package:ufm/features/accounts/presentation/accounts_screen.dart';
import 'package:ufm/features/accounts/presentation/add_account_dialog.dart';
import '../unit/database/in_memory_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('AccountsScreen shows empty state when no accounts exist',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: AccountsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No accounts yet'), findsOneWidget);
    expect(find.text('Add First Account'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('AddAccountDialog allows creating an account with opening balance',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: AccountsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Add First Account
    await tester.tap(find.text('Add First Account'));
    await tester.pumpAndSettle();

    expect(find.byType(AddAccountDialog), findsOneWidget);

    // Enter name & balance
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Account Name'), 'SBI Primary');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Opening Balance (₹)'), '500.50');
    await tester.pumpAndSettle();

    // Tap Save
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Dialog dismissed and account appears in list
    expect(find.byType(AddAccountDialog), findsNothing);
    expect(find.text('SBI Primary'), findsOneWidget);
    expect(find.text('₹500.50'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
