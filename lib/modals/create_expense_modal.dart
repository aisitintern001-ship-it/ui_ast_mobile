import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/text_input.dart';

class CreateExpenseModal extends StatefulWidget {
  final bool isEdit; // Passed in to change Title and Button text

  const CreateExpenseModal({super.key, required this.isEdit});

  @override
  State<CreateExpenseModal> createState() => _CreateExpenseModalState();
}

class _CreateExpenseModalState extends State<CreateExpenseModal> {
  int expenseType = 0; // 0 = General, 1 = Trip
  bool includingTaxOverall = false;
  bool includingTaxItem = false;

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
                          widget.isEdit
                              ? "Edit Expense Claim"
                              : "Create Expense Claim",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4A5568),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Sub-description will be here",
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
                      icon: Icon(Icons.close, color: Colors.grey.shade600),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // EXPENSE TYPE RADIOS
              Text(
                "Select Expense Type",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildRadio(0, "General"),
                  const SizedBox(width: 24),
                  _buildRadio(1, "Trip"),
                ],
              ),
              const SizedBox(height: 16),

              // DESCRIPTION FIELD
              AppTextInput(
                maxLines: 4,
                initialValue: widget.isEdit
                    ? "Taxi fare for client meeting at Makati office. Round trip from home office to client site for quarterly business review presentation."
                    : "",
                hintText: 'Description',
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
                  borderSide: const BorderSide(color: Color(0xFFEF532A)),
                ),
              ),
              const SizedBox(height: 20),

              // THE DYNAMIC ITEM BOX
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Item 1",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Scan Receipt Button
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2181FF),
                        side: const BorderSide(color: Color(0xFF2181FF)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.document_scanner_outlined,
                        size: 16,
                      ),
                      label: Text(
                        "Scan Receipt",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Item Form Fields
                    _buildTextField(
                      "Date Expense Incurred",
                      icon: Icons.calendar_today,
                      value: widget.isEdit ? "Dec 20, 2025" : null,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      "Establishment Spent At",
                      value: widget.isEdit ? "Subic Bay Venezia Hotel" : null,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      "TIN/ABN",
                      value: widget.isEdit ? "0000 0000 0000" : null,
                    ),
                    const SizedBox(height: 12),
                    _buildDropdownField("PHP - Philippine Peso"),
                    const SizedBox(height: 12),
                    _buildTextField(
                      "Purchase Amount",
                      value: widget.isEdit ? "1,500.00" : null,
                    ),
                    const SizedBox(height: 16),

                    // Item Tax Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Including Tax",
                            style: GoogleFonts.inter(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Switch(
                          value: widget.isEdit ? true : includingTaxItem,
                          onChanged: (val) =>
                              setState(() => includingTaxItem = val),
                          activeThumbColor: Colors.white,
                          activeTrackColor: const Color(0xFF2181FF),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ADD ITEM BUTTON
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ), // Use dashed package if desired
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(
                    "Add Item",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // BOTTOM TOGGLES & DROPDOWN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Including Tax",
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Switch(
                    value: includingTaxOverall,
                    onChanged: (val) =>
                        setState(() => includingTaxOverall = val),
                    activeThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFF2181FF),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDropdownField("Cash on Hand - Not Banked"),
              const SizedBox(height: 32),

              // SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 48,
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
                    widget.isEdit ? "Save Changes" : "Submit",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- REUSABLE FORM COMPONENTS ---

  Widget _buildRadio(int value, String label) {
    bool isSelected = expenseType == value;
    return GestureDetector(
      onTap: () => setState(() => expenseType = value),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: isSelected ? const Color(0xFFEF532A) : Colors.grey.shade400,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.black87 : Colors.grey.shade500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, {IconData? icon, String? value}) {
    return AppTextInput(
      initialValue: value,
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 12),
      prefixIcon: icon != null
          ? Icon(icon, color: Colors.grey.shade500, size: 16)
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hint,
              style: GoogleFonts.inter(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey.shade500,
            size: 18,
          ),
        ],
      ),
    );
  }
}
