import 'package:flutter/material.dart';

class FilterTabs extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const FilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  Widget buildTab(String label, String value) {
    final bool active = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: Container(
          constraints: const BoxConstraints(minHeight: 36),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF2181FF) : Colors.white,
            border: active ? null : Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildTab("Last 7 Days", "7"),
        const SizedBox(width: 8),
        buildTab("Last 30 Days", "30"),
        const SizedBox(width: 8),
        buildTab("Custom", "custom"),
      ],
    );
  }
}