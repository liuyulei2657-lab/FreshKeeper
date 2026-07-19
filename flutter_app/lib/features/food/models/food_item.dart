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

  const FoodItem({
    this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.expiryDate,
    required this.createdAt,
    this.status = FoodStatus.normal,
  });

  FoodItem copyWith({
    int? id,
    String? name,
    String? category,
    String? emoji,
    DateTime? expiryDate,
    DateTime? createdAt,
    FoodStatus? status,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
