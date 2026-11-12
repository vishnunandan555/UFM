import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/accounts_table.dart';
import '../tables/transfers_table.dart';

part 'transfers_dao.g.dart';

@DriftAccessor(tables: [Transfers, Accounts])
class TransfersDao extends DatabaseAccessor<AppDatabase>
    with _$TransfersDaoMixin {
  TransfersDao(super.db);

  Future<List<Transfer>> getAllTransfers() =>
      (select(transfers)..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
          .get();

  Stream<List<Transfer>> watchAllTransfers() =>
      (select(transfers)..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
          .watch();

  Future<List<Transfer>> getTransfersForAccount(int accountId) =>
      (select(transfers)
            ..where((t) =>
                t.sourceAccountId.equals(accountId) |
                t.destinationAccountId.equals(accountId))
            ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
          .get();

  Stream<List<Transfer>> watchTransfersForAccount(int accountId) =>
      (select(transfers)
            ..where((t) =>
                t.sourceAccountId.equals(accountId) |
                t.destinationAccountId.equals(accountId))
            ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
          .watch();

  Future<Transfer?> getTransferById(int id) =>
      (select(transfers)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertTransfer(TransfersCompanion transfer) =>
      into(transfers).insert(transfer);
}

