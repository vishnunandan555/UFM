// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_attempts_dao.dart';

// ignore_for_file: type=lint
mixin _$PaymentAttemptsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $PaymentAttemptsTable get paymentAttempts => attachedDatabase.paymentAttempts;
  PaymentAttemptsDaoManager get managers => PaymentAttemptsDaoManager(this);
}

class PaymentAttemptsDaoManager {
  final _$PaymentAttemptsDaoMixin _db;
  PaymentAttemptsDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$PaymentAttemptsTableTableManager get paymentAttempts =>
      $$PaymentAttemptsTableTableManager(
        _db.attachedDatabase,
        _db.paymentAttempts,
      );
}
