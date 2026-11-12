import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/tables/categories_table.dart';
import '../../../domain/entities/account_balance.dart';

final activeAccountsStreamProvider = StreamProvider<List<Account>>((ref) {
  final dao = ref.watch(accountsDaoProvider);
  return dao.watchActiveAccounts();
});

final totalConfirmedBalanceStreamProvider = StreamProvider<int>((ref) {
  final ledger = ref.watch(ledgerServiceProvider);
  return ledger.watchTotalConfirmedBalancePaise();
});

final accountBalanceStreamProvider =
    StreamProvider.family<AccountBalanceEntity, int>((ref, accountId) {
  final ledger = ref.watch(ledgerServiceProvider);
  return ledger.watchAccountBalance(accountId);
});

final recentTransactionsStreamProvider =
    StreamProvider<List<Transaction>>((ref) {
  final dao = ref.watch(transactionsDaoProvider);
  return dao.watchAllTransactions();
});

final allTransfersStreamProvider = StreamProvider<List<Transfer>>((ref) {
  final dao = ref.watch(transfersDaoProvider);
  return dao.watchAllTransfers();
});

final unverifiedAttemptsStreamProvider =
    StreamProvider<List<PaymentAttempt>>((ref) {
  final dao = ref.watch(paymentAttemptsDaoProvider);
  return dao.watchUnverifiedAttempts();
});

final categoriesByKindProvider =
    FutureProvider.family<List<Category>, CategoryKind?>((ref, kind) async {
  final dao = ref.watch(categoriesDaoProvider);
  if (kind == null) {
    return dao.getActiveCategories();
  }
  return dao.getCategoriesByKind(kind);
});
