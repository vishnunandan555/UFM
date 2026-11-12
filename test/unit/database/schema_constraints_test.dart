import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart' show SqliteException;
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/tables/accounts_table.dart';
import 'package:ufm/core/database/tables/payment_attempts_table.dart';
import 'package:ufm/core/database/tables/transactions_table.dart';
import 'in_memory_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('Schema Constraints: Foreign Key Enforcement', () {
    test('rejects transaction insertion with non-existent accountId', () async {
      expect(
        () => db.into(db.transactions).insert(
              TransactionsCompanion.insert(
                accountId: 9999, // Does not exist
                type: TransactionType.expense,
                amountPaise: 1500,
                occurredAt: DateTime.now(),
                source: TransactionSource.manual,
                paymentMethod: PaymentMethod.cash,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('rejects transfer with non-existent source account', () async {
      final accId = await db.into(db.accounts).insert(
            const AccountsCompanion(
              name: Value('Valid Account'),
              type: Value(AccountType.bank),
            ),
          );

      expect(
        () => db.into(db.transfers).insert(
              TransfersCompanion.insert(
                sourceAccountId: 8888, // Invalid
                destinationAccountId: accId,
                amountPaise: 1000,
                occurredAt: DateTime.now(),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('rejects transfer with non-existent destination account', () async {
      final accId = await db.into(db.accounts).insert(
            const AccountsCompanion(
              name: Value('Valid Account'),
              type: Value(AccountType.bank),
            ),
          );

      expect(
        () => db.into(db.transfers).insert(
              TransfersCompanion.insert(
                sourceAccountId: accId,
                destinationAccountId: 8888, // Invalid
                amountPaise: 1000,
                occurredAt: DateTime.now(),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('rejects payment attempt with non-existent intended account', () async {
      expect(
        () => db.into(db.paymentAttempts).insert(
              PaymentAttemptsCompanion.insert(
                status: PaymentAttemptStatus.pending,
                payeeName: 'Merchant',
                payeeVpa: 'merchant@upi',
                amountPaise: 2000,
                amountWasProvidedByQr: true,
                intendedAccountId: 7777, // Invalid
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('restricts deletion of account that has associated transactions',
        () async {
      final accId = await db.into(db.accounts).insert(
            const AccountsCompanion(
              name: Value('HDFC Bank'),
              type: Value(AccountType.bank),
            ),
          );

      await db.into(db.transactions).insert(
            TransactionsCompanion.insert(
              accountId: accId,
              type: TransactionType.income,
              amountPaise: 50000,
              occurredAt: DateTime.now(),
              source: TransactionSource.manual,
              paymentMethod: PaymentMethod.other,
            ),
          );

      // Attempting to delete account must fail due to ON DELETE RESTRICT
      expect(
        () => (db.delete(db.accounts)..where((t) => t.id.equals(accId))).go(),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  group('Schema Constraints: Check Constraints', () {
    test('rejects transaction with zero or negative amount', () async {
      final accId = await db.into(db.accounts).insert(
            const AccountsCompanion(
              name: Value('SBI Bank'),
              type: Value(AccountType.bank),
            ),
          );

      // Zero amount
      expect(
        () => db.into(db.transactions).insert(
              TransactionsCompanion.insert(
                accountId: accId,
                type: TransactionType.expense,
                amountPaise: 0,
                occurredAt: DateTime.now(),
                source: TransactionSource.manual,
                paymentMethod: PaymentMethod.cash,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );

      // Negative amount
      expect(
        () => db.into(db.transactions).insert(
              TransactionsCompanion.insert(
                accountId: accId,
                type: TransactionType.expense,
                amountPaise: -500,
                occurredAt: DateTime.now(),
                source: TransactionSource.manual,
                paymentMethod: PaymentMethod.cash,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('rejects transfer with zero or negative amount', () async {
      final acc1 = await db.into(db.accounts).insert(
            const AccountsCompanion(
              name: Value('Acc 1'),
              type: Value(AccountType.bank),
            ),
          );
      final acc2 = await db.into(db.accounts).insert(
            const AccountsCompanion(
              name: Value('Acc 2'),
              type: Value(AccountType.bank),
            ),
          );

      // Zero amount
      expect(
        () => db.into(db.transfers).insert(
              TransfersCompanion.insert(
                sourceAccountId: acc1,
                destinationAccountId: acc2,
                amountPaise: 0,
                occurredAt: DateTime.now(),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );

      // Negative amount
      expect(
        () => db.into(db.transfers).insert(
              TransfersCompanion.insert(
                sourceAccountId: acc1,
                destinationAccountId: acc2,
                amountPaise: -1000,
                occurredAt: DateTime.now(),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('rejects transfer where source and destination are the same account',
        () async {
      final acc = await db.into(db.accounts).insert(
            const AccountsCompanion(
              name: Value('Solo Acc'),
              type: Value(AccountType.cash),
            ),
          );

      expect(
        () => db.into(db.transfers).insert(
              TransfersCompanion.insert(
                sourceAccountId: acc,
                destinationAccountId: acc,
                amountPaise: 5000,
                occurredAt: DateTime.now(),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('rejects payment attempt with zero or negative amount', () async {
      final acc = await db.into(db.accounts).insert(
            const AccountsCompanion(
              name: Value('Payment Acc'),
              type: Value(AccountType.bank),
            ),
          );

      expect(
        () => db.into(db.paymentAttempts).insert(
              PaymentAttemptsCompanion.insert(
                status: PaymentAttemptStatus.pending,
                payeeName: 'Merchant',
                payeeVpa: 'm@upi',
                amountPaise: 0,
                amountWasProvidedByQr: false,
                intendedAccountId: acc,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );

      expect(
        () => db.into(db.paymentAttempts).insert(
              PaymentAttemptsCompanion.insert(
                status: PaymentAttemptStatus.pending,
                payeeName: 'Merchant',
                payeeVpa: 'm@upi',
                amountPaise: -250,
                amountWasProvidedByQr: false,
                intendedAccountId: acc,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  group('Schema Constraints: Unique Constraints', () {
    test(
        'prevents multiple transactions from linking to same paymentAttemptId',
        () async {
      final acc = await db.into(db.accounts).insert(
            const AccountsCompanion(
              name: Value('Bank'),
              type: Value(AccountType.bank),
            ),
          );

      final attemptId = await db.into(db.paymentAttempts).insert(
            PaymentAttemptsCompanion.insert(
              status: PaymentAttemptStatus.confirmed,
              payeeName: 'Vendor',
              payeeVpa: 'v@upi',
              amountPaise: 5000,
              amountWasProvidedByQr: true,
              intendedAccountId: acc,
            ),
          );

      // First transaction succeeds
      await db.into(db.transactions).insert(
            TransactionsCompanion.insert(
              accountId: acc,
              type: TransactionType.expense,
              amountPaise: 5000,
              occurredAt: DateTime.now(),
              source: TransactionSource.upiQr,
              paymentMethod: PaymentMethod.upi,
              paymentAttemptId: Value(attemptId),
            ),
          );

      // Second transaction linking to the same paymentAttemptId MUST fail
      expect(
        () => db.into(db.transactions).insert(
              TransactionsCompanion.insert(
                accountId: acc,
                type: TransactionType.expense,
                amountPaise: 5000,
                occurredAt: DateTime.now(),
                source: TransactionSource.upiQr,
                paymentMethod: PaymentMethod.upi,
                paymentAttemptId: Value(attemptId),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test(
        'prevents multiple payment attempts from linking to same transactionId',
        () async {
      final acc = await db.into(db.accounts).insert(
            const AccountsCompanion(
              name: Value('Bank'),
              type: Value(AccountType.bank),
            ),
          );

      final txId = await db.into(db.transactions).insert(
            TransactionsCompanion.insert(
              accountId: acc,
              type: TransactionType.expense,
              amountPaise: 5000,
              occurredAt: DateTime.now(),
              source: TransactionSource.manual,
              paymentMethod: PaymentMethod.cash,
            ),
          );

      // First attempt links successfully
      await db.into(db.paymentAttempts).insert(
            PaymentAttemptsCompanion.insert(
              status: PaymentAttemptStatus.confirmed,
              payeeName: 'Shop A',
              payeeVpa: 'a@upi',
              amountPaise: 5000,
              amountWasProvidedByQr: true,
              intendedAccountId: acc,
              linkedTransactionId: Value(txId),
            ),
          );

      // Second attempt linking to same txId MUST fail
      expect(
        () => db.into(db.paymentAttempts).insert(
              PaymentAttemptsCompanion.insert(
                status: PaymentAttemptStatus.confirmed,
                payeeName: 'Shop B',
                payeeVpa: 'b@upi',
                amountPaise: 5000,
                amountWasProvidedByQr: true,
                intendedAccountId: acc,
                linkedTransactionId: Value(txId),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });
  });
}
