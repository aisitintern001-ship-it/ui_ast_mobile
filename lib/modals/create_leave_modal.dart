import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

class CreateLeaveModal extends StatefulWidget {
  const CreateLeaveModal({super.key});

  @override
  State<CreateLeaveModal> createState() => _CreateLeaveModalState();
}

class _CreateLeaveModalState extends State<CreateLeaveModal> {
  int _selectedLeaveType = 0;
  String? _selectedDropdown;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
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
              // Header
              _buildHeader(),
              const SizedBox(height: 20),

              // My Available Leave
              Text(
                'My Available Leave',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4A5568),
                ),
              ),
              const SizedBox(height: 10),
              _buildLeaveTypeChips(),
              const SizedBox(height: 20),

              // Leave type dropdown
              _buildLeaveDropdown(),
              const SizedBox(height: 16),

              // Date selector
              _buildDateSelector(),
              const SizedBox(height: 16),

              // Reason
              _buildReasonField(),
              const SizedBox(height: 16),

              // Upload area
              _buildUploadArea(),

              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2181FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Leave From',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4A5568),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sub-description will be here',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          iconSize: 24,
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildLeaveTypeChips() {
    final leaveTypes = [
      {'label': 'Leave Without Pay', 'balance': ''},
      {'label': 'Service Incentive Leave', 'balance': '0.0000/hr'},
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: leaveTypes.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = _selectedLeaveType == index;
        return GestureDetector(
            onTap: () => setState(() => _selectedLeaveType = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? const Color(0xFFEF4444) : Colors.grey.shade300,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['label']!,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFF4A5568) : Colors.grey.shade500,
                    ),
                  ),
                  if (item['balance']!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item['balance']!,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        );
      }).toList(),
    );
  }

  Widget _buildLeaveDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedDropdown,
          isExpanded: true,
          hint: Text(
            'Select Leave Type',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade500),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF4A5568)),
          items: ['Service Incentive Leave', 'Leave Without Pay']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selectedDropdown = v);
          },
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              'Select Dates (tap to select multiple dates)',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonField() {
    return TextFormField(
      controller: _reasonController,
      maxLines: 4,
      style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF4A5568)),
      decoration: InputDecoration(
        hintText: 'Enter a Reason',
        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 13),
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

  Widget _buildUploadArea() {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: Colors.grey.shade300,
        strokeWidth: 1.5,
        dashPattern: const [6, 4],
        radius: const Radius.circular(8),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(Icons.file_upload_outlined, size: 28, color: Colors.grey.shade600),
            const SizedBox(height: 8),
            Text(
              'Click or drag files to upload',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  side: const BorderSide(color: Colors.black87),
                ),
                child: Text(
                  'Select Files',
                  style: GoogleFonts.inter(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
