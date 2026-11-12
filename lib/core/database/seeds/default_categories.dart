import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categories_table.dart';

class DefaultCategorySeed {
  final String name;
  final CategoryKind kind;
  final String? iconKey;
  final bool isDefault;

  const DefaultCategorySeed({
    required this.name,
    required this.kind,
    this.iconKey,
    this.isDefault = true,
  });
}

const List<DefaultCategorySeed> defaultCategorySeeds = [
  DefaultCategorySeed(
    name: 'Food & Dining',
    kind: CategoryKind.expense,
    iconKey: 'restaurant',
  ),
  DefaultCategorySeed(
    name: 'Groceries',
    kind: CategoryKind.expense,
    iconKey: 'shopping_cart',
  ),
  DefaultCategorySeed(
    name: 'Transport & Fuel',
    kind: CategoryKind.expense,
    iconKey: 'directions_car',
  ),
  DefaultCategorySeed(
    name: 'Bills & Utilities',
    kind: CategoryKind.expense,
    iconKey: 'receipt_long',
  ),
  DefaultCategorySeed(
    name: 'Shopping',
    kind: CategoryKind.expense,
    iconKey: 'shopping_bag',
  ),
  DefaultCategorySeed(
    name: 'Health & Medical',
    kind: CategoryKind.expense,
    iconKey: 'medical_services',
  ),
  DefaultCategorySeed(
    name: 'Entertainment',
    kind: CategoryKind.expense,
    iconKey: 'movie',
  ),
  DefaultCategorySeed(
    name: 'Housing & Rent',
    kind: CategoryKind.expense,
    iconKey: 'home',
  ),
  DefaultCategorySeed(
    name: 'Salary & Wages',
    kind: CategoryKind.income,
    iconKey: 'payments',
  ),
  DefaultCategorySeed(
    name: 'Business & Freelance',
    kind: CategoryKind.income,
    iconKey: 'business_center',
  ),
  DefaultCategorySeed(
    name: 'Investments & Returns',
    kind: CategoryKind.income,
    iconKey: 'trending_up',
  ),
  DefaultCategorySeed(
    name: 'Gifts & Cashbacks',
    kind: CategoryKind.income,
    iconKey: 'card_giftcard',
  ),
  DefaultCategorySeed(
    name: 'Other',
    kind: CategoryKind.both,
    iconKey: 'category',
  ),
];

Future<void> seedDefaultCategories(AppDatabase db) async {
  await db.batch((batch) {
    for (var i = 0; i < defaultCategorySeeds.length; i++) {
      final seed = defaultCategorySeeds[i];
      batch.insert(
        db.categories,
        CategoriesCompanion(
          id: Value(i + 1),
          name: Value(seed.name),
          kind: Value(seed.kind),
          iconKey: Value(seed.iconKey),
          isDefault: Value(seed.isDefault),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  });
}
