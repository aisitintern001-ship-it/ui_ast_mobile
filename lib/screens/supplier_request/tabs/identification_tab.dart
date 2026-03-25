import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/app_form_fields.dart';
import '../../../theme/app_theme.dart';
import '../../../data/currency_data.dart';

class SupplierIdentificationTab extends StatefulWidget {
  const SupplierIdentificationTab({super.key});

  @override
  State<SupplierIdentificationTab> createState() =>
      SupplierIdentificationTabState();
}

class SupplierIdentificationTabState extends State<SupplierIdentificationTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ================= STATE =================
  String supplierType = "Business";
  String? businessAccountType;
  String? _selectedParentAccount;
  bool isActive = true;
  DateTime selectedDate = DateTime.now();

  String? _selectedCurrency;
  String? _selectedSupplierGroup;
  String? _selectedLegalIdType;
  List<String> _selectedTags = [];

  // ================= CONTROLLERS =================
  final businessNameController = TextEditingController();
  final shortNameController = TextEditingController();
  final storeNumberController = TextEditingController();
  final vendorNumberController = TextEditingController();
  final webLinkController = TextEditingController();
  final legalIdNumberController = TextEditingController();

  // ================= DATA LISTS =================
  static const List<String> _supplierGroups = [
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

  // ================= VALIDATION =================
  List<String> validate() {
    final missing = <String>[];

    if (supplierType.isEmpty) {
      missing.add("Supplier Type");
    }

    if (supplierType == "Business" &&
        (businessAccountType == null || businessAccountType!.isEmpty)) {
      missing.add("Business Account Type");
    }

    if (supplierType == "Business" &&
        businessAccountType == "Child" &&
        (_selectedParentAccount == null || _selectedParentAccount!.isEmpty)) {
      missing.add("Parent Account");
    }

    if (supplierType == "Business" &&
        businessNameController.text.trim().isEmpty) {
      missing.add("Business Name");
    }

    if (shortNameController.text.trim().isEmpty) {
      missing.add("Short Name");
    }

    return missing;
  }

  // ================= DATA =================
  Map<String, dynamic> getData() {
    return {
      "supplierType": supplierType,
      "businessAccountType": businessAccountType,
      "parentAccount": _selectedParentAccount,
      "businessName": businessNameController.text,
      "shortName": shortNameController.text,
      "webLink": webLinkController.text,
      "currency": _selectedCurrency,
      "storeNumber": storeNumberController.text,
      "vendorNumber": vendorNumberController.text,
      "supplierGroup": _selectedSupplierGroup,
      "tags": _selectedTags,
      "legalIdType": _selectedLegalIdType,
      "legalIdNumber": legalIdNumberController.text,
      "isActive": isActive ? 1 : 0,
      "dateOpened":
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
    };
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= TITLE =================
          Text(
            "Identification Tab",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // ================= DESCRIPTION =================
          Text(
            "This section collects essential details about the supplier, including business or individual classification, account type, and company information for accurate records.",
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // ================= SUPPLIER TYPE =================
          Text(
            "Supplier Type *",
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          AppRadioRow<String>(
            groupValue: supplierType,
            values: const ["Business", "Individual"],
            titles: const ["Business", "Individual"],
            onChanged: (val) {
              setState(() {
                supplierType = val!;
                businessAccountType = null;
              });
            },
          ),

          // ================= DATE ACCOUNT OPENED =================
          AppDateField(
            label: "Date Account Opened",
            date: selectedDate,
            onChanged: (picked) {
              setState(() => selectedDate = picked);
            },
          ),

          const SizedBox(height: 16),

          // ================= ACCOUNT STATUS =================
          AppSwitchTile(
            label: "Account Status",
            value: isActive,
            onChanged: (val) {
              setState(() => isActive = val);
            },
          ),

          // ================= WEB LINK =================
          AppTextField(
            label: "Web Link",
            controller: webLinkController,
          ),

          // ================= BUSINESS ACCOUNT TYPE =================
          if (supplierType == "Business") ...[
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
              groupValue: businessAccountType,
              values: const ["Parent", "Child"],
              titles: const ["Parent Account", "Child Account"],
              onChanged: (val) {
                setState(() {
                  businessAccountType = val;
                  if (val != "Child") {
                    _selectedParentAccount = null;
                  }
                });
              },
            ),

            // ================= CHOOSE PARENT ACCOUNT =================
            if (businessAccountType == "Child")
              AppBottomSheetPicker(
                label: "Choose Parent Account",
                value: _selectedParentAccount,
                items: _parentAccounts,
                isRequired: true,
                onChanged: (v) => setState(() => _selectedParentAccount = v),
              ),
          ],

          // ================= BUSINESS NAME =================
          if (supplierType == "Business")
            AppTextField(
              label: "Business Name",
              controller: businessNameController,
              isRequired: true,
            ),

          // ================= SHORT NAME =================
          AppTextField(
            label: "Short Name",
            controller: shortNameController,
            isRequired: true,
          ),

          // ================= CURRENCY =================
          AppBottomSheetPicker(
            label: "Currency",
            value: _selectedCurrency,
            items: CurrencyData.currencies,
            onChanged: (v) => setState(() => _selectedCurrency = v),
          ),

          // ================= STORE NUMBER =================
          AppTextField(
            label: "Store Number",
            controller: storeNumberController,
          ),

          // ================= VENDOR NUMBER =================
          AppTextField(
            label: "Vendor Number",
            controller: vendorNumberController,
          ),

          // ================= SUPPLIER GROUP =================
          AppBottomSheetPicker(
            label: "Supplier Group",
            value: _selectedSupplierGroup,
            items: _supplierGroups,
            onChanged: (v) => setState(() => _selectedSupplierGroup = v),
          ),

          // ================= TAGS =================
          AppMultiSelectPicker(
            label: "Tags",
            selectedValues: _selectedTags,
            items: _tags,
            onChanged: (v) => setState(() => _selectedTags = v),
          ),

          // ================= LEGAL IDENTIFICATION TYPE =================
          AppBottomSheetPicker(
            label: "Legal Identification Type",
            value: _selectedLegalIdType,
            items: _legalIdTypes,
            onChanged: (v) => setState(() => _selectedLegalIdType = v),
          ),

          // ================= LEGAL IDENTIFICATION NUMBER =================
          AppTextField(
            label: "Legal Identification Number",
            controller: legalIdNumberController,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= DISPOSE =================
  @override
  void dispose() {
    businessNameController.dispose();
    shortNameController.dispose();
    storeNumberController.dispose();
    vendorNumberController.dispose();
    webLinkController.dispose();
    legalIdNumberController.dispose();
    super.dispose();
  }
}
