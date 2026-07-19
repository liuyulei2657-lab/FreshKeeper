library;
import "package:flutter/material.dart";

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("🧊", style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text("冰箱还是空的", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text("点 + 号记下你买的食材吧", style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
