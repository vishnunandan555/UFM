import 'package:drift/drift.dart';
import 'accounts_table.dart';
import 'categories_table.dart';
import 'transactions_table.dart';

enum PaymentAttemptStatus {
  pending,
  confirmed,
  failed,
  unverified,
}

class PaymentAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get status => textEnum<PaymentAttemptStatus>()();
  TextColumn get payeeName => text().withLength(min: 1, max: 200)();
  TextColumn get payeeVpa => text().withLength(min: 3, max: 100)();
  IntColumn get amountPaise => integer()();
  BoolColumn get amountWasProvidedByQr => boolean()();
  TextColumn get rawQrPayload => text().nullable()();
  IntColumn get categoryId => integer()
      .nullable()
      .references(Categories, #id, onDelete: KeyAction.setNull)();
  TextColumn get note => text().nullable()();

  @ReferenceName('intendedAccountPaymentAttempts')
  IntColumn get intendedAccountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.restrict)();

  @ReferenceName('actualFundingAccountPaymentAttempts')
  IntColumn get actualFundingAccountId => integer()
      .nullable()
      .references(Accounts, #id, onDelete: KeyAction.setNull)();

  TextColumn get selectedPaymentAppId => text().nullable()();
  TextColumn get externalReference => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get launchedAt => dateTime().nullable()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();
  IntColumn get linkedTransactionId => integer()
      .nullable()
      .unique()
      .references(Transactions, #id, onDelete: KeyAction.setNull)();
  TextColumn get launchError => text().nullable()();

  @override
  List<String> get customConstraints => [
        'CHECK (amount_paise > 0)',
      ];
}
