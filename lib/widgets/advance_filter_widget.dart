import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Defines a single dropdown field used inside [AdvanceFilterWidget].
class AdvanceFilterField {
  final String key;
  final String label;
  final String hint;
  final List<String> items;

  const AdvanceFilterField({
    required this.key,
    required this.label,
    required this.hint,
    required this.items,
  });
}

/// A reusable self-contained expandable advance-filter widget.
///
/// Renders a trigger bar that toggles an animated panel containing one
/// dropdown per [AdvanceFilterField], plus an "Apply Filter" button.
class AdvanceFilterWidget extends StatefulWidget {
  /// Field definitions for each dropdown.
  final List<AdvanceFilterField> fields;

  /// Current selected value for each field, keyed by [AdvanceFilterField.key].
  final Map<String, String?> values;

  /// Called with a fully updated value map whenever a dropdown changes.
  final ValueChanged<Map<String, String?>> onChanged;

  /// Called when the Apply Filter button is tapped (panel also collapses).
  final VoidCallback? onApply;

  /// Background color of the Apply Filter button.
  final Color applyButtonColor;

  /// Notified with the new open/closed state whenever the panel toggles.
  final ValueChanged<bool>? onExpandChanged;

  const AdvanceFilterWidget({
    super.key,
    required this.fields,
    required this.values,
    required this.onChanged,
    this.onApply,
    this.applyButtonColor = const Color(0xFF2181FF),
    this.onExpandChanged,
  });

  @override
  State<AdvanceFilterWidget> createState() => _AdvanceFilterWidgetState();
}

class _AdvanceFilterWidgetState extends State<AdvanceFilterWidget> {
  bool _isExpanded = false;

  void _toggle() {
    final next = !_isExpanded;
    setState(() => _isExpanded = next);
    widget.onExpandChanged?.call(next);
  }

  void _apply() {
    widget.onApply?.call();
    setState(() => _isExpanded = false);
    widget.onExpandChanged?.call(false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Trigger bar ──
        GestureDetector(
          onTap: _toggle,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.filter_alt_outlined, color: Colors.grey.shade500, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Advance Filter',
                  style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ),
        // ── Expandable panel ──
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          firstChild: const SizedBox.shrink(),
          secondChild: _buildPanel(),
          crossFadeState:
              _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
      ],
    );
  }

  Widget _buildPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        ...widget.fields.map(_buildField),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.applyButtonColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _apply,
            child: Text(
              'Apply Filter',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(AdvanceFilterField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.values[field.key],
                isExpanded: true,
                hint: Text(
                  field.hint,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade400),
                ),
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                items: field.items
                    .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                    .toList(),
                onChanged: (v) {
                  final updated = Map<String, String?>.from(widget.values);
                  updated[field.key] = v;
                  widget.onChanged(updated);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
