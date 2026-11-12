import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/database_provider.dart';
import 'package:ufm/core/database/tables/accounts_table.dart';
import 'package:ufm/core/database/tables/payment_attempts_table.dart';
import 'package:ufm/features/upi/domain/upi_payment_draft.dart';
import 'package:ufm/features/upi/presentation/qr_review_screen.dart';
import '../unit/database/in_memory_database.dart';

void main() {
  late AppDatabase db;
  late int testAccount;

  setUp(() async {
    db = createTestDatabase();
    testAccount = await db.accountsDao.insertAccount(
      const AccountsCompanion(
        name: drift.Value('SBI Primary'),
        type: drift.Value(AccountType.bank),
        openingBalancePaise: drift.Value(100000), // ₹1,000.00
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets(
      'QrReviewScreen displays locked amount when QR provided fixed amount',
      (tester) async {
    const draft = UpiPaymentDraft(
      payeeVpa: 'restaurant@upi',
      payeeName: 'Urban Cafe',
      amountPaise: 45000, // ₹450.00
      amountWasProvidedByQr: true,
      rawUri: 'upi://pay?pa=restaurant@upi&pn=Urban%20Cafe&am=450.00&cu=INR',
      note: 'Dinner with friends',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: QrReviewScreen(draft: draft),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Urban Cafe'), findsOneWidget);
    expect(find.text('restaurant@upi'), findsOneWidget);
    expect(find.text('Amount specified by QR'), findsOneWidget);
    expect(find.text('₹450.00'), findsOneWidget);

    // Tap proceed
    await tester.tap(find.text('Proceed to Payment'));
    await tester.pumpAndSettle();

    // Verify pending attempt was persisted in database
    final attempts = await db.paymentAttemptsDao.getAllAttempts();
    expect(attempts.length, 1);
    expect(attempts.first.status, PaymentAttemptStatus.pending);
    expect(attempts.first.payeeVpa, 'restaurant@upi');
    expect(attempts.first.amountPaise, 45000);
    expect(attempts.first.amountWasProvidedByQr, isTrue);
    expect(attempts.first.intendedAccountId, testAccount);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets(
      'QrReviewScreen requires amount input when QR code has variable amount',
      (tester) async {
    const draft = UpiPaymentDraft(
      payeeVpa: 'vendor@okaxis',
      payeeName: 'Grocery Vendor',
      amountWasProvidedByQr: false,
      rawUri: 'upi://pay?pa=vendor@okaxis&pn=Grocery%20Vendor',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: QrReviewScreen(draft: draft),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Grocery Vendor'), findsOneWidget);
    expect(find.text('Amount specified by QR'), findsNothing);

    // Try submitting without entering amount -> validation error
    await tester.tap(find.text('Proceed to Payment'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter the payment amount'), findsOneWidget);

    // Enter amount ₹75.50
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter Amount (₹)'), '75.50');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Proceed to Payment'));
    await tester.pumpAndSettle();

    // Verify persisted attempt
    final attempts = await db.paymentAttemptsDao.getAllAttempts();
    expect(attempts.length, 1);
    expect(attempts.first.amountPaise, 7550);
    expect(attempts.first.amountWasProvidedByQr, isFalse);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
