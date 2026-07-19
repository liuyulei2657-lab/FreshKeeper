library;
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/features/food/models/food_status.dart";

abstract class FoodRepository {
  Future<List<FoodItem>> getAllFoodItems();
  Future<FoodItem?> getFoodItemById(int id);
  Future<int> addFoodItem(FoodItem item);
  Future<void> updateFoodStatus(int id, FoodStatus status);
  Future<void> updateExpiryDate(int id, DateTime newDate);
  Future<void> deleteFoodItem(int id);
}
