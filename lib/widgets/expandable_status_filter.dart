import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable expandable status filter widget.
///
/// Displays a trigger bar that expands to show a list of status options
/// with colored dots and radio-style selection.
class ExpandableStatusFilter extends StatefulWidget {
  /// List of statuses, each with a 'label' (String) and 'color' (Color).
  final List<Map<String, dynamic>> statuses;

  /// Currently selected status label, or null if none selected.
  final String? selectedStatus;

  /// Called when a status is selected or deselected.
  final ValueChanged<String?> onChanged;

  /// Placeholder text shown when no status is selected.
  final String placeholder;

  const ExpandableStatusFilter({
    super.key,
    required this.statuses,
    required this.selectedStatus,
    required this.onChanged,
    this.placeholder = 'Filter Status',
  });

  @override
  State<ExpandableStatusFilter> createState() =>
      _ExpandableStatusFilterState();
}

class _ExpandableStatusFilterState extends State<ExpandableStatusFilter> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Trigger bar
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.filter_alt_outlined,
                    color: Colors.grey.shade500, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.selectedStatus ?? widget.placeholder,
                  style: GoogleFonts.inter(
                    color: widget.selectedStatus != null
                        ? Colors.black87
                        : Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down,
                      color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ),

        // Expandable options list
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: widget.statuses.map((s) {
                final String label = s['label'] as String;
                final Color color = s['color'] as Color;
                final bool isSelected = widget.selectedStatus == label;
                return InkWell(
                  onTap: () {
                    widget.onChanged(isSelected ? null : label);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2181FF)
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF2181FF),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: GoogleFonts.inter(
                              fontSize: 13, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}
