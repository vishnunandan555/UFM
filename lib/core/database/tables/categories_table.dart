import 'package:drift/drift.dart';

enum CategoryKind {
  expense,
  income,
  both,
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get kind => textEnum<CategoryKind>()();
  TextColumn get iconKey => text().nullable()();
  BoolColumn get isDefault =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

