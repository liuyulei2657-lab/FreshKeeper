library;
import "package:flutter/material.dart";
import "package:flutter_app/core/utils/date_utils.dart";

class ExpiryDatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onSelected;
  const ExpiryDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onSelected,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now.add(const Duration(days: 7)),
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (date != null) onSelected(date);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pickDate(context),
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          selectedDate != null ? formatDate(selectedDate!) : "点击选择日期",
          style: TextStyle(
            color: selectedDate != null ? null : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
