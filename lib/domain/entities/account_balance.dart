class AccountBalanceEntity {
  final int accountId;
  final String accountName;
  final int openingBalancePaise;
  final int confirmedIncomePaise;
  final int confirmedExpensePaise;
  final int transfersInPaise;
  final int transfersOutPaise;
  final int currentBalancePaise;

  const AccountBalanceEntity({
    required this.accountId,
    required this.accountName,
    required this.openingBalancePaise,
    required this.confirmedIncomePaise,
    required this.confirmedExpensePaise,
    required this.transfersInPaise,
    required this.transfersOutPaise,
    required this.currentBalancePaise,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountBalanceEntity &&
          runtimeType == other.runtimeType &&
          accountId == other.accountId &&
          accountName == other.accountName &&
          openingBalancePaise == other.openingBalancePaise &&
          confirmedIncomePaise == other.confirmedIncomePaise &&
          confirmedExpensePaise == other.confirmedExpensePaise &&
          transfersInPaise == other.transfersInPaise &&
          transfersOutPaise == other.transfersOutPaise &&
          currentBalancePaise == other.currentBalancePaise;

  @override
  int get hashCode => Object.hash(
        accountId,
        accountName,
        openingBalancePaise,
        confirmedIncomePaise,
        confirmedExpensePaise,
        transfersInPaise,
        transfersOutPaise,
        currentBalancePaise,
      );

  @override
  String toString() =>
      'AccountBalanceEntity(accountId: $accountId, accountName: $accountName, balance: $currentBalancePaise paise)';
}

