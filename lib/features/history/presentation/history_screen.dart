import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/tables/payment_attempts_table.dart';
import '../../../core/database/tables/transactions_table.dart';
import '../../../core/utilities/money_formatter.dart';
import '../../dashboard/providers/dashboard_providers.dart';

enum HistoryFilter { all, expense, income, transfer, unverified }

sealed class HistoryItem {
  DateTime get date;
}

class TransactionHistoryItem extends HistoryItem {
  TransactionHistoryItem(this.transaction);
  final Transaction transaction;

  @override
  DateTime get date => transaction.occurredAt;
}

class TransferHistoryItem extends HistoryItem {
  TransferHistoryItem(this.transfer);
  final Transfer transfer;

  @override
  DateTime get date => transfer.occurredAt;
}

class AttemptHistoryItem extends HistoryItem {
  AttemptHistoryItem(this.attempt);
  final PaymentAttempt attempt;

  @override
  DateTime get date => attempt.createdAt;
}

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  HistoryFilter _filter = HistoryFilter.all;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resolveUnverifiedAttempt(PaymentAttempt attempt) {
    final payeeText = attempt.payeeName.isNotEmpty ? attempt.payeeName : attempt.payeeVpa;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Review Payment Attempt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payee: $payeeText'),
            const SizedBox(height: 8),
            Text('Amount: ${MoneyFormatter.formatPaise(attempt.amountPaise)}'),
            const SizedBox(height: 16),
            const Text(
              'Was this payment successful in your UPI app?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(paymentAttemptsDaoProvider)
                  .updateAttemptStatus(attempt.id, PaymentAttemptStatus.failed);
            },
            child: const Text('No (Failed)'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final db = ref.read(databaseProvider);
              await db.transaction(() async {
                final txId = await db.transactionsDao.insertTransaction(
                  TransactionsCompanion.insert(
                    accountId: attempt.actualFundingAccountId ??
                        attempt.intendedAccountId,
                    type: TransactionType.expense,
                    amountPaise: attempt.amountPaise,
                    categoryId: drift.Value(attempt.categoryId),
                    merchant: drift.Value(attempt.payeeName),
                    note: drift.Value(attempt.note),
                    occurredAt: attempt.createdAt,
                    source: TransactionSource.upiQr,
                    paymentMethod: PaymentMethod.upi,
                    paymentAttemptId: drift.Value(attempt.id),
                  ),
                );
                await db.paymentAttemptsDao.linkTransaction(attempt.id, txId);
                await db.paymentAttemptsDao.updateAttemptStatus(
                  attempt.id,
                  PaymentAttemptStatus.confirmed,
                  resolvedAt: DateTime.now(),
                );
              });
            },
            child: const Text('Yes (Confirmed)'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(recentTransactionsStreamProvider);
    final transfersAsync = ref.watch(allTransfersStreamProvider);
    final attemptsAsync = ref.watch(unverifiedAttemptsStreamProvider);
    final theme = Theme.of(context);

    final isLoading = transactionsAsync.isLoading ||
        transfersAsync.isLoading ||
        attemptsAsync.isLoading;

    final txList = transactionsAsync.value ?? [];
    final tfList = transfersAsync.value ?? [];
    final atList = attemptsAsync.value ?? [];

    final List<HistoryItem> allItems = [
      ...txList.map(TransactionHistoryItem.new),
      ...tfList.map(TransferHistoryItem.new),
      ...atList.map(AttemptHistoryItem.new),
    ]..sort((a, b) => b.date.compareTo(a.date));

    final filtered = allItems.where((item) {
      if (_filter == HistoryFilter.expense) {
        return item is TransactionHistoryItem &&
            item.transaction.type == TransactionType.expense;
      }
      if (_filter == HistoryFilter.income) {
        return item is TransactionHistoryItem &&
            item.transaction.type == TransactionType.income;
      }
      if (_filter == HistoryFilter.transfer) {
        return item is TransferHistoryItem;
      }
      if (_filter == HistoryFilter.unverified) {
        return item is AttemptHistoryItem;
      }

      if (_searchQuery.isNotEmpty) {
        if (item is TransactionHistoryItem) {
          final m = item.transaction.merchant?.toLowerCase() ?? '';
          final n = item.transaction.note?.toLowerCase() ?? '';
          return m.contains(_searchQuery) || n.contains(_searchQuery);
        }
        if (item is TransferHistoryItem) {
          final n = item.transfer.note?.toLowerCase() ?? '';
          return n.contains(_searchQuery);
        }
        if (item is AttemptHistoryItem) {
          final p = item.attempt.payeeName.toLowerCase();
          final v = item.attempt.payeeVpa.toLowerCase();
          return p.contains(_searchQuery) || v.contains(_searchQuery);
        }
      }

      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search merchant or note...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (val) =>
                  setState(() => _searchQuery = val.trim().toLowerCase()),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildFilterChip('All', HistoryFilter.all),
                const SizedBox(width: 8),
                _buildFilterChip('Expenses', HistoryFilter.expense),
                const SizedBox(width: 8),
                _buildFilterChip('Income', HistoryFilter.income),
                const SizedBox(width: 8),
                _buildFilterChip('Transfers', HistoryFilter.transfer),
                const SizedBox(width: 8),
                _buildFilterChip('Unverified', HistoryFilter.unverified,
                    badgeCount: atList.length),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.filter_list_off,
                                size: 48, color: theme.colorScheme.outline),
                            const SizedBox(height: 12),
                            Text(
                              'No transactions found',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return _buildHistoryCard(item, theme);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, HistoryFilter filter, {int? badgeCount}) {
    final isSelected = _filter == filter;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (badgeCount != null && badgeCount > 0) ...[
            const SizedBox(width: 6),
            CircleAvatar(
              radius: 8,
              backgroundColor: isSelected ? Colors.white : AppTheme.warningAmber,
              foregroundColor: isSelected ? Colors.black : Colors.white,
              child: Text(
                '$badgeCount',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (_) => setState(() => _filter = filter),
    );
  }

  Widget _buildHistoryCard(HistoryItem item, ThemeData theme) {
    if (item is TransactionHistoryItem) {
      final tx = item.transaction;
      final isExpense = tx.type == TransactionType.expense;
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: isExpense
                ? AppTheme.expenseRed.withValues(alpha: 0.15)
                : AppTheme.incomeGreen.withValues(alpha: 0.15),
            foregroundColor:
                isExpense ? AppTheme.expenseRed : AppTheme.incomeGreen,
            child: Icon(
                isExpense ? Icons.arrow_downward : Icons.arrow_upward),
          ),
          title: Text(
            tx.merchant ?? (isExpense ? 'Expense' : 'Income'),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${DateFormat('dd MMM yyyy, hh:mm a').format(tx.occurredAt)}${tx.note != null ? " • ${tx.note}" : ""}',
          ),
          trailing: Text(
            '${isExpense ? '-' : '+'}${MoneyFormatter.formatPaise(tx.amountPaise)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isExpense ? AppTheme.expenseRed : AppTheme.incomeGreen,
            ),
          ),
        ),
      );
    }

    if (item is TransferHistoryItem) {
      final tf = item.transfer;
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.secondaryContainer,
            foregroundColor: theme.colorScheme.onSecondaryContainer,
            child: const Icon(Icons.swap_horiz),
          ),
          title: const Text(
            'Transfer Between Accounts',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${DateFormat('dd MMM yyyy, hh:mm a').format(tf.occurredAt)}${tf.note != null ? " • ${tf.note}" : ""}',
          ),
          trailing: Text(
            MoneyFormatter.formatPaise(tf.amountPaise),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    if (item is AttemptHistoryItem) {
      final at = item.attempt;
      final payeeTitle = at.payeeName.isNotEmpty ? at.payeeName : at.payeeVpa;
      return Card(
        color: AppTheme.warningAmber.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppTheme.warningAmber.withValues(alpha: 0.4)),
        ),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: AppTheme.warningAmber,
            foregroundColor: Colors.white,
            child: Icon(Icons.pending_actions),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  payeeTitle,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.warningAmber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'UNVERIFIED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.warningAmber,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Text(
            '${DateFormat('dd MMM yyyy, hh:mm a').format(at.createdAt)} • Tap to confirm or reject',
          ),
          trailing: Text(
            MoneyFormatter.formatPaise(at.amountPaise),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppTheme.unverifiedSlate,
            ),
          ),
          onTap: () => _resolveUnverifiedAttempt(at),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
