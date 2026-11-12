import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/accounts_table.dart';

part 'accounts_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountsDao extends DatabaseAccessor<AppDatabase>
    with _$AccountsDaoMixin {
  AccountsDao(super.db);

  Future<List<Account>> getAllAccounts() => select(accounts).get();

  Future<List<Account>> getActiveAccounts() =>
      (select(accounts)..where((tbl) => tbl.isArchived.equals(false))).get();

  Stream<List<Account>> watchActiveAccounts() =>
      (select(accounts)..where((tbl) => tbl.isArchived.equals(false))).watch();

  Future<Account?> getAccountById(int id) =>
      (select(accounts)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Stream<Account?> watchAccountById(int id) =>
      (select(accounts)..where((tbl) => tbl.id.equals(id)))
          .watchSingleOrNull();

  Future<int> insertAccount(AccountsCompanion account) =>
      into(accounts).insert(account);

  Future<bool> updateAccount(AccountsCompanion account) =>
      update(accounts).replace(account);

  Future<int> archiveAccount(int id) {
    return (update(accounts)..where((tbl) => tbl.id.equals(id))).write(
      AccountsCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> unarchiveAccount(int id) {
    return (update(accounts)..where((tbl) => tbl.id.equals(id))).write(
      AccountsCompanion(
        isArchived: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

