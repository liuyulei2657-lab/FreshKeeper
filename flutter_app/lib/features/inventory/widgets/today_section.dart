library;
import "package:flutter/material.dart";

class TodaySection extends StatelessWidget {
  final List<String> expiringItems;
  const TodaySection({super.key, required this.expiringItems});
  @override
  Widget build(BuildContext context) {
    if (expiringItems.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🥬 今天吃这些", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...expiringItems.map((name) => Text(name, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
