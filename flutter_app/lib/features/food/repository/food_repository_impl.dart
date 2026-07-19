library;
import "package:flutter_app/core/database/daos/food_item_dao.dart";
import "package:flutter_app/core/database/tables/food_item_table.dart";
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/features/food/models/food_status.dart";
import "package:flutter_app/features/food/repository/food_repository.dart";

class FoodRepositoryImpl implements FoodRepository {
  final FoodItemDao _dao;
  FoodRepositoryImpl(this._dao);

  @override
  Future<List<FoodItem>> getAllFoodItems() async {
    final models = await _dao.getAllFoodItems();
    return models.map(_toEntity).toList();
  }

  @override
  Future<FoodItem?> getFoodItemById(int id) async {
    final model = await _dao.getFoodItemById(id);
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<int> addFoodItem(FoodItem item) async {
    return _dao.insertFoodItem(_toCompanion(item));
  }

  @override
  Future<void> updateFoodStatus(int id, FoodStatus status) async {
    await _dao.updateStatus(id, status.index);
  }

  @override
  Future<void> updateExpiryDate(int id, DateTime newDate) async {
    await _dao.updateExpiryDate(id, newDate);
  }

@override
  Future<void> updateFoodItem(int id, FoodItem item) async {
    await _dao.updateFoodItem(id, _toCompanion(item));
  }

  @override
  Future<void> deleteFoodItem(int id) async {
    await _dao.deleteFoodItem(id);
  }

  FoodItem _toEntity(FoodItemModel model) => FoodItem(
    id: model.id,
    name: model.name,
    category: model.category,
    emoji: model.emoji,
    expiryDate: model.expiryDate,
    createdAt: model.createdAt,
    status: FoodStatus.fromIndex(model.statusIndex),
    purchaseDate: model.purchaseDate,
    quantity: model.quantity,
    location: model.location,
    remark: model.remark,
  );

  FoodItemsCompanion _toCompanion(FoodItem item) => FoodItemsCompanion(
    name: Value(item.name),
    category: Value(item.category),
    emoji: Value(item.emoji),
    expiryDate: Value(item.expiryDate),
    createdAt: Value(item.createdAt),
    statusIndex: Value(item.status.index),
    purchaseDate: Value(item.purchaseDate),
    quantity: Value(item.quantity),
    location: Value(item.location),
    remark: Value(item.remark),
  );
}
