import 'package:drift/drift.dart';
import '../../core/database/app_database.dart';
import '../../core/errors/failures.dart';
import '../../domain/services/transfer_service.dart';

class AtomicTransferServiceImpl implements TransferService {
  final AppDatabase db;

  AtomicTransferServiceImpl(this.db);

  @override
  Future<int> executeTransfer({
    required int sourceAccountId,
    required int destinationAccountId,
    required int amountPaise,
    required DateTime occurredAt,
    String? note,
  }) async {
    if (sourceAccountId == destinationAccountId) {
      throw SameAccountTransferFailure(sourceAccountId);
    }
    if (amountPaise <= 0) {
      throw InvalidAmountFailure(amountPaise);
    }

    return await db.transaction(() async {
      final source = await (db.select(db.accounts)
            ..where((t) => t.id.equals(sourceAccountId)))
          .getSingleOrNull();
      if (source == null) {
        throw AccountNotFoundFailure(sourceAccountId);
      }
      if (source.isArchived) {
        throw DatabaseFailure(
            'Cannot transfer from archived account $sourceAccountId');
      }

      final destination = await (db.select(db.accounts)
            ..where((t) => t.id.equals(destinationAccountId)))
          .getSingleOrNull();
      if (destination == null) {
        throw AccountNotFoundFailure(destinationAccountId);
      }
      if (destination.isArchived) {
        throw DatabaseFailure(
            'Cannot transfer to archived account $destinationAccountId');
      }

      final transferId = await db.into(db.transfers).insert(
            TransfersCompanion.insert(
              sourceAccountId: sourceAccountId,
              destinationAccountId: destinationAccountId,
              amountPaise: amountPaise,
              occurredAt: occurredAt,
              note: Value(note),
              createdAt: Value(DateTime.now()),
            ),
          );

      return transferId;
    });
  }
}

