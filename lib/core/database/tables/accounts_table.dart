import 'package:drift/drift.dart';

enum AccountType {
  bank,
  cash,
  other,
}

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => textEnum<AccountType>()();
  IntColumn get openingBalancePaise =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))();
  TextColumn get iconKey => text().nullable()();
  TextColumn get colourKey => text().nullable()();
}

