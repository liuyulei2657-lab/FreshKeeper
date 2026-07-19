library;
import "package:flutter_test/flutter_test.dart";
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/features/food/models/food_status.dart";
import "package:flutter_app/features/food/repository/food_repository.dart";
import "package:flutter_app/features/food/usecases/delete_food_use_case.dart";

class _MockRepo implements FoodRepository {
  int? deletedId;
  @override Future<void> deleteFoodItem(int id) async { deletedId = id; }
  @override Future<List<FoodItem>> getAllFoodItems() async => [];
  @override Future<FoodItem?> getFoodItemById(int id) async => null;
  @override Future<int> addFoodItem(FoodItem item) async => 1;
  @override Future<void> updateFoodStatus(int id, FoodStatus status) async {}
  @override Future<void> updateExpiryDate(int id, DateTime newDate) async {}
  @override Future<void> updateFoodItem(int id, FoodItem item) async {}
}

void main() {
  group("DeleteFoodUseCase", () {
    test("按 ID 删除食材", () async {
      final mock = _MockRepo();
      final useCase = DeleteFoodUseCase(mock);
      await useCase.call(5);
      expect(mock.deletedId, 5);
    });
  });
}
