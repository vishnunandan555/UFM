import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/accounts_table.dart';
import '../tables/categories_table.dart';
import '../tables/payment_attempts_table.dart';
import '../tables/transactions_table.dart';

part 'payment_attempts_dao.g.dart';

@DriftAccessor(
    tables: [PaymentAttempts, Accounts, Categories, Transactions])
class PaymentAttemptsDao extends DatabaseAccessor<AppDatabase>
    with _$PaymentAttemptsDaoMixin {
  PaymentAttemptsDao(super.db);

  Future<List<PaymentAttempt>> getAllAttempts() =>
      (select(paymentAttempts)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<PaymentAttempt>> getUnverifiedAttempts() =>
      (select(paymentAttempts)
            ..where((t) => t.status.equals(PaymentAttemptStatus.unverified.name))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Stream<List<PaymentAttempt>> watchUnverifiedAttempts() =>
      (select(paymentAttempts)
            ..where((t) => t.status.equals(PaymentAttemptStatus.unverified.name))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<PaymentAttempt?> getAttemptById(int id) =>
      (select(paymentAttempts)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertAttempt(PaymentAttemptsCompanion attempt) =>
      into(paymentAttempts).insert(attempt);

  Future<int> updateAttemptStatus(
    int id,
    PaymentAttemptStatus status, {
    DateTime? resolvedAt,
    String? launchError,
  }) {
    return (update(paymentAttempts)..where((t) => t.id.equals(id))).write(
      PaymentAttemptsCompanion(
        status: Value(status),
        resolvedAt: Value(resolvedAt ?? DateTime.now()),
        launchError: Value(launchError),
      ),
    );
  }

  Future<int> linkTransaction(int id, int transactionId) {
    return (update(paymentAttempts)..where((t) => t.id.equals(id))).write(
      PaymentAttemptsCompanion(
        linkedTransactionId: Value(transactionId),
        resolvedAt: Value(DateTime.now()),
      ),
    );
  }
}

