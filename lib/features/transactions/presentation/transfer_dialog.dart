import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/utilities/money_formatter.dart';
import '../../dashboard/providers/dashboard_providers.dart';

class TransferDialog extends ConsumerStatefulWidget {
  const TransferDialog({super.key});

  @override
  ConsumerState<TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends ConsumerState<TransferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  int? _sourceAccountId;
  int? _destAccountId;
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_sourceAccountId == null || _destAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both source and destination accounts')),
      );
      return;
    }

    if (_sourceAccountId == _destAccountId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Source and destination accounts must be different')),
      );
      return;
    }

    final amountPaise = MoneyFormatter.parseRupeesToPaise(_amountController.text.trim());
    if (amountPaise == null || amountPaise <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a positive transfer amount')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final transferService = ref.read(transferServiceProvider);

    try {
      await transferService.executeTransfer(
        sourceAccountId: _sourceAccountId!,
        destinationAccountId: _destAccountId!,
        amountPaise: amountPaise,
        occurredAt: _selectedDate,
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transfer failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(activeAccountsStreamProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Transfer Money'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount (₹)',
                  hintText: '0.00',
                  prefixText: '₹ ',
                  prefixStyle: theme.textTheme.titleMedium,
                ),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  final paise = MoneyFormatter.parseRupeesToPaise(val.trim());
                  if (paise == null || paise <= 0) {
                    return 'Enter a valid positive amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              accountsAsync.when(
                data: (accounts) {
                  if (accounts.length < 2) {
                    return const Text(
                      'You need at least 2 accounts to make a transfer.',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  _sourceAccountId ??= accounts.first.id;
                  _destAccountId ??= accounts[1].id;

                  return Column(
                    children: [
                      DropdownButtonFormField<int>(
                        initialValue: _sourceAccountId,
                        decoration: const InputDecoration(
                          labelText: 'From Account (Source)',
                        ),
                        items: accounts.map((acc) {
                          return DropdownMenuItem(
                            value: acc.id,
                            child: Text('${acc.name} (${acc.type.name})'),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _sourceAccountId = val),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        initialValue: _destAccountId,
                        decoration: const InputDecoration(
                          labelText: 'To Account (Destination)',
                        ),
                        items: accounts.map((acc) {
                          return DropdownMenuItem(
                            value: acc.id,
                            child: Text('${acc.name} (${acc.type.name})'),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _destAccountId = val),
                      ),
                    ],
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error loading accounts: $e'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (Optional)',
                  hintText: 'e.g. ATM withdrawal, Card payment',
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date'),
                subtitle: Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                onTap: _pickDate,
                trailing: TextButton(
                  onPressed: _pickDate,
                  child: const Text('Change'),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Transfer'),
        ),
      ],
    );
  }
}
