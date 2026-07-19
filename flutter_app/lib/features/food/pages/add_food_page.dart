library;
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:flutter_app/features/food/providers/food_providers.dart";
import "package:flutter_app/features/food/widgets/food_form_field.dart";
import "package:flutter_app/features/food/widgets/expiry_date_picker.dart";
import "package:flutter_app/core/utils/food_emoji.dart";

class AddFoodPage extends ConsumerStatefulWidget {
  const AddFoodPage({super.key});
  @override
  ConsumerState<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends ConsumerState<AddFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _locationController = TextEditingController();
  final _remarkController = TextEditingController();

  String? _selectedCategory;
  DateTime? _purchaseDate;
  DateTime? _expiryDate;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      _showError("请选择分类");
      return;
    }
    if (_expiryDate == null) {
      _showError("请选择过期日期");
      return;
    }

    setState(() => _isSaving = true);

    try {
      final name = _nameController.text.trim();
      final emoji = emojiForFood(name);

      await ref.read(addFoodUseCaseProvider).call(
        name: name,
        category: _selectedCategory!,
        emoji: emoji,
        expiryDate: _expiryDate!,
        purchaseDate: _purchaseDate,
        quantity: int.tryParse(_quantityController.text),
        location: _locationController.text.isNotEmpty ? _locationController.text.trim() : null,
        remark: _remarkController.text.isNotEmpty ? _remarkController.text.trim() : null,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("食材已添加")),
        );
        context.pop();
      }
    } catch (e) {
      _showError("保存失败: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("新增食材")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "菜名",
                hintText: "输入食材名称",
                prefixIcon: Icon(Icons.restaurant),
              ),
              validator: (v) => v == null || v.trim().isEmpty ? "请输入食材名称" : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            FoodFormField(
              value: _selectedCategory,
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
            const SizedBox(height: 16),

            ExpiryDatePicker(
              label: "购买日期",
              selectedDate: _purchaseDate,
              onSelected: (d) => setState(() => _purchaseDate = d),
            ),
            const SizedBox(height: 16),

            ExpiryDatePicker(
              label: "过期日期",
              selectedDate: _expiryDate,
              onSelected: (d) => setState(() => _expiryDate = d),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: "数量",
                hintText: "默认为 1",
                prefixIcon: Icon(Icons.numbers),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: "存放位置",
                hintText: "如：冷藏层、冷冻层",
                prefixIcon: Icon(Icons.location_on),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _remarkController,
              decoration: const InputDecoration(
                labelText: "备注",
                hintText: "可选",
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: _isSaving ? null : _handleSave,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? "保存中..." : "保存食材"),
            ),
          ],
        ),
      ),
    );
  }
}
