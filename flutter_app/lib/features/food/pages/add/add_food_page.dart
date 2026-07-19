library;
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AddFoodPage extends ConsumerWidget {
  const AddFoodPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("新增食材")),
      body: const Center(child: Text("新增食材页 - 待实现")),
    );
  }
}
