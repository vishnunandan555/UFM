import '../entities/account_balance.dart';

abstract interface class LedgerService {
  Future<AccountBalanceEntity> getAccountBalance(int accountId);
  Stream<AccountBalanceEntity> watchAccountBalance(int accountId);
  Future<int> getTotalConfirmedBalancePaise();
  Stream<int> watchTotalConfirmedBalancePaise();
}

