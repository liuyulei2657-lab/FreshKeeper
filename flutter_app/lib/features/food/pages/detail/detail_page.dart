library;
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class DetailPage extends ConsumerWidget {
  final int foodId;
  const DetailPage({super.key, required this.foodId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("食材详情页 - ID: \$foodId")),
    );
  }
}
