library;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/features/food/providers/food_providers.dart";
import "package:flutter_app/core/utils/date_utils.dart";

final todayExpiredProvider = Provider<List<FoodItem>>((ref) {
  final items = ref.watch(foodItemListProvider).valueOrNull ?? [];
  return items.where((item) {
    if (!item.status.isActive) return false;
    return daysUntilExpiry(item.expiryDate) <= 0;
  }).toList();
});

final expiringSoonProvider = Provider<List<FoodItem>>((ref) {
  final items = ref.watch(foodItemListProvider).valueOrNull ?? [];
  return items.where((item) {
    if (!item.status.isActive) return false;
    final days = daysUntilExpiry(item.expiryDate);
    return days > 0 && days <= 3;
  }).toList();
});

final otherItemsProvider = Provider<List<FoodItem>>((ref) {
  final items = ref.watch(foodItemListProvider).valueOrNull ?? [];
  return items.where((item) {
    if (!item.status.isActive) return false;
    return daysUntilExpiry(item.expiryDate) > 3;
  }).toList();
});
