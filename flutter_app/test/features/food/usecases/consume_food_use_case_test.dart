library;
import "package:flutter_test/flutter_test.dart";
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/features/food/models/food_status.dart";
import "package:flutter_app/features/food/repository/food_repository.dart";
import "package:flutter_app/features/food/usecases/consume_food_use_case.dart";

class _MockRepo implements FoodRepository {
  int? updatedId;
  FoodStatus? updatedStatus;
  @override Future<void> updateFoodStatus(int id, FoodStatus status) async {
    updatedId = id;
    updatedStatus = status;
  }
  @override Future<List<FoodItem>> getAllFoodItems() async => [];
  @override Future<FoodItem?> getFoodItemById(int id) async => null;
  @override Future<int> addFoodItem(FoodItem item) async => 1;
  @override Future<void> updateExpiryDate(int id, DateTime newDate) async {}
  @override Future<void> updateFoodItem(int id, FoodItem item) async {}
  @override Future<void> deleteFoodItem(int id) async {}
}

void main() {
  group("ConsumeFoodUseCase", () {
    test("标记食材为已消耗", () async {
      final mock = _MockRepo();
      final useCase = ConsumeFoodUseCase(mock);
      await useCase.call(3);
      expect(mock.updatedId, 3);
      expect(mock.updatedStatus, FoodStatus.consumed);
    });
  });
}
