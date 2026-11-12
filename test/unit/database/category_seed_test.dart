import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/core/database/app_database.dart';
import 'package:ufm/core/database/seeds/default_categories.dart';
import 'package:ufm/core/database/tables/categories_table.dart';
import 'in_memory_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('Category Seed Data', () {
    test('seeds exactly 13 default categories on fresh database creation',
        () async {
      final categories = await db.categoriesDao.getAllCategories();
      expect(categories.length, equals(13));

      // All seeded categories have isDefault = true and isArchived = false
      for (final cat in categories) {
        expect(cat.isDefault, isTrue);
        expect(cat.isArchived, isFalse);
        expect(cat.name.isNotEmpty, isTrue);
        expect(cat.iconKey, isNotNull);
      }
    });

    test('seeds include key expenses and incomes', () async {
      final expenseCategories =
          await db.categoriesDao.getCategoriesByKind(CategoryKind.expense);
      final expenseNames = expenseCategories.map((c) => c.name).toList();
      expect(expenseNames, contains('Food & Dining'));
      expect(expenseNames, contains('Groceries'));
      expect(expenseNames, contains('Transport & Fuel'));
      expect(expenseNames, contains('Bills & Utilities'));
      expect(expenseNames, contains('Shopping'));
      expect(expenseNames, contains('Health & Medical'));
      expect(expenseNames, contains('Entertainment'));
      expect(expenseNames, contains('Housing & Rent'));
      expect(expenseNames, contains('Other')); // 'both' kind

      final incomeCategories =
          await db.categoriesDao.getCategoriesByKind(CategoryKind.income);
      final incomeNames = incomeCategories.map((c) => c.name).toList();
      expect(incomeNames, contains('Salary & Wages'));
      expect(incomeNames, contains('Business & Freelance'));
      expect(incomeNames, contains('Investments & Returns'));
      expect(incomeNames, contains('Gifts & Cashbacks'));
      expect(incomeNames, contains('Other')); // 'both' kind
    });

    test('re-running seedDefaultCategories does not create duplicates',
        () async {
      final initialCount = (await db.categoriesDao.getAllCategories()).length;
      expect(initialCount, equals(13));

      await seedDefaultCategories(db);

      final finalCount = (await db.categoriesDao.getAllCategories()).length;
      expect(finalCount, equals(13));
    });
  });
}

