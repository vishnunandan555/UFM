import 'package:drift/native.dart';
import 'package:ufm/core/database/app_database.dart';

AppDatabase createTestDatabase() {
  return AppDatabase(
    NativeDatabase.memory(
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON;');
      },
    ),
  );
}
