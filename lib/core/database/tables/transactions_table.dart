import 'package:drift/drift.dart';
import 'accounts_table.dart';
import 'categories_table.dart';
import 'payment_attempts_table.dart';

enum TransactionType {
  expense,
  income,
}

enum TransactionSource {
  manual,
  upiQr,
}

enum PaymentMethod {
  cash,
  upi,
  other,
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  @ReferenceName('accountTransactions')
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.restrict)();

  TextColumn get type => textEnum<TransactionType>()();
  IntColumn get amountPaise => integer()();
  IntColumn get categoryId => integer()
      .nullable()
      .references(Categories, #id, onDelete: KeyAction.setNull)();
  TextColumn get merchant => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get source => textEnum<TransactionSource>()();
  TextColumn get paymentMethod => textEnum<PaymentMethod>()();
  TextColumn get paymentAppId => text().nullable()();

  @ReferenceName('actualFundingAccountTransactions')
  IntColumn get actualFundingAccountId => integer()
      .nullable()
      .references(Accounts, #id, onDelete: KeyAction.setNull)();

  IntColumn get paymentAttemptId => integer()
      .nullable()
      .unique()
      .references(PaymentAttempts, #id, onDelete: KeyAction.setNull)();

  TextColumn get externalReference => text().nullable()();

  @override
  List<String> get customConstraints => [
        'CHECK (amount_paise > 0)',
      ];
}
