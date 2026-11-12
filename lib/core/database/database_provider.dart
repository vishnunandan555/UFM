import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/atomic_transfer_service_impl.dart';
import '../../data/services/ledger_service_impl.dart';
import '../../domain/services/ledger_service.dart';
import '../../domain/services/transfer_service.dart';
import 'app_database.dart';
import 'daos/accounts_dao.dart';
import 'daos/categories_dao.dart';
import 'daos/payment_attempts_dao.dart';
import 'daos/transactions_dao.dart';
import 'daos/transfers_dao.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final ledgerServiceProvider = Provider<LedgerService>((ref) {
  final db = ref.watch(databaseProvider);
  return LedgerServiceImpl(db);
});

final transferServiceProvider = Provider<TransferService>((ref) {
  final db = ref.watch(databaseProvider);
  return AtomicTransferServiceImpl(db);
});

final accountsDaoProvider = Provider<AccountsDao>((ref) {
  return ref.watch(databaseProvider).accountsDao;
});

final categoriesDaoProvider = Provider<CategoriesDao>((ref) {
  return ref.watch(databaseProvider).categoriesDao;
});

final transactionsDaoProvider = Provider<TransactionsDao>((ref) {
  return ref.watch(databaseProvider).transactionsDao;
});

final transfersDaoProvider = Provider<TransfersDao>((ref) {
  return ref.watch(databaseProvider).transfersDao;
});

final paymentAttemptsDaoProvider = Provider<PaymentAttemptsDao>((ref) {
  return ref.watch(databaseProvider).paymentAttemptsDao;
});

