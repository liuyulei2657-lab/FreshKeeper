library;
import "package:flutter/material.dart";
import "package:flutter_app/features/food/models/food_category.dart";

class FoodFormField extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  const FoodFormField({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration(
        labelText: "分类",
        prefixIcon: Icon(Icons.category),
      ),
      items: FoodCategory.values.map((cat) {
        return DropdownMenuItem(value: cat.label, child: Text(cat.label));
      }).toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      validator: (v) => v == null ? "请选择分类" : null,
    );
  }
}
