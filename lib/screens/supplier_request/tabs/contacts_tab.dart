import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/request_form_widgets.dart';

/// Contact data model
class ContactData {
  String? contactType;
  bool setAsPrimary;
  final TextEditingController firstNameController;
  final TextEditingController middleNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController jobTitleController;
  bool hasPhone;
  String? phoneCountry;
  final TextEditingController areaCodeController;
  final TextEditingController phoneNumberController;
  bool hasMobile;
  String? mobileCountryCode;
  final TextEditingController mobileNumberController;
  bool includedInEmailCorrespondence;
  bool addComment;
  final TextEditingController commentController;

  ContactData()
      : contactType = null,
        setAsPrimary = false,
        firstNameController = TextEditingController(),
        middleNameController = TextEditingController(),
        lastNameController = TextEditingController(),
        emailController = TextEditingController(),
        jobTitleController = TextEditingController(),
        hasPhone = false,
        phoneCountry = null,
        areaCodeController = TextEditingController(),
        phoneNumberController = TextEditingController(),
        hasMobile = false,
        mobileCountryCode = null,
        mobileNumberController = TextEditingController(),
        includedInEmailCorrespondence = false,
        addComment = false,
        commentController = TextEditingController();

  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    jobTitleController.dispose();
    areaCodeController.dispose();
    phoneNumberController.dispose();
    mobileNumberController.dispose();
    commentController.dispose();
  }

  Map<String, dynamic> toMap() {
    return {
      'contactType': contactType,
      'setAsPrimary': setAsPrimary ? 1 : 0,
      'firstName': firstNameController.text,
      'middleName': middleNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'jobTitle': jobTitleController.text,
      'hasPhone': hasPhone ? 1 : 0,
      'phoneCountry': phoneCountry,
      'areaCode': areaCodeController.text,
      'phoneNumber': phoneNumberController.text,
      'hasMobile': hasMobile ? 1 : 0,
      'mobileCountryCode': mobileCountryCode,
      'mobileNumber': mobileNumberController.text,
      'includedInEmailCorrespondence': includedInEmailCorrespondence ? 1 : 0,
      'comment': addComment ? commentController.text : null,
    };
  }
}

class SupplierContactsTab extends StatefulWidget {
  const SupplierContactsTab({super.key});

  @override
  State<SupplierContactsTab> createState() => SupplierContactsTabState();
}

class SupplierContactsTabState extends State<SupplierContactsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ================= STATE =================
  final List<ContactData> _contacts = [];

  // ================= VALIDATION =================
  List<String> validate() {
    final missing = <String>[];
    // Add validation rules as needed
    return missing;
  }

  // ================= DATA =================
  Map<String, dynamic> getData() {
    return {
      "contacts": _contacts.map((c) => c.toMap()).toList(),
    };
  }

  // ================= ACTIONS =================
  void _addContact() {
    setState(() {
      _contacts.add(ContactData());
    });
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts[index].dispose();
      _contacts.removeAt(index);
    });
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormTabTitle("Contacts Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Contacts Tab records the supplier's contact details and information, which helps identify and communicate with the supplier within the system.",
          ),
          const SizedBox(height: 20),

          // Show Add Contact at top only when no contacts exist
          if (_contacts.isEmpty)
            FormAddButton(
              label: "Add Contact",
              onPressed: _addContact,
            ),

          if (_contacts.isNotEmpty) ...[
            ..._contacts.asMap().entries.map((entry) {
              return _buildContactCard(entry.key, entry.value);
            }),
            // Show Add Contact at bottom when contacts exist
            FormAddButton(
              label: "Add Contact",
              onPressed: _addContact,
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildContactCard(int index, ContactData contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  "Contact ${index + 1}",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _deleteContact(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= FORM FIELDS =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= SELECT TYPE =================
                _buildDropdownField(
                  hint: "Select Type",
                  value: contact.contactType,
                  items: const [], // No options as per requirements
                  onChanged: (v) => setState(() => contact.contactType = v),
                ),
                const SizedBox(height: 12),

                // ================= SET AS PRIMARY =================
                _buildCheckboxRow(
                  label: "Set As Primary",
                  value: contact.setAsPrimary,
                  onChanged: (v) => setState(() => contact.setAsPrimary = v ?? false),
                ),
                const SizedBox(height: 16),

                // ================= NAME FIELDS =================
                _buildTextField(
                  controller: contact.firstNameController,
                  hint: "First Name",
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: contact.middleNameController,
                  hint: "Middle Name",
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: contact.lastNameController,
                  hint: "Last Name",
                ),
                const SizedBox(height: 12),

                // ================= EMAIL =================
                _buildTextField(
                  controller: contact.emailController,
                  hint: "Email Address",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),

                // ================= JOB TITLE =================
                _buildTextField(
                  controller: contact.jobTitleController,
                  hint: "Job Title",
                ),
                const SizedBox(height: 16),

                // ================= HAS PHONE =================
                _buildSwitchRow(
                  label: "Has Phone",
                  value: contact.hasPhone,
                  onChanged: (v) => setState(() => contact.hasPhone = v),
                ),

                if (contact.hasPhone) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildDropdownField(
                          hint: "Country",
                          value: contact.phoneCountry,
                          items: const [],
                          onChanged: (v) => setState(() => contact.phoneCountry = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: _buildTextField(
                          controller: contact.areaCodeController,
                          hint: "Area Code",
                          keyboardType: TextInputType.phone,
                          hintFontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          controller: contact.phoneNumberController,
                          hint: "Phone Number",
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),

                // ================= HAS MOBILE =================
                _buildSwitchRow(
                  label: "Has Mobile",
                  value: contact.hasMobile,
                  onChanged: (v) => setState(() => contact.hasMobile = v),
                ),

                if (contact.hasMobile) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          hint: "Country Code",
                          value: contact.mobileCountryCode,
                          items: const [],
                          onChanged: (v) => setState(() => contact.mobileCountryCode = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          controller: contact.mobileNumberController,
                          hint: "Mobile Number",
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),

                // ================= INCLUDED IN EMAIL CORRESPONDENCE =================
                _buildCheckboxRow(
                  label: "Included in email correspondence",
                  value: contact.includedInEmailCorrespondence,
                  onChanged: (v) => setState(() => contact.includedInEmailCorrespondence = v ?? false),
                ),
                const SizedBox(height: 12),

                // ================= ADD COMMENT =================
                _buildCheckboxRow(
                  label: "Add comment",
                  value: contact.addComment,
                  onChanged: (v) => setState(() => contact.addComment = v ?? false),
                ),

                if (contact.addComment) ...[
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: contact.commentController,
                    hint: "Comment",
                    maxLines: 3,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= FORM FIELD WIDGETS =================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    double hintFontSize = 12,
  }) {
    return SizedBox(
      height: maxLines > 1 ? null : 44,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            fontSize: hintFontSize,
            color: AppColors.textMuted,
          ),
          hintMaxLines: 1,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          isDense: true,
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
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              hint,
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
              maxLines: 1,
            ),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500, size: 20),
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textPrimary),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xFF2181FF),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFE0E0E0),
          trackOutlineColor: WidgetStateProperty.resolveWith((states) {
            return Colors.transparent;
          }),
        ),
      ],
    );
  }

  Widget _buildCheckboxRow({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: value ? const Color(0xFF2181FF) : Colors.grey.shade400,
                width: 2,
              ),
              color: value ? const Color(0xFF2181FF) : Colors.transparent,
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ================= DISPOSE =================
  @override
  void dispose() {
    for (var contact in _contacts) {
      contact.dispose();
    }
    super.dispose();
  }
}
