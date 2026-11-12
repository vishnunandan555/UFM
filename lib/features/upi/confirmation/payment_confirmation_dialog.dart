import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/tables/payment_attempts_table.dart';
import '../../../core/database/tables/transactions_table.dart';
import '../../../core/utilities/money_formatter.dart';
import '../../dashboard/providers/dashboard_providers.dart';

enum PaymentConfirmationOutcome {
  confirmed,
  failed,
  unverified,
}

class PaymentConfirmationDialog extends ConsumerStatefulWidget {
  const PaymentConfirmationDialog({
    required this.attempt,
    super.key,
  });

  final PaymentAttempt attempt;

  static Future<PaymentConfirmationOutcome?> show({
    required BuildContext context,
    required PaymentAttempt attempt,
  }) {
    return showDialog<PaymentConfirmationOutcome>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PaymentConfirmationDialog(attempt: attempt),
    );
  }

  @override
  ConsumerState<PaymentConfirmationDialog> createState() =>
      _PaymentConfirmationDialogState();
}

class _PaymentConfirmationDialogState
    extends ConsumerState<PaymentConfirmationDialog> {
  late int _selectedAccountId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedAccountId = widget.attempt.actualFundingAccountId ??
        widget.attempt.intendedAccountId;
  }

  Future<void> _onConfirmed() async {
    setState(() => _isSaving = true);
    final db = ref.read(databaseProvider);

    try {
      await db.transaction(() async {
        final txId = await db.transactionsDao.insertTransaction(
          TransactionsCompanion.insert(
            accountId: _selectedAccountId,
            type: TransactionType.expense,
            amountPaise: widget.attempt.amountPaise,
            categoryId: drift.Value(widget.attempt.categoryId),
            merchant: drift.Value(widget.attempt.payeeName),
            note: drift.Value(widget.attempt.note),
            occurredAt: widget.attempt.createdAt,
            source: TransactionSource.upiQr,
            paymentMethod: PaymentMethod.upi,
            paymentAttemptId: drift.Value(widget.attempt.id),
          ),
        );

        await db.paymentAttemptsDao.linkTransaction(widget.attempt.id, txId);
        await (db.update(db.paymentAttempts)
              ..where((t) => t.id.equals(widget.attempt.id)))
            .write(
          PaymentAttemptsCompanion(
            status: const drift.Value(PaymentAttemptStatus.confirmed),
            actualFundingAccountId: drift.Value(_selectedAccountId),
            resolvedAt: drift.Value(DateTime.now()),
          ),
        );
      });

      if (mounted) {
        Navigator.of(context).pop(PaymentConfirmationOutcome.confirmed);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to confirm payment: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _onFailed() async {
    setState(() => _isSaving = true);
    final db = ref.read(databaseProvider);

    try {
      await (db.update(db.paymentAttempts)
            ..where((t) => t.id.equals(widget.attempt.id)))
          .write(
        PaymentAttemptsCompanion(
          status: const drift.Value(PaymentAttemptStatus.failed),
          resolvedAt: drift.Value(DateTime.now()),
        ),
      );

      if (mounted) {
        Navigator.of(context).pop(PaymentConfirmationOutcome.failed);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to record status: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _onVerifyLater() async {
    final db = ref.read(databaseProvider);
    // If it was pending, transition to unverified so user can review later
    if (widget.attempt.status == PaymentAttemptStatus.pending) {
      await (db.update(db.paymentAttempts)
            ..where((t) => t.id.equals(widget.attempt.id)))
          .write(
        PaymentAttemptsCompanion(
          status: const drift.Value(PaymentAttemptStatus.unverified),
          resolvedAt: drift.Value(DateTime.now()),
        ),
      );
    }
    if (mounted) {
      Navigator.of(context).pop(PaymentConfirmationOutcome.unverified);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountsAsync = ref.watch(activeAccountsStreamProvider);

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.help_outline, color: AppTheme.seedColor),
          SizedBox(width: 8),
          Text('Payment Confirmation'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Was the payment successful in your UPI app?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        MoneyFormatter.formatPaise(widget.attempt.amountPaise),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payee:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.attempt.payeeName,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.attempt.payeeVpa,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Actual Funding Account Correction
            Text(
              'Funding Account Debited:',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            accountsAsync.when(
              data: (accounts) {
                return DropdownButtonFormField<int>(
                  initialValue: _selectedAccountId,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(),
                  ),
                  items: accounts.map((acc) {
                    return DropdownMenuItem(
                      value: acc.id,
                      child: Text('${acc.name} (${acc.type.name})'),
                    );
                  }).toList(),
                  onChanged: _isSaving
                      ? null
                      : (val) {
                          if (val != null) {
                            setState(() => _selectedAccountId = val);
                          }
                        },
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 4),
            Text(
              'Select a different account if you switched accounts inside Google Pay / PhonePe.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : _onVerifyLater,
          child: const Text('Verify Later'),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.expenseRed,
          ),
          onPressed: _isSaving ? null : _onFailed,
          child: const Text('No (Failed)'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.incomeGreen,
          ),
          onPressed: _isSaving ? null : _onConfirmed,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Yes (Confirmed)'),
        ),
      ],
    );
  }
}
