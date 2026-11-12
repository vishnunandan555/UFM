import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/database_provider.dart';
import 'package:ufm/core/database/tables/accounts_table.dart';
import 'package:ufm/core/database/tables/payment_attempts_table.dart';
import 'package:ufm/features/upi/app_selector/preferred_upi_app_service.dart';
import 'package:ufm/features/upi/domain/upi_payment_draft.dart';
import 'package:ufm/features/upi/platform/installed_upi_app.dart';
import 'package:ufm/features/upi/platform/upi_launch_result.dart';
import 'package:ufm/features/upi/platform/upi_platform.dart';
import 'package:ufm/features/upi/platform/upi_platform_provider.dart';
import 'package:ufm/features/upi/presentation/qr_review_screen.dart';
import '../unit/database/in_memory_database.dart';

class MockUpiPlatform implements UpiPlatform {
  MockUpiPlatform({
    this.apps = const [],
    this.launchResult = const UpiLaunchResult(status: UpiLaunchStatus.launched),
  });

  final List<InstalledUpiApp> apps;
  final UpiLaunchResult launchResult;
  String? lastLaunchedPackage;
  String? lastLaunchedUri;

  @override
  Future<List<InstalledUpiApp>> getCompatibleApps() async => apps;

  @override
  Future<UpiLaunchResult> launchPayment({
    required String packageName,
    required String paymentUri,
  }) async {
    lastLaunchedPackage = packageName;
    lastLaunchedUri = paymentUri;
    return launchResult;
  }
}

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
          upiPlatformProvider.overrideWithValue(MockUpiPlatform()),
          preferredUpiAppServiceProvider
              .overrideWithValue(InMemoryPreferredUpiAppService()),
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
          upiPlatformProvider.overrideWithValue(MockUpiPlatform()),
          preferredUpiAppServiceProvider
              .overrideWithValue(InMemoryPreferredUpiAppService()),
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

  testWidgets(
      'QrReviewScreen launches intent with selected app and records launch details in DB',
      (tester) async {
    const draft = UpiPaymentDraft(
      payeeVpa: 'chai@upi',
      payeeName: 'Chai Point',
      amountPaise: 5000,
      amountWasProvidedByQr: true,
      rawUri: 'upi://pay?pa=chai@upi&pn=Chai%20Point&am=50.00&cu=INR',
    );

    final mockPlatform = MockUpiPlatform(
      apps: const [
        InstalledUpiApp(
          packageName: 'com.phonepe.app',
          appName: 'PhonePe',
          isTestApp: false,
        ),
        InstalledUpiApp(
          packageName: 'com.ufm.fakeupi',
          appName: 'Fake UPI',
          isTestApp: true,
        ),
      ],
    );

    final prefService = InMemoryPreferredUpiAppService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          upiPlatformProvider.overrideWithValue(mockPlatform),
          preferredUpiAppServiceProvider.overrideWithValue(prefService),
        ],
        child: const MaterialApp(
          home: QrReviewScreen(draft: draft),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap proceed to trigger discovery and app selector
    await tester.tap(find.text('Proceed to Payment'));
    await tester.pumpAndSettle();

    // App selector bottom sheet should now be visible
    expect(find.text('Select Payment App'), findsOneWidget);
    expect(find.text('PhonePe'), findsOneWidget);
    expect(find.text('Fake UPI'), findsOneWidget);

    // Select PhonePe and tap Pay
    await tester.tap(find.text('Pay ₹50.00 with PhonePe'));
    await tester.pumpAndSettle();

    // Verify intent was launched via platform bridge
    expect(mockPlatform.lastLaunchedPackage, 'com.phonepe.app');
    final launchedUri = Uri.parse(mockPlatform.lastLaunchedUri!);
    expect(launchedUri.scheme, 'upi');
    expect(launchedUri.host, 'pay');
    expect(launchedUri.queryParameters['pa'], 'chai@upi');
    expect(launchedUri.queryParameters['am'], '50.00');

    // Verify attempt recorded in database has launch details
    final attempts = await db.paymentAttemptsDao.getAllAttempts();
    expect(attempts.length, 1);
    expect(attempts.first.selectedPaymentAppId, 'com.phonepe.app');
    expect(attempts.first.launchedAt, isNotNull);
    expect(attempts.first.launchError, isNull);
    expect(attempts.first.status, PaymentAttemptStatus.pending);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets(
      'QrReviewScreen records launch error in database when launch fails',
      (tester) async {
    const draft = UpiPaymentDraft(
      payeeVpa: 'chai@upi',
      payeeName: 'Chai Point',
      amountPaise: 5000,
      amountWasProvidedByQr: true,
      rawUri: 'upi://pay?pa=chai@upi&pn=Chai%20Point&am=50.00&cu=INR',
    );

    final mockPlatform = MockUpiPlatform(
      apps: const [
        InstalledUpiApp(
          packageName: 'com.phonepe.app',
          appName: 'PhonePe',
          isTestApp: false,
        ),
      ],
      launchResult: const UpiLaunchResult(
        status: UpiLaunchStatus.failed,
        errorMessage: 'ActivityNotFoundException',
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          upiPlatformProvider.overrideWithValue(mockPlatform),
          preferredUpiAppServiceProvider
              .overrideWithValue(InMemoryPreferredUpiAppService()),
        ],
        child: const MaterialApp(
          home: QrReviewScreen(draft: draft),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Proceed to Payment'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pay ₹50.00 with PhonePe'));
    await tester.pumpAndSettle();

    // Verify error was recorded in database
    final attempts = await db.paymentAttemptsDao.getAllAttempts();
    expect(attempts.length, 1);
    expect(attempts.first.launchError, 'ActivityNotFoundException');

    // Verify error SnackBar was shown
    expect(find.text('ActivityNotFoundException'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}

