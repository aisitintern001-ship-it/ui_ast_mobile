import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/app_form_fields.dart';
import '../../../theme/app_theme.dart';
import '../../../data/currency_data.dart';
import '../../../data/finance_data.dart';

class SupplierFinanceTab extends StatefulWidget {
  const SupplierFinanceTab({super.key});

  @override
  State<SupplierFinanceTab> createState() => SupplierFinanceTabState();
}

class SupplierFinanceTabState extends State<SupplierFinanceTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ================= STATE =================
  String? _selectedCurrency;
  String? _selectedTradingTerms;
  String? _selectedTaxRule;
  String? _selectedAccountPayable;
  String? _selectedWhtRate;
  String? _selectedCostCentre;
  int _paymentOption = 0; // 0=Cash, 1=Bank, 2=GCash, 3=Money Remittance
  bool _acceptPartDeliveries = false;

  // Bank payment state
  String? _selectedBank;
  bool _sameAsBusinessName = false;

  // GCash payment state
  String? _gcashCountryCode;

  // Money Remittance state
  String? _remittanceCountryCode;

  // ================= CONTROLLERS =================
  final _creditLimitController = TextEditingController();
  final _taxIdNumberController = TextEditingController();

  // Bank payment controllers
  final _bankAccountNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _bankBranchController = TextEditingController();
  final _bankAddressController = TextEditingController();
  final _swiftCodeController = TextEditingController();
  final _routingNumberController = TextEditingController();

  // GCash payment controllers
  final _gcashFirstNameController = TextEditingController();
  final _gcashLastNameController = TextEditingController();
  final _gcashMobileController = TextEditingController();

  // Money Remittance payment controllers
  final _remittanceCenterController = TextEditingController();
  final _remittanceFirstNameController = TextEditingController();
  final _remittanceLastNameController = TextEditingController();
  final _remittanceMobileController = TextEditingController();

  // ================= VALIDATION =================
  List<String> validate() {
    final missing = <String>[];

    if (_selectedCurrency == null || _selectedCurrency!.isEmpty) {
      missing.add("Currency");
    }

    if (_selectedTradingTerms == null || _selectedTradingTerms!.isEmpty) {
      missing.add("Trading Terms");
    }

    if (_selectedTaxRule == null || _selectedTaxRule!.isEmpty) {
      missing.add("Tax Rule");
    }

    if (_paymentOption < 0) {
      missing.add("Payment Option");
    }

    return missing;
  }

  // ================= DATA =================
  Map<String, dynamic> getData() {
    final data = <String, dynamic>{
      "currency": _selectedCurrency,
      "currencyCode": CurrencyData.getCurrencyCode(_selectedCurrency),
      "tradingTerms": _selectedTradingTerms,
      "taxRule": _selectedTaxRule,
      "creditLimit": _creditLimitController.text,
      "accountPayable": _selectedAccountPayable,
      "taxIdNumber": _taxIdNumberController.text,
      "paymentOption": FinanceData.paymentOptions[_paymentOption],
      "whtRate": _selectedWhtRate,
      "costCentre": _selectedCostCentre,
      "acceptPartDeliveries": _acceptPartDeliveries ? 1 : 0,
    };

    // Add payment-specific data based on selected option
    switch (_paymentOption) {
      case 1: // Bank
        data["sameAsBusinessName"] = _sameAsBusinessName;
        data["bankName"] = _selectedBank;
        data["bankAccountName"] = _bankAccountNameController.text;
        data["bankBranch"] = _bankBranchController.text;
        data["bankAddress"] = _bankAddressController.text;
        data["bankAccountNumber"] = _bankAccountNumberController.text;
        data["swiftCode"] = _swiftCodeController.text;
        data["routingNumber"] = _routingNumberController.text;
        break;
      case 2: // GCash
        data["gcashFirstName"] = _gcashFirstNameController.text;
        data["gcashLastName"] = _gcashLastNameController.text;
        data["gcashCountryCode"] = _gcashCountryCode;
        data["gcashMobile"] = _gcashMobileController.text;
        break;
      case 3: // Money Remittance
        data["remittanceCenter"] = _remittanceCenterController.text;
        data["remittanceFirstName"] = _remittanceFirstNameController.text;
        data["remittanceLastName"] = _remittanceLastNameController.text;
        data["remittanceCountryCode"] = _remittanceCountryCode;
        data["remittanceMobile"] = _remittanceMobileController.text;
        break;
    }

    return data;
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
            "Finance Tab",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // ================= DESCRIPTION =================
          Text(
            "Finance Tab records the supplier's financial details and information, which helps manage payments and transactions within the system.",
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // ================= CURRENCY =================
          AppBottomSheetPicker(
            label: "Currency",
            value: _selectedCurrency,
            items: CurrencyData.currencies,
            isRequired: true,
            onChanged: (v) => setState(() => _selectedCurrency = v),
          ),

          // ================= TRADING TERMS =================
          AppDropdownField(
            label: "Trading Terms",
            value: _selectedTradingTerms,
            items: FinanceData.tradingTerms,
            isRequired: true,
            onChanged: (v) => setState(() => _selectedTradingTerms = v),
          ),

          // ================= TAX RULE =================
          AppDropdownField(
            label: "Tax Rule",
            value: _selectedTaxRule,
            items: FinanceData.taxRules,
            isRequired: true,
            onChanged: (v) => setState(() => _selectedTaxRule = v),
          ),

          // ================= CREDIT LIMIT =================
          AppTextField(
            label: "Credit Limit",
            controller: _creditLimitController,
            keyboardType: TextInputType.number,
          ),

          // ================= ACCOUNT PAYABLE =================
          AppDropdownField(
            label: "Account Payable",
            value: _selectedAccountPayable,
            items: FinanceData.accountPayables,
            onChanged: (v) => setState(() => _selectedAccountPayable = v),
          ),

          // ================= TAX ID NUMBER =================
          AppTextField(
            label: "Tax ID Number",
            controller: _taxIdNumberController,
          ),

          const SizedBox(height: 20),

          // ================= PAYMENT OPTION =================
          _buildSectionLabel("Payment Option", isRequired: true),
          const SizedBox(height: 12),
          _buildPaymentOptions(),

          // ================= DYNAMIC PAYMENT SECTION =================
          _buildPaymentSection(),

          const SizedBox(height: 20),

          // ================= WHT/EWT RATE =================
          AppDropdownField(
            label: "WHT/EWT Rate",
            value: _selectedWhtRate,
            items: FinanceData.whtRates,
            onChanged: (v) => setState(() => _selectedWhtRate = v),
          ),

          // ================= COST CENTRE =================
          AppDropdownField(
            label: "Cost Centre",
            value: _selectedCostCentre,
            items: FinanceData.costCentres,
            onChanged: (v) => setState(() => _selectedCostCentre = v),
          ),

          const SizedBox(height: 16),

          // ================= ACCEPT PART DELIVERIES =================
          AppSwitchTile(
            label: "Accept Part Deliveries",
            value: _acceptPartDeliveries,
            onChanged: (v) => setState(() => _acceptPartDeliveries = v),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= SECTION LABEL =================
  Widget _buildSectionLabel(String label, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        children: isRequired
            ? [
                TextSpan(
                  text: ' *',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2181FF),
                  ),
                ),
              ]
            : null,
      ),
    );
  }

  // ================= PAYMENT OPTIONS WIDGET =================
  Widget _buildPaymentOptions() {
    return Column(
      children: List.generate(FinanceData.paymentOptions.length, (index) {
        final isSelected = _paymentOption == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => setState(() => _paymentOption = index),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2181FF)
                          : Colors.grey.shade400,
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
                              color: Color(0xFF2181FF),
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    FinanceData.paymentOptions[index],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ================= DYNAMIC PAYMENT SECTION =================
  Widget _buildPaymentSection() {
    switch (_paymentOption) {
      case 1: // Bank
        return _buildBankSection();
      case 2: // GCash
        return _buildGCashSection();
      case 3: // Money Remittance
        return _buildRemittanceSection();
      default: // Cash - no additional fields
        return const SizedBox.shrink();
    }
  }

  // ================= BANK SECTION =================
  Widget _buildBankSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Same as Business/Supplier Name toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Same as Business/Supplier Name",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            Switch(
              value: _sameAsBusinessName,
              onChanged: (v) => setState(() => _sameAsBusinessName = v),
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFF2181FF),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFE0E0E0),
              trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                return Colors.transparent;
              }),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Bank Name dropdown
        _buildInlineDropdown(
          value: _selectedBank,
          hint: "Bank Name *",
          items: FinanceData.banks,
          onChanged: (v) => setState(() => _selectedBank = v),
        ),

        const SizedBox(height: 12),

        // Bank Account Name
        _buildInlineTextField(
          controller: _bankAccountNameController,
          hint: "Bank Account Name *",
        ),

        const SizedBox(height: 12),

        // Bank Branch/Branch Code
        _buildInlineTextField(
          controller: _bankBranchController,
          hint: "Bank Branch/Branch Code",
        ),

        const SizedBox(height: 12),

        // Bank Address
        _buildInlineTextField(
          controller: _bankAddressController,
          hint: "Bank Address",
        ),

        const SizedBox(height: 12),

        // Bank Account Number
        _buildInlineTextField(
          controller: _bankAccountNumberController,
          hint: "Bank Account Number *",
          keyboardType: TextInputType.number,
        ),

        const SizedBox(height: 12),

        // SWIFT/BIC Code
        _buildInlineTextField(
          controller: _swiftCodeController,
          hint: "SWIFT/BIC Code",
        ),

        const SizedBox(height: 12),

        // Routing Number/ABA Code
        _buildInlineTextField(
          controller: _routingNumberController,
          hint: "Routing Number/ABA Code",
        ),
      ],
    );
  }

  // ================= GCASH SECTION =================
  Widget _buildGCashSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // First Name
        _buildInlineTextField(
          controller: _gcashFirstNameController,
          hint: "First Name *",
        ),

        const SizedBox(height: 12),

        // Last Name
        _buildInlineTextField(
          controller: _gcashLastNameController,
          hint: "Last Name *",
        ),

        // Country Code + Mobile Number row
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Code dropdown
            SizedBox(
              width: 100,
              child: _buildCountryCodeDropdown(
                value: _gcashCountryCode,
                onChanged: (v) => setState(() => _gcashCountryCode = v),
              ),
            ),
            const SizedBox(width: 12),
            // Mobile Number
            Expanded(
              child: _buildInlineTextField(
                controller: _gcashMobileController,
                hint: "Mobile Number *",
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= MONEY REMITTANCE SECTION =================
  Widget _buildRemittanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Remittance Center (text field)
        _buildInlineTextField(
          controller: _remittanceCenterController,
          hint: "Remittance Center *",
        ),

        // First Name + Last Name row
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildInlineTextField(
                controller: _remittanceFirstNameController,
                hint: "First Name *",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInlineTextField(
                controller: _remittanceLastNameController,
                hint: "Last Name *",
              ),
            ),
          ],
        ),

        // Country Code + Mobile Number row
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Code dropdown
            SizedBox(
              width: 100,
              child: _buildCountryCodeDropdown(
                value: _remittanceCountryCode,
                onChanged: (v) => setState(() => _remittanceCountryCode = v),
              ),
            ),
            const SizedBox(width: 12),
            // Mobile Number
            Expanded(
              child: _buildInlineTextField(
                controller: _remittanceMobileController,
                hint: "Mobile Number *",
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= COUNTRY CODE DROPDOWN =================
  Widget _buildCountryCodeDropdown({
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            '+63',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted),
          ),
          icon: Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey.shade500),
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
          items: FinanceData.countryCodes
              .map((code) => DropdownMenuItem(
                    value: code,
                    child: Text(code),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ================= INLINE DROPDOWN =================
  Widget _buildInlineDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ================= INLINE TEXT FIELD =================
  Widget _buildInlineTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: 48,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  // ================= DISPOSE =================
  @override
  void dispose() {
    _creditLimitController.dispose();
    _taxIdNumberController.dispose();
    _bankAccountNameController.dispose();
    _bankAccountNumberController.dispose();
    _bankBranchController.dispose();
    _bankAddressController.dispose();
    _swiftCodeController.dispose();
    _routingNumberController.dispose();
    _gcashFirstNameController.dispose();
    _gcashLastNameController.dispose();
    _gcashMobileController.dispose();
    _remittanceCenterController.dispose();
    _remittanceFirstNameController.dispose();
    _remittanceLastNameController.dispose();
    _remittanceMobileController.dispose();
    super.dispose();
  }
}
