import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import '../database/app_database.dart';
import '../database/tables/accounts_table.dart';
import '../database/tables/categories_table.dart';
import '../database/tables/payment_attempts_table.dart';
import '../database/tables/transactions_table.dart';

class BackupResult {
  const BackupResult({
    required this.isSuccess,
    this.jsonData,
    this.errorMessage,
  });

  final bool isSuccess;
  final String? jsonData;
  final String? errorMessage;
}

class BackupService {
  const BackupService(this._db);

  final AppDatabase _db;

  /// Exports the entire database into a structured JSON string.
  Future<String> exportToJson() async {
    final accountsList = await _db.accountsDao.getAllAccounts();
    final categoriesList = await _db.categoriesDao.getAllCategories();
    final transactionsList = await _db.transactionsDao.getAllTransactions();
    final transfersList = await _db.transfersDao.getAllTransfers();
    final attemptsList = await _db.paymentAttemptsDao.getAllAttempts();

    final data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'accounts': accountsList
          .map((a) => {
                'id': a.id,
                'name': a.name,
                'type': a.type.name,
                'openingBalancePaise': a.openingBalancePaise,
                'createdAt': a.createdAt.toIso8601String(),
                'updatedAt': a.updatedAt.toIso8601String(),
                'isArchived': a.isArchived,
                'iconKey': a.iconKey,
                'colourKey': a.colourKey,
              })
          .toList(),
      'categories': categoriesList
          .map((c) => {
                'id': c.id,
                'name': c.name,
                'kind': c.kind.name,
                'iconKey': c.iconKey,
                'isDefault': c.isDefault,
                'isArchived': c.isArchived,
                'createdAt': c.createdAt.toIso8601String(),
              })
          .toList(),
      'transactions': transactionsList
          .map((t) => {
                'id': t.id,
                'accountId': t.accountId,
                'type': t.type.name,
                'amountPaise': t.amountPaise,
                'categoryId': t.categoryId,
                'merchant': t.merchant,
                'note': t.note,
                'occurredAt': t.occurredAt.toIso8601String(),
                'createdAt': t.createdAt.toIso8601String(),
                'updatedAt': t.updatedAt.toIso8601String(),
                'source': t.source.name,
                'paymentMethod': t.paymentMethod.name,
                'paymentAppId': t.paymentAppId,
                'actualFundingAccountId': t.actualFundingAccountId,
                'paymentAttemptId': t.paymentAttemptId,
                'externalReference': t.externalReference,
              })
          .toList(),
      'transfers': transfersList
          .map((tf) => {
                'id': tf.id,
                'sourceAccountId': tf.sourceAccountId,
                'destinationAccountId': tf.destinationAccountId,
                'amountPaise': tf.amountPaise,
                'occurredAt': tf.occurredAt.toIso8601String(),
                'note': tf.note,
                'createdAt': tf.createdAt.toIso8601String(),
              })
          .toList(),
      'paymentAttempts': attemptsList
          .map((p) => {
                'id': p.id,
                'status': p.status.name,
                'payeeName': p.payeeName,
                'payeeVpa': p.payeeVpa,
                'amountPaise': p.amountPaise,
                'amountWasProvidedByQr': p.amountWasProvidedByQr,
                'rawQrPayload': p.rawQrPayload,
                'categoryId': p.categoryId,
                'note': p.note,
                'intendedAccountId': p.intendedAccountId,
                'actualFundingAccountId': p.actualFundingAccountId,
                'selectedPaymentAppId': p.selectedPaymentAppId,
                'externalReference': p.externalReference,
                'createdAt': p.createdAt.toIso8601String(),
                'launchedAt': p.launchedAt?.toIso8601String(),
                'resolvedAt': p.resolvedAt?.toIso8601String(),
                'linkedTransactionId': p.linkedTransactionId,
                'launchError': p.launchError,
              })
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Restores database state from a validated JSON string atomically.
  Future<BackupResult> restoreFromJson(String jsonString) async {
    Map<String, dynamic> data;
    try {
      data = jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return BackupResult(isSuccess: false, errorMessage: 'Invalid JSON: $e');
    }

    if (!data.containsKey('version') || !data.containsKey('accounts')) {
      return const BackupResult(
        isSuccess: false,
        errorMessage: 'Invalid backup format: Missing required metadata',
      );
    }

    try {
      await _db.transaction(() async {
        // Clear existing records in reverse dependency order
        await _db.delete(_db.transfers).go();
        await _db.delete(_db.paymentAttempts).go();
        await _db.delete(_db.transactions).go();
        await _db.delete(_db.categories).go();
        await _db.delete(_db.accounts).go();

        // 1. Restore Accounts
        final accountsData = (data['accounts'] as List?) ?? [];
        for (final item in accountsData) {
          final m = item as Map<String, dynamic>;
          await _db.into(_db.accounts).insert(
                AccountsCompanion(
                  id: drift.Value(m['id'] as int),
                  name: drift.Value(m['name'] as String),
                  type: drift.Value(
                    AccountType.values.byName(m['type'] as String),
                  ),
                  openingBalancePaise:
                      drift.Value(m['openingBalancePaise'] as int),
                  createdAt:
                      drift.Value(DateTime.parse(m['createdAt'] as String)),
                  updatedAt:
                      drift.Value(DateTime.parse(m['updatedAt'] as String)),
                  isArchived: drift.Value((m['isArchived'] as bool?) ?? false),
                  iconKey: drift.Value(m['iconKey'] as String?),
                  colourKey: drift.Value(m['colourKey'] as String?),
                ),
              );
        }

        // 2. Restore Categories
        final categoriesData = (data['categories'] as List?) ?? [];
        for (final item in categoriesData) {
          final m = item as Map<String, dynamic>;
          await _db.into(_db.categories).insert(
                CategoriesCompanion(
                  id: drift.Value(m['id'] as int),
                  name: drift.Value(m['name'] as String),
                  kind: drift.Value(
                    CategoryKind.values.byName(m['kind'] as String),
                  ),
                  iconKey: drift.Value(m['iconKey'] as String?),
                  isDefault: drift.Value((m['isDefault'] as bool?) ?? false),
                  isArchived: drift.Value((m['isArchived'] as bool?) ?? false),
                  createdAt:
                      drift.Value(DateTime.parse(m['createdAt'] as String)),
                ),
              );
        }

        // 3. Restore Transfers
        final transfersData = (data['transfers'] as List?) ?? [];
        for (final item in transfersData) {
          final m = item as Map<String, dynamic>;
          await _db.into(_db.transfers).insert(
                TransfersCompanion(
                  id: drift.Value(m['id'] as int),
                  sourceAccountId: drift.Value(m['sourceAccountId'] as int),
                  destinationAccountId:
                      drift.Value(m['destinationAccountId'] as int),
                  amountPaise: drift.Value(m['amountPaise'] as int),
                  occurredAt:
                      drift.Value(DateTime.parse(m['occurredAt'] as String)),
                  note: drift.Value(m['note'] as String?),
                  createdAt:
                      drift.Value(DateTime.parse(m['createdAt'] as String)),
                ),
              );
        }

        // 4. Restore Transactions
        final transactionsData = (data['transactions'] as List?) ?? [];
        for (final item in transactionsData) {
          final m = item as Map<String, dynamic>;
          await _db.into(_db.transactions).insert(
                TransactionsCompanion(
                  id: drift.Value(m['id'] as int),
                  accountId: drift.Value(m['accountId'] as int),
                  type: drift.Value(
                    TransactionType.values.byName(m['type'] as String),
                  ),
                  amountPaise: drift.Value(m['amountPaise'] as int),
                  categoryId: drift.Value(m['categoryId'] as int?),
                  merchant: drift.Value(m['merchant'] as String?),
                  note: drift.Value(m['note'] as String?),
                  occurredAt:
                      drift.Value(DateTime.parse(m['occurredAt'] as String)),
                  createdAt:
                      drift.Value(DateTime.parse(m['createdAt'] as String)),
                  updatedAt:
                      drift.Value(DateTime.parse(m['updatedAt'] as String)),
                  source: drift.Value(
                    TransactionSource.values.byName(m['source'] as String),
                  ),
                  paymentMethod: drift.Value(
                    PaymentMethod.values.byName(m['paymentMethod'] as String),
                  ),
                  paymentAppId: drift.Value(m['paymentAppId'] as String?),
                  actualFundingAccountId:
                      drift.Value(m['actualFundingAccountId'] as int?),
                  paymentAttemptId: drift.Value(m['paymentAttemptId'] as int?),
                  externalReference:
                      drift.Value(m['externalReference'] as String?),
                ),
              );
        }

        // 5. Restore Payment Attempts
        final attemptsData = (data['paymentAttempts'] as List?) ?? [];
        for (final item in attemptsData) {
          final m = item as Map<String, dynamic>;
          await _db.into(_db.paymentAttempts).insert(
                PaymentAttemptsCompanion(
                  id: drift.Value(m['id'] as int),
                  status: drift.Value(
                    PaymentAttemptStatus.values.byName(m['status'] as String),
                  ),
                  payeeName: drift.Value(m['payeeName'] as String),
                  payeeVpa: drift.Value(m['payeeVpa'] as String),
                  amountPaise: drift.Value(m['amountPaise'] as int),
                  amountWasProvidedByQr:
                      drift.Value(m['amountWasProvidedByQr'] as bool),
                  rawQrPayload: drift.Value(m['rawQrPayload'] as String?),
                  categoryId: drift.Value(m['categoryId'] as int?),
                  note: drift.Value(m['note'] as String?),
                  intendedAccountId:
                      drift.Value(m['intendedAccountId'] as int),
                  actualFundingAccountId:
                      drift.Value(m['actualFundingAccountId'] as int?),
                  selectedPaymentAppId:
                      drift.Value(m['selectedPaymentAppId'] as String?),
                  externalReference:
                      drift.Value(m['externalReference'] as String?),
                  createdAt:
                      drift.Value(DateTime.parse(m['createdAt'] as String)),
                  launchedAt: m['launchedAt'] != null
                      ? drift.Value(DateTime.parse(m['launchedAt'] as String))
                      : const drift.Value.absent(),
                  resolvedAt: m['resolvedAt'] != null
                      ? drift.Value(DateTime.parse(m['resolvedAt'] as String))
                      : const drift.Value.absent(),
                  linkedTransactionId:
                      drift.Value(m['linkedTransactionId'] as int?),
                  launchError: drift.Value(m['launchError'] as String?),
                ),
              );
        }
      });

      return const BackupResult(isSuccess: true);
    } catch (e) {
      return BackupResult(
        isSuccess: false,
        errorMessage: 'Failed to restore database: $e',
      );
    }
  }
}
