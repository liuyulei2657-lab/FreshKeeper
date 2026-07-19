library;
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/features/food/repository/food_repository.dart";

class UpdateFoodUseCase {
  final FoodRepository _repository;
  UpdateFoodUseCase(this._repository);

  Future<void> call({
    required int id,
    String? name,
    int? quantity,
    DateTime? expiryDate,
    String? location,
    String? remark,
  }) async {
    final existing = await _repository.getFoodItemById(id);
    if (existing == null) {
      throw StateError("未找到 ID 为 $id 的食材");
    }

    final updated = existing.copyWith(
      name: name,
      quantity: quantity,
      expiryDate: expiryDate,
      location: location,
      remark: remark,
    );

    await _repository.updateFoodItem(id, updated);
  }
}
