import 'package:flutter/material.dart';
import '../../../widgets/request_form_widgets.dart';
import '../../../widgets/text_input.dart';
import '../../../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerRequirementsTab extends StatefulWidget {
  const CustomerRequirementsTab({super.key});

  @override
  State<CustomerRequirementsTab> createState() => CustomerRequirementsTabState();
}

class CustomerRequirementsTabState extends State<CustomerRequirementsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<TextEditingController> _preAttendanceChecklist = [
    TextEditingController(),
  ];
  final List<TextEditingController> _onSiteChecklist = [
    TextEditingController(),
  ];

  List<String> validate() {
    return <String>[];
  }

  Map<String, dynamic> getData() {
    return {
      "preAttendanceChecklist": _preAttendanceChecklist.map((c) => c.text).toList(),
      "onSiteChecklist": _onSiteChecklist.map((c) => c.text).toList(),
    };
  }

  Widget _buildChecklistInput(
    TextEditingController controller, {
    required String hint,
    required VoidCallback onDelete,
  }) {
    return Row(
      children: [
        Expanded(
          child: AppTextInput(
            controller: controller,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
            hintText: hint,
            hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onDelete,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.dangerRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.delete_outline, size: 18, color: AppColors.dangerRed),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormTabTitle("Customer Requirements"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Customer Requirements captures checklist items for pre-attendance and on-site processes.",
          ),
          const SizedBox(height: 20),
          const FormSectionLabel("Pre Attendance Checklist"),
          const SizedBox(height: 12),
          ..._preAttendanceChecklist.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildChecklistInput(
                entry.value,
                hint: "Enter Pre-Attendance Checklist",
                onDelete: () {
                  if (_preAttendanceChecklist.length > 1) {
                    setState(() {
                      _preAttendanceChecklist[entry.key].dispose();
                      _preAttendanceChecklist.removeAt(entry.key);
                    });
                  }
                },
              ),
            );
          }),
          FormAddButton(
            label: "Add",
            onPressed: () => setState(() => _preAttendanceChecklist.add(TextEditingController())),
          ),
          const SizedBox(height: 24),
          const FormSectionLabel("On Site Checklist"),
          const SizedBox(height: 12),
          ..._onSiteChecklist.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildChecklistInput(
                entry.value,
                hint: "Enter On Site Checklist",
                onDelete: () {
                  if (_onSiteChecklist.length > 1) {
                    setState(() {
                      _onSiteChecklist[entry.key].dispose();
                      _onSiteChecklist.removeAt(entry.key);
                    });
                  }
                },
              ),
            );
          }),
          FormAddButton(
            label: "Add",
            onPressed: () => setState(() => _onSiteChecklist.add(TextEditingController())),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _preAttendanceChecklist) {
      c.dispose();
    }
    for (final c in _onSiteChecklist) {
      c.dispose();
    }
    super.dispose();
  }
}
