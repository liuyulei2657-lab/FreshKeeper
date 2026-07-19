library;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_app/core/database/app_database.dart";
import "package:flutter_app/core/database/daos/food_item_dao.dart";
import "package:flutter_app/features/food/repository/food_repository.dart";
import "package:flutter_app/features/food/usecases/add_food_use_case.dart";
import "package:flutter_app/features/food/usecases/delete_food_use_case.dart";
import "package:flutter_app/features/food/usecases/consume_food_use_case.dart";
import "package:flutter_app/features/food/usecases/update_food_use_case.dart";

import "package:flutter_app/features/food/repository/food_repository_impl.dart";
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/features/food/models/food_status.dart";

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
final foodItemDaoProvider = Provider<FoodItemDao>((ref) => ref.watch(databaseProvider).foodItemDao);
final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepositoryImpl(ref.watch(foodItemDaoProvider));
});

final addFoodUseCaseProvider = Provider<AddFoodUseCase>((ref) {
  return AddFoodUseCase(ref.watch(foodRepositoryProvider));
});

final updateFoodUseCaseProvider = Provider<UpdateFoodUseCase>((ref) {
  return UpdateFoodUseCase(ref.watch(foodRepositoryProvider));
});

final deleteFoodUseCaseProvider = Provider<DeleteFoodUseCase>((ref) {
  return DeleteFoodUseCase(ref.watch(foodRepositoryProvider));
});

final consumeFoodUseCaseProvider = Provider<ConsumeFoodUseCase>((ref) {
  return ConsumeFoodUseCase(ref.watch(foodRepositoryProvider));
});

final foodItemListProvider = FutureProvider<List<FoodItem>>((ref) async {
  return ref.watch(foodRepositoryProvider).getAllFoodItems();
});

final foodItemDetailProvider = FutureProvider.family<FoodItem?, int>((ref, id) async {
  return ref.watch(foodRepositoryProvider).getFoodItemById(id);
});

final deleteFoodItemProvider = FutureProvider.family<void, int>((ref, id) async {
  await ref.watch(deleteFoodUseCaseProvider).call(id);
  ref.invalidate(foodItemListProvider);
});
