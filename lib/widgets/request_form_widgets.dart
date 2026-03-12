import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  REUSABLE FORM WIDGETS for Supplier / Customer Request screens
// ═══════════════════════════════════════════════════════════════════════════

/// Section title inside a tab (e.g. "Identification Tab")
class FormTabTitle extends StatelessWidget {
  final String text;
  const FormTabTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

/// Description paragraph below a tab title
class FormTabDescription extends StatelessWidget {
  final String text;
  const FormTabDescription(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
    );
  }
}

/// Bold label above a section (e.g. "Customer Account Type")
class FormSectionLabel extends StatelessWidget {
  final String text;
  const FormSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

/// Radio option with custom orange dot style
class FormRadioOption extends StatelessWidget {
  final String label;
  final int value;
  final int groupValue;
  final ValueChanged<int> onChanged;

  const FormRadioOption({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.headerOrange : Colors.grey.shade400,
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
                        color: AppColors.headerOrange,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// Standard text input field
class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const FormTextField({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2181FF)),
        ),
      ),
    );
  }
}

/// Dropdown select field
class FormDropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool isRequired;

  const FormDropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: RichText(
            text: TextSpan(
              text: hint,
              style:
                  GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted),
              children: isRequired
                  ? [
                      TextSpan(
                        text: ' *',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.headerOrange,
                        ),
                      ),
                    ]
                  : null,
            ),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// Date picker field
class FormDateField extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const FormDateField({
    super.key,
    required this.date,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade500),
            const SizedBox(width: 12),
            Text(
              _formatDate(date),
              style: GoogleFonts.inter(
                  fontSize: 14, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final suffix = _daySuffix(date.day);
    return '${months[date.month - 1]} ${date.day}$suffix, ${date.year}';
  }

  static String _daySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }
}

/// Toggle switch row
class FormSwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const FormSwitchRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2181FF),
          ),
        ],
      ),
    );
  }
}

/// "+ Add ..." button (contacts, address, documents)
class FormAddButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const FormAddButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 44),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 18, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom action bar with Save As Draft + Submit
class FormBottomActions extends StatelessWidget {
  final VoidCallback onSaveDraft;
  final VoidCallback onSubmit;

  const FormBottomActions({
    super.key,
    required this.onSaveDraft,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: onSaveDraft,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Save As Draft',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2181FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable tab bar for Create Request screens (Identification, Attribute, etc.)
class FormTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> labels;

  const FormTabBar({
    super.key,
    required this.controller,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 48, // Fixed height for the pill container
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Row(
            // Row without SingleChildScrollView forces all items to fit on screen
            children: labels.asMap().entries.map((entry) {
              int index = entry.key;
              String label = entry.value;
              bool isSelected = controller.index == index;
              
              // Expanded forces each tab to take exactly equal width (1/7th of the screen)
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.animateTo(index);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2), // Tiny padding
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected
                              ? const Color(0xFF2181FF)
                              : Colors.transparent,
                          width: 3, // Thickness of the underline
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    // FittedBox scales the text down instead of wrapping to a second line
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        maxLines: 1, // Strictly forbids stacking
                        style: GoogleFonts.inter(
                          fontSize: 12, // Slightly smaller base font to help it fit
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF2181FF)
                              : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

/// Reusable request list widgets ──────────────────────────────────────────

/// History / Offline tab toggle
class RequestTabToggle extends StatelessWidget {
  final int currentTab;
  final ValueChanged<int> onTabChanged;

  const RequestTabToggle({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _tab("History", Icons.history, 0),
          _tab("Offline", Icons.wifi_off, 1),
        ],
      ),
    );
  }

  Widget _tab(String title, IconData icon, int index) {
    final isSelected = currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: isSelected ? Colors.black87 : Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isSelected ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Status filter dropdown with colored dots
class StatusFilterDropdown extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onChanged;
  final List<String> statuses;

  const StatusFilterDropdown({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
    this.statuses = const ['All', 'Active', 'Draft', 'Archive'],
  });

  Color _dotColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF10B981);
      case 'Draft':
        return Colors.grey.shade500;
      case 'Archive':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_alt_outlined,
              color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 8),
          if (selectedStatus != 'All') ...[
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: _dotColor(selectedStatus).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedStatus,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _dotColor(selectedStatus),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => onChanged('All'),
                    child: Icon(Icons.close,
                        size: 14, color: _dotColor(selectedStatus)),
                  ),
                ],
              ),
            ),
          ] else
            Text(
              "Status",
              style: GoogleFonts.inter(
                  fontSize: 13, color: Colors.grey.shade600),
            ),
          const Spacer(),
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.keyboard_arrow_down,
                color: Colors.grey.shade500),
            onSelected: onChanged,
            itemBuilder: (_) => statuses.map((s) {
              final isSelected = s == selectedStatus;
              return PopupMenuItem(
                value: s,
                child: Row(
                  children: [
                    if (isSelected)
                      Icon(Icons.check_circle,
                          size: 18, color: _dotColor(s))
                    else
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _dotColor(s), width: 2),
                        ),
                      ),
                    const SizedBox(width: 10),
                    Text(s, style: GoogleFonts.inter(fontSize: 13)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Advance filter label
class AdvanceFilterLabel extends StatelessWidget {
  final String text;
  const AdvanceFilterLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

/// Advance filter dropdown
class AdvanceFilterDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const AdvanceFilterDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint,
              style: GoogleFonts.inter(
                  fontSize: 13, color: Colors.grey.shade400)),
          icon:
              Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
          style:
              GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// Record card (supplier / customer)
class RequestRecordCard extends StatelessWidget {
  final String name;
  final String status;
  final Map<String, String> details;
  final VoidCallback? onEdit;
  final VoidCallback? onView;

  const RequestRecordCard({
    super.key,
    required this.name,
    required this.status,
    required this.details,
    this.onEdit,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == 'Active';
    final Color statusColor =
        isActive ? const Color(0xFF10B981) : Colors.grey.shade500;
    final Color statusBg = isActive
        ? const Color(0xFF10B981).withValues(alpha: 0.1)
        : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
                width: 24,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_vert,
                      size: 20, color: Colors.black54),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined,
                              color: Colors.amber, size: 18),
                          const SizedBox(width: 8),
                          Text("Edit",
                              style: GoogleFonts.inter(fontSize: 13)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_outlined,
                              color: Colors.blue, size: 18),
                          const SizedBox(width: 8),
                          Text("View",
                              style: GoogleFonts.inter(fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (val) {
                    if (val == 'edit') onEdit?.call();
                    if (val == 'view') onView?.call();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...details.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.key,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        e.value,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
