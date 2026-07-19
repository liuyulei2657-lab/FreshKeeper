library;
import "package:flutter_app/features/food/repository/food_repository.dart";

class DeleteFoodUseCase {
  final FoodRepository _repository;
  DeleteFoodUseCase(this._repository);

  Future<void> call(int id) async {
    await _repository.deleteFoodItem(id);
  }
}
