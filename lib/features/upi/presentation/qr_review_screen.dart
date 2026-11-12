import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/tables/categories_table.dart';
import '../../../core/database/tables/payment_attempts_table.dart';
import '../../../core/utilities/money_formatter.dart';
import '../../dashboard/providers/dashboard_providers.dart';
import '../domain/upi_payment_draft.dart';

class QrReviewScreen extends ConsumerStatefulWidget {
  const QrReviewScreen({
    required this.draft,
    super.key,
  });

  final UpiPaymentDraft draft;

  @override
  ConsumerState<QrReviewScreen> createState() => _QrReviewScreenState();
}

class _QrReviewScreenState extends ConsumerState<QrReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  int? _selectedAccountId;
  int? _selectedCategoryId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.draft.amountPaise != null
          ? (widget.draft.amountPaise! / 100.0).toStringAsFixed(2)
          : '',
    );
    _noteController = TextEditingController(text: widget.draft.note ?? '');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _onProceed() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an intended account')),
      );
      return;
    }

    final amountPaise = widget.draft.amountWasProvidedByQr
        ? widget.draft.amountPaise!
        : MoneyFormatter.parseRupeesToPaise(_amountController.text.trim())!;

    setState(() => _isSaving = true);
    final paymentAttemptsDao = ref.read(paymentAttemptsDaoProvider);

    try {
      // Persist attempt as pending BEFORE any external launch
      final attemptId = await paymentAttemptsDao.insertAttempt(
        PaymentAttemptsCompanion.insert(
          status: PaymentAttemptStatus.pending,
          payeeName: widget.draft.payeeName,
          payeeVpa: widget.draft.payeeVpa,
          amountPaise: amountPaise,
          amountWasProvidedByQr: widget.draft.amountWasProvidedByQr,
          rawQrPayload: drift.Value(widget.draft.rawUri),
          categoryId: drift.Value(_selectedCategoryId),
          note: drift.Value(
            _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
          ),
          intendedAccountId: _selectedAccountId!,
        ),
      );

      if (mounted) {
        // In Phase 3, confirm draft persistence
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Payment draft created (#$attemptId). App launcher active in Phase 4.',
            ),
          ),
        );
        context.go('/history');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save payment attempt: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountsAsync = ref.watch(activeAccountsStreamProvider);
    final categoriesAsync =
        ref.watch(categoriesByKindProvider(CategoryKind.expense));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review UPI Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Payee Card
              Card(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            foregroundColor: theme.colorScheme.onPrimaryContainer,
                            child: const Icon(Icons.storefront),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.draft.payeeName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.draft.payeeVpa,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (widget.draft.merchantCategoryCode != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Category Code: ${widget.draft.merchantCategoryCode}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Amount Section
              if (widget.draft.amountWasProvidedByQr) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lock_outline,
                              size: 16, color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Amount specified by QR',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        MoneyFormatter.formatPaise(widget.draft.amountPaise!),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Enter Amount (₹)',
                    hintText: '0.00',
                    prefixText: '₹ ',
                    prefixStyle: theme.textTheme.titleMedium,
                  ),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter the payment amount';
                    }
                    final paise = MoneyFormatter.parseRupeesToPaise(val.trim());
                    if (paise == null || paise <= 0) {
                      return 'Enter a valid positive amount';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 16),

              // Account Selection
              accountsAsync.when(
                data: (accounts) {
                  if (accounts.isEmpty) {
                    return const Text(
                      'No active accounts available. Please add an account first.',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  _selectedAccountId ??= accounts.first.id;
                  return DropdownButtonFormField<int>(
                    initialValue: _selectedAccountId,
                    decoration: const InputDecoration(
                      labelText: 'Pay From (Intended Account)',
                    ),
                    items: accounts.map((acc) {
                      return DropdownMenuItem(
                        value: acc.id,
                        child: Text('${acc.name} (${acc.type.name})'),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedAccountId = val),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error loading accounts: $e'),
              ),

              const SizedBox(height: 16),

              // Category Selection
              categoriesAsync.when(
                data: (categories) {
                  return DropdownButtonFormField<int>(
                    initialValue: _selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Category (Optional)',
                    ),
                    items: [
                      const DropdownMenuItem<int>(
                        value: null,
                        child: Text('Uncategorized'),
                      ),
                      ...categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat.id,
                          child: Text(cat.name),
                        );
                      }),
                    ],
                    onChanged: (val) =>
                        setState(() => _selectedCategoryId = val),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 16),

              // Note
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Payment Note (Optional)',
                  hintText: 'Add context or reference',
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _isSaving ? null : _onProceed,
                icon: const Icon(Icons.arrow_forward),
                label: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Proceed to Payment',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
