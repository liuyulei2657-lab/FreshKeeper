library;
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/features/food/repository/food_repository.dart";

class AddFoodUseCase {
  final FoodRepository _repository;
  AddFoodUseCase(this._repository);

  Future<FoodItem> call({
    required String name,
    required String category,
    required String emoji,
    required DateTime expiryDate,
    DateTime? purchaseDate,
    int? quantity,
    String? location,
    String? remark,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError("食材名称不能为空");
    }

    final item = FoodItem(
      name: name.trim(),
      category: category,
      emoji: emoji,
      expiryDate: expiryDate,
      createdAt: DateTime.now(),
      purchaseDate: purchaseDate ?? DateTime.now(),
      quantity: quantity ?? 1,
      location: location,
      remark: remark,
    );

    final id = await _repository.addFoodItem(item);
    return item.copyWith(id: id);
  }
}
