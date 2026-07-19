library;
import "package:flutter_app/features/food/models/food_status.dart";
import "package:flutter_app/features/food/repository/food_repository.dart";

class ConsumeFoodUseCase {
  final FoodRepository _repository;
  ConsumeFoodUseCase(this._repository);

  Future<void> call(int id) async {
    await _repository.updateFoodStatus(id, FoodStatus.consumed);
  }
}
