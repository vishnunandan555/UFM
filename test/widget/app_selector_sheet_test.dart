import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/features/upi/app_selector/app_selector_sheet.dart';
import 'package:ufm/features/upi/platform/installed_upi_app.dart';

void main() {
  const sampleApps = [
    InstalledUpiApp(
      packageName: 'com.phonepe.app',
      appName: 'PhonePe',
      isTestApp: false,
    ),
    InstalledUpiApp(
      packageName: 'com.google.android.apps.nbu.paisa.user',
      appName: 'Google Pay',
      isTestApp: false,
    ),
    InstalledUpiApp(
      packageName: 'com.ufm.fakeupi',
      appName: 'Fake UPI',
      isTestApp: true,
    ),
  ];

  testWidgets('AppSelectorSheet renders empty state when no apps available',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppSelectorSheet(
            apps: [],
            amountPaise: 25000,
            payeeName: 'Urban Cafe',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No Compatible UPI Apps Found'), findsOneWidget);
    expect(find.text('Dismiss'), findsOneWidget);
    expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
  });

  testWidgets('AppSelectorSheet renders apps, badges, and preferred indicator',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppSelectorSheet(
            apps: sampleApps,
            amountPaise: 45000,
            payeeName: 'Chai Point',
            preferredPackageName: 'com.phonepe.app',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify header and summary
    expect(find.text('Select Payment App'), findsOneWidget);
    expect(find.text('Pay ₹450.00 to Chai Point'), findsOneWidget);

    // Verify app names
    expect(find.text('PhonePe'), findsOneWidget);
    expect(find.text('Google Pay'), findsOneWidget);
    expect(find.text('Fake UPI'), findsOneWidget);

    // Verify badges
    expect(find.text('Preferred'), findsOneWidget);
    expect(find.text('TEST APP'), findsOneWidget);

    // Verify pay button default label reflects preferred selection
    expect(find.text('Pay ₹450.00 with PhonePe'), findsOneWidget);
  });

  testWidgets(
      'AppSelectorSheet allows switching selection and toggling remember preference',
      (tester) async {
    AppSelectionResult? capturedResult;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    capturedResult = await AppSelectorSheet.show(
                      context: context,
                      apps: sampleApps,
                      amountPaise: 12050, // ₹120.50
                      payeeName: 'Baker Street',
                    );
                  },
                  child: const Text('Open Sheet'),
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Open bottom sheet
    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    // Tap Google Pay item
    await tester.tap(find.text('Google Pay'));
    await tester.pumpAndSettle();

    // Check "Remember as preferred UPI app"
    await tester.tap(find.text('Remember as preferred UPI app'));
    await tester.pumpAndSettle();

    // Tap Pay button
    await tester.tap(find.text('Pay ₹120.50 with Google Pay'));
    await tester.pumpAndSettle();

    // Verify result returned
    expect(capturedResult, isNotNull);
    expect(
      capturedResult!.app.packageName,
      'com.google.android.apps.nbu.paisa.user',
    );
    expect(capturedResult!.rememberAsPreferred, isTrue);
  });

  testWidgets('AppSelectorSheet adheres to accessibility touch targets (>= 48 dp)',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppSelectorSheet(
            apps: sampleApps,
            amountPaise: 50000,
            payeeName: 'Store',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Pay button height >= 48dp
    final payButtonFinder = find.widgetWithText(FilledButton, 'Pay ₹500.00 with Google Pay');
    expect(payButtonFinder, findsOneWidget);
    final buttonSize = tester.getSize(payButtonFinder);
    expect(buttonSize.height, greaterThanOrEqualTo(48.0));
  });

  testWidgets(
      'AppSelectorSheet deduplicates apps with identical package names without crashing',
      (tester) async {
    const appsWithDuplicates = [
      InstalledUpiApp(
        packageName: 'com.duplicate.upi',
        appName: 'Duplicate Alpha',
        isTestApp: false,
      ),
      InstalledUpiApp(
        packageName: 'com.duplicate.upi',
        appName: 'Duplicate Beta',
        isTestApp: false,
      ),
      InstalledUpiApp(
        packageName: 'com.unique.upi',
        appName: 'Unique App',
        isTestApp: false,
      ),
    ];

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppSelectorSheet(
            apps: appsWithDuplicates,
            amountPaise: 15000,
            payeeName: 'Test Merchant',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify no assertion error occurred and only the first instance of com.duplicate.upi is shown
    expect(find.text('Duplicate Alpha'), findsOneWidget);
    expect(find.text('Duplicate Beta'), findsNothing);
    expect(find.text('Unique App'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
