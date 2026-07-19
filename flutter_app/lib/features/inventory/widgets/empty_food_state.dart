
library;
import "package:flutter/material.dart";

class EmptyFoodState extends StatelessWidget {
  const EmptyFoodState({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("\u{1F9CA}", style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text("冰箱还是空的", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            "去买点食材吧",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
