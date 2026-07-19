library;
import "food_status.dart";

class FoodItem {
  final int? id;
  final String name;
  final String category;
  final String emoji;
  final DateTime expiryDate;
  final DateTime createdAt;
  final FoodStatus status;

  /// 购买日期，null 表示与录入日期相同
  final DateTime? purchaseDate;

  /// 数量，null 表示 1
  final int? quantity;

  /// 存放位置，如"冷藏层"、"冷冻层"，null 表示未指定
  final String? location;

  /// 用户备注
  final String? remark;

  const FoodItem({
    this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.expiryDate,
    required this.createdAt,
    this.status = FoodStatus.normal,
    this.purchaseDate,
    this.quantity,
    this.location,
    this.remark,
  });

  FoodItem copyWith({
    int? id,
    String? name,
    String? category,
    String? emoji,
    DateTime? expiryDate,
    DateTime? createdAt,
    FoodStatus? status,
    DateTime? purchaseDate,
    int? quantity,
    String? location,
    String? remark,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      quantity: quantity ?? this.quantity,
      location: location ?? this.location,
      remark: remark ?? this.remark,
    );
  }
}
