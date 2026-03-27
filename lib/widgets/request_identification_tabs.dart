import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'app_form_fields.dart';
import '../data/currency_data.dart';

/// Unified Identification Tab for both Customer and Supplier requests
class RequestIdentificationTab extends StatefulWidget {
  final String entityType; // "customer" or "supplier"

  const RequestIdentificationTab({
    super.key,
    required this.entityType,
  });

  @override
  State<RequestIdentificationTab> createState() => RequestIdentificationTabState();
}

class RequestIdentificationTabState extends State<RequestIdentificationTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _entityAccountType = "Business";
  String? _businessAccountType;
  String? _selectedParentAccount;
  bool _isActive = true;
  DateTime _selectedDate = DateTime.now();

  String? _selectedCurrency;
  String? _selectedGroup;
  String? _selectedLegalIdType;
  List<String> _selectedTags = [];

  final _businessNameController = TextEditingController();
  final _shortNameController = TextEditingController();
  final _storeNumberController = TextEditingController();
  final _vendorNumberController = TextEditingController();
  final _webLinkController = TextEditingController();
  final _legalIdNumberController = TextEditingController();

  String get _entityLabel =>
      widget.entityType == "customer" ? "Customer" : "Supplier";

  String get _groupLabel =>
      widget.entityType == "customer" ? "Customer Type" : "Supplier Group";

  List<String> get _groups => widget.entityType == "customer"
      ? const ['Business', 'Individual', 'Government']
      : const [
          'Equipment Hire',
          'Equipment & Components',
          'Employee',
          'Electrical & Electronics',
          'Customer',
          'Consultant',
          'Finance',
          'General Hardware & Consumables',
          'Construction Supplies',
          'Communication & Utilities',
          'Auto Supplies',
          'Fasteners',
          'Fuel & Lubricants',
          'Government Agency',
          'Insurance',
          'Logistics',
          'Maintenance',
          'Others',
        ];

  static const List<String> _tags = [
    'Local Supplier',
    'ISO Certified',
    'Government Supplier',
    'Strategic Partner',
    'Green Supplier',
    'High Risk',
    'New Supplier',
    'Sample 01',
    'Sample 02',
  ];

  static const List<String> _legalIdTypes = [
    'Tax Identification Number (TIN)',
    'Business Registration Number',
    'VAT Registration Number',
    'Company Registration Number',
    'Social Security Number',
    'National ID',
    'Passport Number',
    'Other',
  ];

  static const List<String> _parentAccounts = [
    'ABC Corporation',
    'XYZ Holdings Inc.',
    'Global Trade Partners',
    'Premier Suppliers Ltd.',
    'United Distributors',
  ];

  List<String> validate() {
    final missing = <String>[];

    if (_entityAccountType.isEmpty) {
      missing.add("$_entityLabel Type");
    }

    if (_entityAccountType == "Business" &&
        (_businessAccountType == null || _businessAccountType!.isEmpty)) {
      missing.add("Business Account Type");
    }

    if (_entityAccountType == "Business" &&
        _businessAccountType == "Child" &&
        (_selectedParentAccount == null || _selectedParentAccount!.isEmpty)) {
      missing.add("Parent Account");
    }

    if (_entityAccountType == "Business" &&
        _businessNameController.text.trim().isEmpty) {
      missing.add("Business Name");
    }

    if (_shortNameController.text.trim().isEmpty) {
      missing.add("Short Name");
    }

    return missing;
  }

  Map<String, dynamic> getData() {
    return {
      "${widget.entityType}Type": _entityAccountType,
      "businessAccountType": _businessAccountType,
      "parentAccount": _selectedParentAccount,
      "businessName": _businessNameController.text,
      "shortName": _shortNameController.text,
      "webLink": _webLinkController.text,
      "currency": _selectedCurrency,
      "storeNumber": _storeNumberController.text,
      "vendorNumber": _vendorNumberController.text,
      "${widget.entityType}Group": _selectedGroup,
      "tags": _selectedTags,
      "legalIdType": _selectedLegalIdType,
      "legalIdNumber": _legalIdNumberController.text,
      "isActive": _isActive ? 1 : 0,
      "dateOpened":
          "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Identification Tab",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "This section collects essential details about the ${widget.entityType}, including business or individual classification, account type, and company information for accurate records.",
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "$_entityLabel Type *",
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          AppRadioRow<String>(
            groupValue: _entityAccountType,
            values: const ["Business", "Individual"],
            titles: const ["Business", "Individual"],
            onChanged: (val) {
              setState(() {
                _entityAccountType = val!;
                _businessAccountType = null;
              });
            },
          ),
          _buildDateField(),
          const SizedBox(height: 16),
          AppSwitchTile(
            label: "Account Status",
            value: _isActive,
            onChanged: (val) {
              setState(() => _isActive = val);
            },
          ),
          AppTextField(
            label: "Web Link",
            controller: _webLinkController,
          ),
          if (_entityAccountType == "Business") ...[
            const SizedBox(height: 16),
            Text(
              "Business Account Type *",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            AppRadioRow<String>(
              groupValue: _businessAccountType,
              values: const ["Parent", "Child"],
              titles: const ["Parent Account", "Child Account"],
              onChanged: (val) {
                setState(() {
                  _businessAccountType = val;
                  if (val != "Child") {
                    _selectedParentAccount = null;
                  }
                });
              },
            ),
            if (_businessAccountType == "Child")
              AppBottomSheetPicker(
                label: "Choose Parent Account",
                value: _selectedParentAccount,
                items: _parentAccounts,
                isRequired: true,
                onChanged: (v) => setState(() => _selectedParentAccount = v),
              ),
          ],
          if (_entityAccountType == "Business")
            AppTextField(
              label: "Business Name",
              controller: _businessNameController,
              isRequired: true,
            ),
          AppTextField(
            label: "Short Name",
            controller: _shortNameController,
            isRequired: true,
          ),
          AppBottomSheetPicker(
            label: "Currency",
            value: _selectedCurrency,
            items: CurrencyData.currencies,
            onChanged: (v) => setState(() => _selectedCurrency = v),
          ),
          AppTextField(
            label: "Store Number",
            controller: _storeNumberController,
          ),
          AppTextField(
            label: "Vendor Number",
            controller: _vendorNumberController,
          ),
          AppBottomSheetPicker(
            label: _groupLabel,
            value: _selectedGroup,
            items: _groups,
            onChanged: (v) => setState(() => _selectedGroup = v),
          ),
          AppMultiSelectPicker(
            label: "Tags",
            selectedValues: _selectedTags,
            items: _tags,
            onChanged: (v) => setState(() => _selectedTags = v),
          ),
          AppBottomSheetPicker(
            label: "Legal Identification Type",
            value: _selectedLegalIdType,
            items: _legalIdTypes,
            onChanged: (v) => setState(() => _selectedLegalIdType = v),
          ),
          AppTextField(
            label: "Legal Identification Number",
            controller: _legalIdNumberController,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          "Date Account Opened",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              setState(() => _selectedDate = picked);
            }
          },
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: Colors.grey.shade500),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _formatDate(_selectedDate),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    String daySuffix(int day) {
      if (day >= 11 && day <= 13) return 'th';
      switch (day % 10) {
        case 1: return 'st';
        case 2: return 'nd';
        case 3: return 'rd';
        default: return 'th';
      }
    }
    return "${months[d.month - 1]} ${d.day}${daySuffix(d.day)}, ${d.year}";
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _shortNameController.dispose();
    _storeNumberController.dispose();
    _vendorNumberController.dispose();
    _webLinkController.dispose();
    _legalIdNumberController.dispose();
    super.dispose();
  }
}
