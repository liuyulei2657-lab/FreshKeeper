library;
import "package:flutter/material.dart";

class SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;
  const SettingTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(title), subtitle: Text(subtitle), trailing: trailing);
  }
}
