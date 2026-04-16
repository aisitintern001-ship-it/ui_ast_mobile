import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/text_input.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Admin Edit Expense Modal - Simplified modal for admins to edit expense claims.
/// Includes Employee selection field that employees don't see.
class AdminEditExpenseModal extends StatefulWidget {
  final Map<String, dynamic>? claim;

  const AdminEditExpenseModal({super.key, this.claim});

  @override
  State<AdminEditExpenseModal> createState() => _AdminEditExpenseModalState();
}

class _AdminEditExpenseModalState extends State<AdminEditExpenseModal> {
  String? selectedEmployee;
  String? selectedCategory;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<String> employees = [
    'Edward Peter',
    'Amanda Roberts',
    'John Smith',
    'Maria Garcia',
  ];

  final List<String> categories = [
    'Transportation',
    'Meals',
    'Office Supplies',
    'Travel',
    'Accommodation',
    'Communication',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.claim != null) {
      selectedEmployee = widget.claim!['employeeName'];
      selectedCategory = widget.claim!['category'];
      _descriptionController.text = widget.claim!['description'] ?? '';
      _amountController.text = widget.claim!['amount']?.replaceAll('₱', '').replaceAll(',', '') ?? '';
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Edit Expense Claim",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4A5568),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Update expense claim details",
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      iconSize: 18,
                      icon: Icon(LucideIcons.x, color: Colors.grey.shade600),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // EMPLOYEE DROPDOWN
              Text(
                "Employee",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                value: selectedEmployee,
                hint: "Select Employee",
                items: employees,
                onChanged: (val) => setState(() => selectedEmployee = val),
              ),
              const SizedBox(height: 16),

              // CATEGORY DROPDOWN
              Text(
                "Category",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                value: selectedCategory,
                hint: "Select Category",
                items: categories,
                onChanged: (val) => setState(() => selectedCategory = val),
              ),
              const SizedBox(height: 16),

              // DESCRIPTION FIELD
              Text(
                "Description",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              AppTextInput(
                controller: _descriptionController,
                maxLines: 4,
                hintText: 'Enter description',
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
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
              const SizedBox(height: 16),

              // AMOUNT FIELD
              Text(
                "Amount",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        '₱',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.inter(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: GoogleFonts.inter(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2181FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Save Changes",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: GoogleFonts.inter(
              color: Colors.grey.shade400,
              fontSize: 13,
            ),
          ),
          isExpanded: true,
          icon: Icon(LucideIcons.chevronDown, color: Colors.grey.shade500),
          style: GoogleFonts.inter(
            color: Colors.grey.shade700,
            fontSize: 13,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
