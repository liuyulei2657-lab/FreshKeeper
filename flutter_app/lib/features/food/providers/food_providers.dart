library;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_app/core/database/app_database.dart";
import "package:flutter_app/core/database/daos/food_item_dao.dart";
import "package:flutter_app/features/food/repository/food_repository.dart";
import "package:flutter_app/features/food/repository/food_repository_impl.dart";
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/features/food/models/food_status.dart";

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
final foodItemDaoProvider = Provider<FoodItemDao>((ref) => ref.watch(databaseProvider).foodItemDao);
final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepositoryImpl(ref.watch(foodItemDaoProvider));
});

final foodItemListProvider = FutureProvider<List<FoodItem>>((ref) async {
  return ref.watch(foodRepositoryProvider).getAllFoodItems();
});

final foodItemDetailProvider = FutureProvider.family<FoodItem?, int>((ref, id) async {
  return ref.watch(foodRepositoryProvider).getFoodItemById(id);
});

final deleteFoodItemProvider = FutureProvider.family<void, int>((ref, id) async {
  await ref.watch(foodRepositoryProvider).deleteFoodItem(id);
  ref.invalidate(foodItemListProvider);
});
