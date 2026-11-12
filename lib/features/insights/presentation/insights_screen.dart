import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/backup/backup_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/tables/transactions_table.dart';
import '../../../core/utilities/money_formatter.dart';
import '../../dashboard/providers/dashboard_providers.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  Future<void> _exportBackup() async {
    final db = ref.read(databaseProvider);
    final backupService = BackupService(db);
    final jsonString = await backupService.exportToJson();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Backup Export'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your entire database has been exported to local JSON. You can copy it below:',
            ),
            const SizedBox(height: 12),
            Container(
              height: 150,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  jsonString,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.copy),
            label: const Text('Copy to Clipboard'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonString));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup copied to clipboard!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _restoreBackup() async {
    final controller = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Backup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Paste a valid UFM backup JSON payload below. WARNING: This will overwrite existing local data.',
              style: TextStyle(color: AppTheme.expenseRed),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Paste backup JSON here...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.expenseRed),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Restore Database'),
          ),
        ],
      ),
    );

    if (confirmed == true && controller.text.trim().isNotEmpty) {
      final db = ref.read(databaseProvider);
      final backupService = BackupService(db);
      final result = await backupService.restoreFromJson(controller.text.trim());

      if (mounted) {
        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Database restored successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Restore failed: ${result.errorMessage}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transactionsAsync = ref.watch(recentTransactionsStreamProvider);
    final categoriesAsync = ref.watch(categoriesByKindProvider(null));

    final txs = transactionsAsync.value ?? [];
    final categoriesMap = {
      for (final c in (categoriesAsync.value ?? <Category>[])) c.id: c.name
    };

    // Filter transactions for selected month
    final monthTxs = txs.where((t) {
      return t.occurredAt.year == _selectedMonth.year &&
          t.occurredAt.month == _selectedMonth.month;
    }).toList();

    int totalIncomePaise = 0;
    int totalExpensePaise = 0;
    final Map<int?, int> expenseByCategory = {};

    for (final t in monthTxs) {
      if (t.type == TransactionType.income) {
        totalIncomePaise += t.amountPaise;
      } else if (t.type == TransactionType.expense) {
        totalExpensePaise += t.amountPaise;
        expenseByCategory[t.categoryId] =
            (expenseByCategory[t.categoryId] ?? 0) + t.amountPaise;
      }
    }

    final netSavingsPaise = totalIncomePaise - totalExpensePaise;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights & Summaries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.backup_outlined),
            tooltip: 'Export Backup',
            onPressed: _exportBackup,
          ),
          IconButton(
            icon: const Icon(Icons.settings_backup_restore),
            tooltip: 'Restore Backup',
            onPressed: _restoreBackup,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Month Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
              ),
              Text(
                DateFormat('MMMM yyyy').format(_selectedMonth),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Monthly Summary Cards Row
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Income',
                  amountPaise: totalIncomePaise,
                  color: AppTheme.incomeGreen,
                  icon: Icons.arrow_upward,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryCard(
                  title: 'Expense',
                  amountPaise: totalExpensePaise,
                  color: AppTheme.expenseRed,
                  icon: Icons.arrow_downward,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryCard(
                  title: 'Savings',
                  amountPaise: netSavingsPaise,
                  color: netSavingsPaise >= 0
                      ? theme.colorScheme.primary
                      : AppTheme.expenseRed,
                  icon: Icons.savings_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Spending by Category Header
          Text(
            'Spending by Category',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          if (totalExpensePaise == 0) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.pie_chart_outline,
                          size: 48, color: theme.colorScheme.outline),
                      const SizedBox(height: 8),
                      Text(
                        'No expenses recorded for this month',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            // Category Pie Chart
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: expenseByCategory.entries.map((entry) {
                    final percentage =
                        (entry.value / totalExpensePaise) * 100.0;
                    return PieChartSectionData(
                      color: _getCategoryColor(entry.key),
                      value: entry.value.toDouble(),
                      title: '${percentage.toStringAsFixed(0)}%',
                      radius: 40,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Category Details List
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expenseByCategory.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entry = expenseByCategory.entries.elementAt(index);
                  final categoryName =
                      categoriesMap[entry.key] ?? 'Uncategorized';
                  final percentage =
                      (entry.value / totalExpensePaise) * 100.0;

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 12,
                      backgroundColor: _getCategoryColor(entry.key),
                    ),
                    title: Text(categoryName),
                    subtitle: Text('${percentage.toStringAsFixed(1)}% of total'),
                    trailing: Text(
                      MoneyFormatter.formatPaise(entry.value),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getCategoryColor(int? key) {
    const colors = [
      Color(0xFF0F766E),
      Color(0xFF2563EB),
      Color(0xFFD97706),
      Color(0xFFDC2626),
      Color(0xFF7C3AED),
      Color(0xFF059669),
      Color(0xFFDB2777),
    ];
    if (key == null) return const Color(0xFF64748B);
    return colors[key % colors.length];
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.amountPaise,
    required this.color,
    required this.icon,
  });

  final String title;
  final int amountPaise;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                MoneyFormatter.formatPaise(amountPaise),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
