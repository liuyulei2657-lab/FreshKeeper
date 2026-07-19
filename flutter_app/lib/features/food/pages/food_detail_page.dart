library;
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_app/features/food/providers/food_providers.dart";
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/core/utils/date_utils.dart";

class FoodDetailPage extends ConsumerWidget {
  final int foodId;
  const FoodDetailPage({super.key, required this.foodId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItem = ref.watch(foodItemDetailProvider(foodId));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: asyncItem.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text("加载失败", style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        data: (item) {
          if (item == null) {
            return Center(
              child: Text("食材不存在", style: Theme.of(context).textTheme.bodyLarge),
            );
          }
          return _Body(item: item);
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final FoodItem item;
  const _Body({required this.item});

  int get _days => daysUntilExpiry(item.expiryDate);

  (String, Color) _status(ColorScheme cs) {
    if (_days <= 0) return ("已过期", cs.error);
    if (_days <= 3) return ("即将过期", Colors.orange);
    return ("正常", cs.primary);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (statusText, statusColor) = _status(cs);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          _buildHeader(context, cs, statusText, statusColor),
          const SizedBox(height: 24),
          _buildInfoCard(context, cs),
          const SizedBox(height: 24),
          _buildActions(context, cs),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme cs, String statusText, Color statusColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: cs.primaryContainer,
          child: Text(item.emoji, style: const TextStyle(fontSize: 44)),
        ),
        const SizedBox(height: 16),
        Text(item.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(item.category, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity( 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, ColorScheme cs) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(icon: Icons.calendar_today, label: "购买日期", value: formatDate(item.purchaseDate ?? item.createdAt), cs: cs),
            const Divider(height: 20),
            _InfoRow(icon: Icons.event, label: "过期日期", value: formatDate(item.expiryDate), cs: cs),
            const Divider(height: 20),
            _InfoRow(icon: Icons.timer, label: "剩余天数", value: formatRemainingDays(_days), cs: cs),
            if (item.quantity != null) ...[
              const Divider(height: 20),
              _InfoRow(icon: Icons.numbers, label: "数量", value: "${item.quantity}", cs: cs),
            ],
            if (item.location != null && item.location!.isNotEmpty) ...[
              const Divider(height: 20),
              _InfoRow(icon: Icons.location_on, label: "存放位置", value: item.location!, cs: cs),
            ],
            if (item.remark != null && item.remark!.isNotEmpty) ...[
              const Divider(height: 20),
              _InfoRow(icon: Icons.notes, label: "备注", value: item.remark!, cs: cs),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: () => _comingSoon(context),
          icon: const Icon(Icons.edit),
          label: const Text("编辑"),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => _comingSoon(context),
          icon: const Icon(Icons.check_circle),
          label: const Text("标记吃完"),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _comingSoon(context),
          icon: const Icon(Icons.delete_forever),
          label: const Text("删除"),
          style: OutlinedButton.styleFrom(foregroundColor: cs.error, side: BorderSide(color: cs.error)),
        ),
      ],
    );
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("功能开发中")));
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme cs;
  const _InfoRow({required this.icon, required this.label, required this.value, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: cs.onSurfaceVariant),
        const SizedBox(width: 12),
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const Spacer(),
        Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
