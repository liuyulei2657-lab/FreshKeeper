library;
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("FreshKeeper")),
      body: const Center(child: Text("冰箱库存页 - 待实现")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("/add"),
        child: const Icon(Icons.add),
      ),
    );
  }
}
