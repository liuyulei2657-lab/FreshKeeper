library;
import "package:flutter/material.dart";

class SectionHeader extends StatelessWidget {
  final String icon;
  final String title;
  final int count;
  const SectionHeader({super.key, required this.icon, required this.title, required this.count});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text("$icon $title ($count)", style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
