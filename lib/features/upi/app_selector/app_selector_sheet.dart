import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/utilities/money_formatter.dart';
import '../platform/installed_upi_app.dart';

/// Result returned when user selects a payment app from [AppSelectorSheet].
class AppSelectionResult {
  const AppSelectionResult({
    required this.app,
    required this.rememberAsPreferred,
  });

  final InstalledUpiApp app;
  final bool rememberAsPreferred;
}

/// Material 3 Bottom Sheet allowing the user to select an installed UPI app.
class AppSelectorSheet extends StatefulWidget {
  const AppSelectorSheet({
    super.key,
    required this.apps,
    required this.amountPaise,
    required this.payeeName,
    this.preferredPackageName,
  });

  final List<InstalledUpiApp> apps;
  final int amountPaise;
  final String payeeName;
  final String? preferredPackageName;

  /// Convenience helper to display this sheet.
  static Future<AppSelectionResult?> show({
    required BuildContext context,
    required List<InstalledUpiApp> apps,
    required int amountPaise,
    required String payeeName,
    String? preferredPackageName,
  }) {
    return showModalBottomSheet<AppSelectionResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AppSelectorSheet(
        apps: apps,
        amountPaise: amountPaise,
        payeeName: payeeName,
        preferredPackageName: preferredPackageName,
      ),
    );
  }

  @override
  State<AppSelectorSheet> createState() => _AppSelectorSheetState();
}

class _AppSelectorSheetState extends State<AppSelectorSheet> {
  late List<InstalledUpiApp> _sortedApps;
  String? _selectedPackage;
  bool _rememberAsPreferred = false;

  @override
  void initState() {
    super.initState();
    _sortApps();
    _initializeSelection();
  }

  void _sortApps() {
    final uniqueApps = <String, InstalledUpiApp>{};
    for (final app in widget.apps) {
      uniqueApps.putIfAbsent(app.packageName, () => app);
    }
    _sortedApps = uniqueApps.values.toList();
    _sortedApps.sort((a, b) {
      // 1. Preferred app first
      final aIsPreferred = a.packageName == widget.preferredPackageName;
      final bIsPreferred = b.packageName == widget.preferredPackageName;
      if (aIsPreferred && !bIsPreferred) return -1;
      if (!aIsPreferred && bIsPreferred) return 1;

      // 2. Real apps before test apps
      if (!a.isTestApp && b.isTestApp) return -1;
      if (a.isTestApp && !b.isTestApp) return 1;

      // 3. Alphabetical by app name
      return a.appName.toLowerCase().compareTo(b.appName.toLowerCase());
    });
  }

  void _initializeSelection() {
    if (_sortedApps.isEmpty) {
      _selectedPackage = null;
      return;
    }

    // Default to preferred package if installed, else first app in sorted list
    final hasPreferred = _sortedApps.any(
      (app) => app.packageName == widget.preferredPackageName,
    );
    if (hasPreferred) {
      _selectedPackage = widget.preferredPackageName;
      _rememberAsPreferred = true;
    } else {
      _selectedPackage = _sortedApps.first.packageName;
      _rememberAsPreferred = false;
    }
  }

  InstalledUpiApp? get _currentSelectedApp {
    if (_selectedPackage == null) return null;
    try {
      return _sortedApps.firstWhere(
        (app) => app.packageName == _selectedPackage,
      );
    } catch (_) {
      return null;
    }
  }

  Widget _buildAppIcon(InstalledUpiApp app) {
    if (app.iconBase64 != null && app.iconBase64!.isNotEmpty) {
      try {
        final bytes = base64Decode(app.iconBase64!);
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            bytes,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildFallbackAvatar(app),
          ),
        );
      } catch (_) {
        return _buildFallbackAvatar(app);
      }
    }
    return _buildFallbackAvatar(app);
  }

  Widget _buildFallbackAvatar(InstalledUpiApp app) {
    final theme = Theme.of(context);
    final iconData = app.isTestApp
        ? Icons.science_outlined
        : Icons.account_balance_wallet_outlined;

    return CircleAvatar(
      radius: 22,
      backgroundColor: app.isTestApp
          ? theme.colorScheme.tertiaryContainer
          : theme.colorScheme.primaryContainer,
      child: Icon(
        iconData,
        size: 24,
        color: app.isTestApp
            ? theme.colorScheme.onTertiaryContainer
            : theme.colorScheme.onPrimaryContainer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedAmount = MoneyFormatter.formatPaise(widget.amountPaise);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header title
            Text(
              'Select Payment App',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Payment summary
            Text(
              'Pay $formattedAmount to ${widget.payeeName}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),

            // Content
            if (_sortedApps.isEmpty)
              _buildEmptyState(theme)
            else ...[
              _buildAppList(theme),
              const SizedBox(height: 12),
              _buildRememberOption(theme),
              const SizedBox(height: 16),
              _buildPayButton(theme, formattedAmount),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'No Compatible UPI Apps Found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Please install a supported UPI application (PhonePe, Google Pay, Paytm, BHIM, CRED, Navi) or use the Fake UPI companion test app on emulators.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(null),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Dismiss'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppList(ThemeData theme) {
    return RadioGroup<String>(
      groupValue: _selectedPackage,
      onChanged: (val) {
        setState(() {
          _selectedPackage = val;
        });
      },
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _sortedApps.length,
        separatorBuilder: (context, index) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final app = _sortedApps[index];
          final isSelected = app.packageName == _selectedPackage;
          final isPreferred = app.packageName == widget.preferredPackageName;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedPackage = app.packageName;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(minHeight: 56),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  _buildAppIcon(app),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                app.appName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isPreferred) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Preferred',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            if (app.isTestApp) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'TEST APP',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onTertiaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          app.packageName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Radio<String>(
                    value: app.packageName,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRememberOption(ThemeData theme) {
    return InkWell(
      onTap: () {
        setState(() {
          _rememberAsPreferred = !_rememberAsPreferred;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Checkbox(
              value: _rememberAsPreferred,
              onChanged: (val) {
                setState(() {
                  _rememberAsPreferred = val ?? false;
                });
              },
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Remember as preferred UPI app',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton(ThemeData theme, String formattedAmount) {
    final selectedApp = _currentSelectedApp;
    final isEnabled = selectedApp != null;
    final label = selectedApp != null
        ? 'Pay $formattedAmount with ${selectedApp.appName}'
        : 'Select an App';

    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: isEnabled
            ? () {
                Navigator.of(context).pop(
                  AppSelectionResult(
                    app: selectedApp,
                    rememberAsPreferred: _rememberAsPreferred,
                  ),
                );
              }
            : null,
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isEnabled
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface.withValues(alpha: 0.38),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
