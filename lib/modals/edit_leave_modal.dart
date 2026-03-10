import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

class EditLeaveModal extends StatefulWidget {
  const EditLeaveModal({super.key});

  @override
  State<EditLeaveModal> createState() => _EditLeaveModalState();
}

class _EditLeaveModalState extends State<EditLeaveModal> {
  int _selectedLeaveType = 0; // 0 = Leave Without Pay, 1 = Service Incentive Leave
  String _selectedDropdown = 'Service Incentive Leave';

  final List<_DateEntry> _dateEntries = [
    _DateEntry(date: '01-01-2026', startTime: '08:00 am', endTime: '05:00 pm'),
    _DateEntry(date: '01-06-2026', startTime: '08:00 am', endTime: '05:00 pm'),
  ];

  final List<_AttachedFile> _attachedFiles = [
    _AttachedFile(name: 'cert.pdf', type: 'PDF'),
  ];

  final _reasonController = TextEditingController(
    text: 'Personal emergency, need to attend to family matters that requires my immediate attention for the next  two days.',
  );

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

              // Date entries
              ..._dateEntries.asMap().entries.map((entry) =>
                _buildDateEntryCard(entry.key, entry.value),
              ),

              // Reason
              _buildReasonField(),
              const SizedBox(height: 16),

              // Upload area
              _buildUploadArea(),
              const SizedBox(height: 16),

              // Attached files
              ..._attachedFiles.map((file) => _buildAttachedFile(file)),

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
                'Edit Leave Form',
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

    return Row(
      children: leaveTypes.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = _selectedLeaveType == index;
        return Padding(
          padding: EdgeInsets.only(right: index < leaveTypes.length - 1 ? 10 : 0),
          child: GestureDetector(
            onTap: () => setState(() => _selectedLeaveType = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white,
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
          
          // 👇 Wrap the Text widget in an Expanded widget
          Expanded(
            child: Text(
              // If you are using a variable here (like in your previous code), just keep your variable.
              // I'm using the placeholder text from your screenshot as an example.
              'Select Dates (tap to select multiple dates)', 
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF4A5568)),
              overflow: TextOverflow.ellipsis, // Adds "..." if the text is too long for smaller screens
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildDateEntryCard(int index, _DateEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header with remove button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.date,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4A5568),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_dateEntries.length > 1) {
                    setState(() => _dateEntries.removeAt(index));
                  }
                },
                child: Icon(Icons.close, size: 18, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Start / End time
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Time',
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
                          const SizedBox(width: 8),
                          Text(
                            entry.startTime,
                            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF4A5568)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'End Time',
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
                          const SizedBox(width: 8),
                          Text(
                            entry.endTime,
                            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF4A5568)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  Widget _buildAttachedFile(_AttachedFile file) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.attach_file, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4A5568),
                  ),
                ),
                Text(
                  file.type,
                  style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() => _attachedFiles.remove(file));
            },
            child: Icon(Icons.close, size: 18, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _DateEntry {
  final String date;
  final String startTime;
  final String endTime;

  _DateEntry({required this.date, required this.startTime, required this.endTime});
}

class _AttachedFile {
  final String name;
  final String type;

  _AttachedFile({required this.name, required this.type});
}
