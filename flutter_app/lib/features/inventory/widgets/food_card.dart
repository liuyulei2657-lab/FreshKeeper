library;
import "package:flutter/material.dart";

class FoodCard extends StatelessWidget {
  final String name;
  final String emoji;
  final int remainingDays;
  final VoidCallback? onTap;
  const FoodCard({
    super.key,
    required this.name,
    required this.emoji,
    required this.remainingDays,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color cardColor;
    if (remainingDays <= 0) {
      cardColor = colorScheme.errorContainer;
    } else if (remainingDays <= 3) {
      cardColor = colorScheme.tertiaryContainer;
    } else {
      cardColor = colorScheme.surfaceContainerLow;
    }
    return Card(
      color: cardColor,
      child: ListTile(
        leading: Text(emoji, style: const TextStyle(fontSize: 28)),
        title: Text(name),
        trailing: Text(
          remainingDays <= 0 ? "已过期" : "$remainingDays 天",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        onTap: onTap,
      ),
    );
  }
}
