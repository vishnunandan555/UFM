import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/database_provider.dart';
import 'package:ufm/core/database/tables/accounts_table.dart';
import 'package:ufm/core/database/tables/payment_attempts_table.dart';
import 'package:ufm/features/upi/confirmation/payment_confirmation_dialog.dart';
import '../unit/database/in_memory_database.dart';

void main() {
  late AppDatabase db;
  late int acc1;
  late int acc2;

  setUp(() async {
    db = createTestDatabase();
    acc1 = await db.accountsDao.insertAccount(
      const AccountsCompanion(
        name: drift.Value('SBI Primary'),
        type: drift.Value(AccountType.bank),
        openingBalancePaise: drift.Value(100000), // ₹1,000.00
      ),
    );
    acc2 = await db.accountsDao.insertAccount(
      const AccountsCompanion(
        name: drift.Value('HDFC Savings'),
        type: drift.Value(AccountType.bank),
        openingBalancePaise: drift.Value(200000), // ₹2,000.00
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets(
      'PaymentConfirmationDialog confirms payment and links transaction atomically',
      (tester) async {
    final attemptId = await db.paymentAttemptsDao.insertAttempt(
      PaymentAttemptsCompanion.insert(
        status: PaymentAttemptStatus.pending,
        payeeName: 'Organic Grocers',
        payeeVpa: 'grocer@upi',
        amountPaise: 35000, // ₹350.00
        amountWasProvidedByQr: true,
        intendedAccountId: acc1,
      ),
    );

    final attempt = await db.paymentAttemptsDao.getAttemptById(attemptId);
    expect(attempt, isNotNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PaymentConfirmationDialog(attempt: attempt!),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Organic Grocers'), findsOneWidget);
    expect(find.text('grocer@upi'), findsOneWidget);
    expect(find.text('₹350.00'), findsOneWidget);

    // Tap Yes (Confirmed)
    await tester.tap(find.text('Yes (Confirmed)'));
    await tester.pumpAndSettle();

    // Verify attempt is confirmed and linked to a transaction
    final updatedAttempt =
        await db.paymentAttemptsDao.getAttemptById(attemptId);
    expect(updatedAttempt!.status, PaymentAttemptStatus.confirmed);
    expect(updatedAttempt.linkedTransactionId, isNotNull);

    final tx = await db.transactionsDao
        .getTransactionById(updatedAttempt.linkedTransactionId!);
    expect(tx, isNotNull);
    expect(tx!.amountPaise, 35000);
    expect(tx.accountId, acc1);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets(
      'PaymentConfirmationDialog allows correcting the actual funding account',
      (tester) async {
    final attemptId = await db.paymentAttemptsDao.insertAttempt(
      PaymentAttemptsCompanion.insert(
        status: PaymentAttemptStatus.pending,
        payeeName: 'Bookstore',
        payeeVpa: 'books@upi',
        amountPaise: 12000, // ₹120.00
        amountWasProvidedByQr: true,
        intendedAccountId: acc1, // Intended was acc1
      ),
    );

    final attempt = await db.paymentAttemptsDao.getAttemptById(attemptId);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PaymentConfirmationDialog(attempt: attempt!),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Switch account to HDFC Savings (acc2)
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('HDFC Savings (bank)').last);
    await tester.pumpAndSettle();

    // Tap Yes (Confirmed)
    await tester.tap(find.text('Yes (Confirmed)'));
    await tester.pumpAndSettle();

    // Transaction debits acc2
    final updatedAttempt =
        await db.paymentAttemptsDao.getAttemptById(attemptId);
    expect(updatedAttempt!.actualFundingAccountId, acc2);

    final tx = await db.transactionsDao
        .getTransactionById(updatedAttempt.linkedTransactionId!);
    expect(tx!.accountId, acc2);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('PaymentConfirmationDialog handles No (Failed) outcome',
      (tester) async {
    final attemptId = await db.paymentAttemptsDao.insertAttempt(
      PaymentAttemptsCompanion.insert(
        status: PaymentAttemptStatus.pending,
        payeeName: 'Tea Stall',
        payeeVpa: 'tea@upi',
        amountPaise: 2000,
        amountWasProvidedByQr: true,
        intendedAccountId: acc1,
      ),
    );

    final attempt = await db.paymentAttemptsDao.getAttemptById(attemptId);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PaymentConfirmationDialog(attempt: attempt!),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap No (Failed)
    await tester.tap(find.text('No (Failed)'));
    await tester.pumpAndSettle();

    final updatedAttempt =
        await db.paymentAttemptsDao.getAttemptById(attemptId);
    expect(updatedAttempt!.status, PaymentAttemptStatus.failed);
    expect(updatedAttempt.linkedTransactionId, isNull);

    final txs = await db.transactionsDao.getAllTransactions();
    expect(txs.isEmpty, isTrue);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
