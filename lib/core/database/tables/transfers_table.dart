import 'package:drift/drift.dart';
import 'accounts_table.dart';

class Transfers extends Table {
  IntColumn get id => integer().autoIncrement()();

  @ReferenceName('outgoingTransfers')
  IntColumn get sourceAccountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.restrict)();

  @ReferenceName('incomingTransfers')
  IntColumn get destinationAccountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.restrict)();

  IntColumn get amountPaise => integer()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => [
        'CHECK (source_account_id <> destination_account_id)',
        'CHECK (amount_paise > 0)',
      ];
}
