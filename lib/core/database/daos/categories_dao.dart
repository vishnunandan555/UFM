import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categories_table.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  Future<List<Category>> getAllCategories() => select(categories).get();

  Future<List<Category>> getActiveCategories() =>
      (select(categories)..where((tbl) => tbl.isArchived.equals(false))).get();

  Future<List<Category>> getCategoriesByKind(CategoryKind kind) {
    return (select(categories)
          ..where((tbl) =>
              tbl.isArchived.equals(false) &
              (tbl.kind.equals(kind.name) |
                  tbl.kind.equals(CategoryKind.both.name))))
        .get();
  }

  Stream<List<Category>> watchActiveCategories() =>
      (select(categories)..where((tbl) => tbl.isArchived.equals(false)))
          .watch();

  Future<Category?> getCategoryById(int id) =>
      (select(categories)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertCategory(CategoriesCompanion category) =>
      into(categories).insert(category);

  Future<bool> updateCategory(CategoriesCompanion category) =>
      update(categories).replace(category);

  Future<int> archiveCategory(int id) {
    return (update(categories)..where((tbl) => tbl.id.equals(id))).write(
      const CategoriesCompanion(
        isArchived: Value(true),
      ),
    );
  }
}

