library;
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_app/features/food/providers/food_providers.dart";
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/features/inventory/widgets/empty_food_state.dart";
import "package:flutter_app/features/inventory/widgets/food_card.dart";

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(foodItemListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("FreshKeeper")),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              "加载失败\n$error",
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
        data: (items) {
          final activeItems = items.where((item) => item.status.isActive).toList();
          if (activeItems.isEmpty) return const EmptyFoodState();
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            itemCount: activeItems.length,
            itemBuilder: (context, index) => FoodCard(
              item: activeItems[index],
            ),
          );
        },
      ),
    );
  }
}
