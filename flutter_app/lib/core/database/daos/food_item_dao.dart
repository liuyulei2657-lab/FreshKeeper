library;
import "package:drift/drift.dart";
import "../app_database.dart";
import "../tables/food_item_table.dart";

part "food_item_dao.g.dart";

@DriftAccessor(tables: [FoodItems])
class FoodItemDao extends DatabaseAccessor<AppDatabase> with _$FoodItemDaoMixin {
  FoodItemDao(super.db);

  Future<List<FoodItemModel>> getAllFoodItems() {
    return (select(foodItems)..orderBy([(f) => OrderingTerm(expression: f.expiryDate)])).get();
  }

  Future<FoodItemModel?> getFoodItemById(int id) {
    return (select(foodItems)..where((f) => f.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertFoodItem(FoodItemsCompanion entry) {
    return into(foodItems).insert(entry);
  }

  Future<void> updateStatus(int id, int newStatusIndex) {
    return (update(foodItems)..where((f) => f.id.equals(id)))
        .write(FoodItemsCompanion(statusIndex: Value(newStatusIndex)));
  }

  Future<void> updateExpiryDate(int id, DateTime newDate) {
    return (update(foodItems)..where((f) => f.id.equals(id)))
        .write(FoodItemsCompanion(expiryDate: Value(newDate)));
  }

  Future<void> deleteFoodItem(int id) {
    return (delete(foodItems)..where((f) => f.id.equals(id))).go();
  }
}
