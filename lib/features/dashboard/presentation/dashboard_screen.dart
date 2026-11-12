import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/tables/transactions_table.dart';
import '../../../core/utilities/money_formatter.dart';
import '../../accounts/presentation/add_account_dialog.dart';
import '../../transactions/presentation/add_transaction_dialog.dart';
import '../../transactions/presentation/transfer_dialog.dart';
import '../providers/dashboard_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totalBalanceAsync = ref.watch(totalConfirmedBalanceStreamProvider);
    final accountsAsync = ref.watch(activeAccountsStreamProvider);
    final recentTransactionsAsync = ref.watch(recentTransactionsStreamProvider);
    final unverifiedAsync = ref.watch(unverifiedAttemptsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('UFM'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            tooltip: 'Manage Accounts',
            onPressed: () => context.go('/accounts'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(totalConfirmedBalanceStreamProvider);
          ref.invalidate(activeAccountsStreamProvider);
          ref.invalidate(recentTransactionsStreamProvider);
          ref.invalidate(unverifiedAttemptsStreamProvider);
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // 1. Unverified attempts banner (if any)
            unverifiedAsync.when(
              data: (attempts) {
                if (attempts.isEmpty) return const SizedBox.shrink();
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.warningAmber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.warningAmber.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.pending_actions,
                          color: AppTheme.warningAmber),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${attempts.length} unverified payment${attempts.length > 1 ? 's' : ''} awaiting review',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/history'),
                        child: const Text('Review'),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // 2. Confirmed Total Balance Card
            Card(
              elevation: 0,
              color: theme.colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Confirmed Balance',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    totalBalanceAsync.when(
                      data: (balancePaise) => Text(
                        MoneyFormatter.formatPaise(balancePaise),
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      error: (err, _) => Text(
                        'Error',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Combined across active bank and cash accounts',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3. Quick Actions Row
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const AddTransactionDialog(
                          initialType: TransactionType.expense,
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_downward,
                        color: AppTheme.expenseRed),
                    label: const Text('Expense'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const AddTransactionDialog(
                          initialType: TransactionType.income,
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_upward,
                        color: AppTheme.incomeGreen),
                    label: const Text('Income'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const TransferDialog(),
                      );
                    },
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Transfer'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 4. Accounts Overview Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Accounts',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/accounts'),
                  child: const Text('See All'),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Accounts Horizontal Chips / Cards
            accountsAsync.when(
              data: (accounts) {
                if (accounts.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: theme.colorScheme.outline),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                                'No accounts added yet. Add an account to begin.'),
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => const AddAccountDialog(),
                              );
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 105,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: accounts.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      if (index == accounts.length) {
                        return OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => const AddAccountDialog(),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add'),
                        );
                      }

                      final account = accounts[index];
                      return _DashboardAccountCard(account: account);
                    },
                  ),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const Text('Error loading accounts'),
            ),

            const SizedBox(height: 24),

            // 5. Recent Transactions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/history'),
                  child: const Text('View History'),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Recent Transactions List
            recentTransactionsAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 32, horizontal: 16),
                      child: Column(
                        children: [
                          Icon(Icons.receipt_long_outlined,
                              size: 48, color: theme.colorScheme.outline),
                          const SizedBox(height: 12),
                          Text(
                            'No transactions recorded yet',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add manual expenses, income, or scan a UPI QR to get started.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final displayList = transactions.take(5).toList();

                return Card(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayList.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final tx = displayList[index];
                      final isExpense = tx.type == TransactionType.expense;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isExpense
                              ? AppTheme.expenseRed.withValues(alpha: 0.15)
                              : AppTheme.incomeGreen.withValues(alpha: 0.15),
                          foregroundColor: isExpense
                              ? AppTheme.expenseRed
                              : AppTheme.incomeGreen,
                          child: Icon(
                            isExpense
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                          ),
                        ),
                        title: Text(
                          tx.merchant ??
                              (isExpense ? 'Expense' : 'Income'),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          DateFormat('dd MMM, hh:mm a').format(tx.occurredAt),
                          style: theme.textTheme.bodySmall,
                        ),
                        trailing: Text(
                          '${isExpense ? '-' : '+'}${MoneyFormatter.formatPaise(tx.amountPaise)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isExpense
                                ? AppTheme.expenseRed
                                : AppTheme.incomeGreen,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error loading transactions: $err'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardAccountCard extends ConsumerWidget {
  const _DashboardAccountCard({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(accountBalanceStreamProvider(account.id));
    final theme = Theme.of(context);

    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            account.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          balanceAsync.when(
            data: (balance) => Text(
              MoneyFormatter.formatPaise(balance.currentBalancePaise),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: balance.currentBalancePaise >= 0
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
              ),
            ),
            loading: () => const SizedBox(
              height: 12,
              width: 12,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
            error: (_, _) => const Text('Error'),
          ),
        ],
      ),
    );
  }
}
