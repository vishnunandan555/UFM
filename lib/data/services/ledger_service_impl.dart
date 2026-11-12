import 'package:drift/drift.dart';
import '../../core/database/app_database.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/account_balance.dart';
import '../../domain/services/ledger_service.dart';

class LedgerServiceImpl implements LedgerService {
  final AppDatabase db;

  LedgerServiceImpl(this.db);

  static const String _accountBalanceSql = '''
    SELECT 
      a.id AS account_id,
      a.name AS account_name,
      a.opening_balance_paise,
      COALESCE(inc.total, 0) AS confirmed_income_paise,
      COALESCE(exp.total, 0) AS confirmed_expense_paise,
      COALESCE(tin.total, 0) AS transfers_in_paise,
      COALESCE(tout.total, 0) AS transfers_out_paise,
      (a.opening_balance_paise 
       + COALESCE(inc.total, 0) 
       - COALESCE(exp.total, 0) 
       + COALESCE(tin.total, 0) 
       - COALESCE(tout.total, 0)) AS current_balance_paise
    FROM accounts a
    LEFT JOIN (
      SELECT account_id, SUM(amount_paise) AS total 
      FROM transactions 
      WHERE type = 'income' 
      GROUP BY account_id
    ) inc ON inc.account_id = a.id
    LEFT JOIN (
      SELECT account_id, SUM(amount_paise) AS total 
      FROM transactions 
      WHERE type = 'expense' 
      GROUP BY account_id
    ) exp ON exp.account_id = a.id
    LEFT JOIN (
      SELECT destination_account_id, SUM(amount_paise) AS total 
      FROM transfers 
      GROUP BY destination_account_id
    ) tin ON tin.destination_account_id = a.id
    LEFT JOIN (
      SELECT source_account_id, SUM(amount_paise) AS total 
      FROM transfers 
      GROUP BY source_account_id
    ) tout ON tout.source_account_id = a.id
    WHERE a.id = ?;
  ''';

  static const String _totalBalanceSql = '''
    SELECT 
      COALESCE(SUM(
        a.opening_balance_paise 
        + COALESCE(inc.total, 0) 
        - COALESCE(exp.total, 0) 
        + COALESCE(tin.total, 0) 
        - COALESCE(tout.total, 0)
      ), 0) AS total_balance
    FROM accounts a
    LEFT JOIN (
      SELECT account_id, SUM(amount_paise) AS total 
      FROM transactions 
      WHERE type = 'income' 
      GROUP BY account_id
    ) inc ON inc.account_id = a.id
    LEFT JOIN (
      SELECT account_id, SUM(amount_paise) AS total 
      FROM transactions 
      WHERE type = 'expense' 
      GROUP BY account_id
    ) exp ON exp.account_id = a.id
    LEFT JOIN (
      SELECT destination_account_id, SUM(amount_paise) AS total 
      FROM transfers 
      GROUP BY destination_account_id
    ) tin ON tin.destination_account_id = a.id
    LEFT JOIN (
      SELECT source_account_id, SUM(amount_paise) AS total 
      FROM transfers 
      GROUP BY source_account_id
    ) tout ON tout.source_account_id = a.id
    WHERE a.is_archived = 0;
  ''';

  AccountBalanceEntity _mapRow(QueryRow row) {
    return AccountBalanceEntity(
      accountId: row.read<int>('account_id'),
      accountName: row.read<String>('account_name'),
      openingBalancePaise: row.read<int>('opening_balance_paise'),
      confirmedIncomePaise: row.read<int>('confirmed_income_paise'),
      confirmedExpensePaise: row.read<int>('confirmed_expense_paise'),
      transfersInPaise: row.read<int>('transfers_in_paise'),
      transfersOutPaise: row.read<int>('transfers_out_paise'),
      currentBalancePaise: row.read<int>('current_balance_paise'),
    );
  }

  @override
  Future<AccountBalanceEntity> getAccountBalance(int accountId) async {
    final query = db.customSelect(
      _accountBalanceSql,
      variables: [Variable.withInt(accountId)],
      readsFrom: {db.accounts, db.transactions, db.transfers},
    );
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw AccountNotFoundFailure(accountId);
    }
    return _mapRow(row);
  }

  @override
  Stream<AccountBalanceEntity> watchAccountBalance(int accountId) {
    final query = db.customSelect(
      _accountBalanceSql,
      variables: [Variable.withInt(accountId)],
      readsFrom: {db.accounts, db.transactions, db.transfers},
    );
    return query.watchSingleOrNull().map((row) {
      if (row == null) {
        throw AccountNotFoundFailure(accountId);
      }
      return _mapRow(row);
    });
  }

  @override
  Future<int> getTotalConfirmedBalancePaise() async {
    final row = await db.customSelect(
      _totalBalanceSql,
      readsFrom: {db.accounts, db.transactions, db.transfers},
    ).getSingle();
    return row.read<int>('total_balance');
  }

  @override
  Stream<int> watchTotalConfirmedBalancePaise() {
    return db
        .customSelect(
          _totalBalanceSql,
          readsFrom: {db.accounts, db.transactions, db.transfers},
        )
        .watchSingle()
        .map((row) => row.read<int>('total_balance'));
  }
}

