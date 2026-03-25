import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/request_form_widgets.dart';

class CustomerIdentificationTab extends StatefulWidget {
  const CustomerIdentificationTab({super.key});

  @override
  State<CustomerIdentificationTab> createState() =>
      CustomerIdentificationTabState();
}

class CustomerIdentificationTabState extends State<CustomerIdentificationTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _accountType = 0;
  DateTime _dateAccountOpened = DateTime(2026, 1, 27);
  bool _accountActive = true;
  int _businessAccountType = 0;

  final _businessNameController = TextEditingController();
  final _shortNameController = TextEditingController();
  final _storeNumberController = TextEditingController();
  final _vendorNumberController = TextEditingController();

  String? _selectedCurrency;
  String? _selectedIndustry;
  String? _selectedCustomerType;
  String? _selectedSalesRep;

  List<String> validate() {
    final missing = <String>[];
    if (_accountType == 0 && _businessNameController.text.trim().isEmpty) {
      missing.add("Business Name");
    }
    if (_shortNameController.text.trim().isEmpty) {
      missing.add("Short Name");
    }
    return missing;
  }

  Map<String, dynamic> getData() {
    return {
      "accountType": _accountType == 0 ? "Business" : "Individual",
      "dateAccountOpened":
          "${_dateAccountOpened.year}-${_dateAccountOpened.month.toString().padLeft(2, '0')}-${_dateAccountOpened.day.toString().padLeft(2, '0')}",
      "accountActive": _accountActive ? 1 : 0,
      "businessAccountType": _businessAccountType == 0 ? "Parent" : "Child",
      "businessName": _businessNameController.text,
      "shortName": _shortNameController.text,
      "storeNumber": _storeNumberController.text,
      "vendorNumber": _vendorNumberController.text,
      "currency": _selectedCurrency,
      "industry": _selectedIndustry,
      "customerType": _selectedCustomerType,
      "salesRep": _selectedSalesRep,
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormTabTitle("Identification Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Identification Tab records the customer's basic details and information about the industry or sector in which they operate.",
          ),
          const SizedBox(height: 20),
          const FormSectionLabel("Customer Account Type"),
          const SizedBox(height: 8),
          Row(
            children: [
              FormRadioOption(
                label: "Business",
                value: 0,
                groupValue: _accountType,
                onChanged: (v) => setState(() => _accountType = v),
              ),
              const SizedBox(width: 24),
              FormRadioOption(
                label: "Individual",
                value: 1,
                groupValue: _accountType,
                onChanged: (v) => setState(() => _accountType = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FormDateField(
            date: _dateAccountOpened,
            onChanged: (picked) => setState(() => _dateAccountOpened = picked),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Account Status",
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
              ),
              Switch(
                value: _accountActive,
                onChanged: (v) => setState(() => _accountActive = v),
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF2181FF),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFE0E0E0),
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const FormSectionLabel("Business Account Type"),
          const SizedBox(height: 8),
          Row(
            children: [
              FormRadioOption(
                label: "Parent Account",
                value: 0,
                groupValue: _businessAccountType,
                onChanged: (v) => setState(() => _businessAccountType = v),
              ),
              const SizedBox(width: 20),
              FormRadioOption(
                label: "Child Account",
                value: 1,
                groupValue: _businessAccountType,
                onChanged: (v) => setState(() => _businessAccountType = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FormTextField(controller: _businessNameController, hint: "Enter Business Name"),
          const SizedBox(height: 12),
          FormTextField(controller: _shortNameController, hint: "Enter Short Name"),
          const SizedBox(height: 12),
          FormTextField(controller: _storeNumberController, hint: "Store Number"),
          const SizedBox(height: 12),
          FormDropdownField(
            hint: "Choose Currency",
            value: _selectedCurrency,
            items: const ["Peso", "USD", "EUR", "GBP"],
            onChanged: (v) => setState(() => _selectedCurrency = v),
          ),
          const SizedBox(height: 12),
          FormTextField(controller: _vendorNumberController, hint: "Vendor Number"),
          const SizedBox(height: 12),
          FormDropdownField(
            hint: "Choose Industry",
            value: _selectedIndustry,
            items: const ["Agriculture", "Manufacturing", "Retail", "Technology"],
            onChanged: (v) => setState(() => _selectedIndustry = v),
          ),
          const SizedBox(height: 12),
          FormDropdownField(
            hint: "Customer Type",
            value: _selectedCustomerType,
            items: const ["Business", "Individual", "Government"],
            onChanged: (v) => setState(() => _selectedCustomerType = v),
          ),
          const SizedBox(height: 12),
          FormDropdownField(
            hint: "Choose Sales Representative",
            value: _selectedSalesRep,
            items: const ["Rep A", "Rep B", "Rep C"],
            onChanged: (v) => setState(() => _selectedSalesRep = v),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _shortNameController.dispose();
    _storeNumberController.dispose();
    _vendorNumberController.dispose();
    super.dispose();
  }
}
