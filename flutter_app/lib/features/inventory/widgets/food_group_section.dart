library;
import "package:flutter/material.dart";

class FoodGroupSection extends StatelessWidget {
  final String title;
  final String icon;
  final int count;
  final List<Widget> children;
  const FoodGroupSection({
    super.key,
    required this.title,
    required this.icon,
    required this.count,
    required this.children,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text("\$icon \$title (\$count)", style: Theme.of(context).textTheme.titleMedium),
        ),
        ...children,
      ],
    );
  }
}
