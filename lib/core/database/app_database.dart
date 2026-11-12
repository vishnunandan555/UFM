import 'package:drift/drift.dart';
import 'connection/open_connection.dart';
import 'daos/accounts_dao.dart';
import 'daos/categories_dao.dart';
import 'daos/payment_attempts_dao.dart';
import 'daos/transactions_dao.dart';
import 'daos/transfers_dao.dart';
import 'seeds/default_categories.dart';
import 'tables/accounts_table.dart';
import 'tables/categories_table.dart';
import 'tables/payment_attempts_table.dart';
import 'tables/transactions_table.dart';
import 'tables/transfers_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    Categories,
    Transactions,
    Transfers,
    PaymentAttempts,
  ],
  daos: [
    AccountsDao,
    CategoriesDao,
    TransactionsDao,
    TransfersDao,
    PaymentAttemptsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
        onCreate: (m) async {
          await m.createAll();
          await seedDefaultCategories(this);
        },
      );
}

