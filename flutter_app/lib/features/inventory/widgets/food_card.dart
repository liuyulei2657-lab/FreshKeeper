library;
import "package:flutter/material.dart";
import "package:flutter_app/core/utils/date_utils.dart";
import "package:flutter_app/features/food/models/food_item.dart";

class FoodCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback? onTap;
  const FoodCard({
    super.key,
    required this.item,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final days = daysUntilExpiry(item.expiryDate);

    Color statusColor;
    Color? statusBg;
    String statusText;
    if (days <= 0) {
      statusColor = colorScheme.error;
      statusBg = colorScheme.errorContainer;
      statusText = "已过期";
    } else if (days <= 3) {
      statusColor = Colors.orange;
      statusBg = Colors.orange.withValues(alpha: 0.12);
      statusText = "即将过期";
    } else {
      statusColor = colorScheme.onSurfaceVariant;
      statusBg = colorScheme.surfaceContainerLow;
      statusText = "正常";
    }

    return Card(
      color: statusBg,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Text(item.emoji, style: const TextStyle(fontSize: 36)),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "${item.category} · ${formatRemainingDays(days)}",
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
