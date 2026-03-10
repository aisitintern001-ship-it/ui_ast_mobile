import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';

class CreateSupplierRequestScreen extends StatefulWidget {
  const CreateSupplierRequestScreen({super.key});

  @override
  State<CreateSupplierRequestScreen> createState() =>
      _CreateSupplierRequestScreenState();
}

class _CreateSupplierRequestScreenState
    extends State<CreateSupplierRequestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ─── Identification fields ────────────────────────────────────────────
  int _supplierType = 0; // 0 = Business, 1 = Individual
  DateTime _dateAccountOpened = DateTime(2026, 1, 27);
  bool _accountActive = true;
  int _businessAccountType = 0; // 0 = Parent, 1 = Child

  final _businessNameController = TextEditingController();
  final _shortNameController = TextEditingController();
  final _storeNumberController = TextEditingController();
  final _vendorNumberController = TextEditingController();
  final _webLinkController = TextEditingController();
  final _creditLimitController = TextEditingController();

  String? _selectedCurrency;
  String? _selectedSupplierGroup;
  String? _selectedTags;

  // ─── Attribute fields ─────────────────────────────────────────────────
  bool _autoEmailOrder = false;
  bool _acceptBulkOrders = false;
  bool _acceptPartDeliveries = false;
  bool _roundPurchasedOrders = false;
  String? _selectedShippingMethod;
  String? _selectedShippingRegion;

  // ─── Finance fields ───────────────────────────────────────────────────
  String? _financeCurrency;
  String? _tradingTerms;
  String? _taxRule;
  int _paymentOption = -1; // 0=Cash, 1=Bank, 2=GCash, 3=Money Remittance
  bool _financeAcceptPartDeliveries = false;
  String? _whtRate;
  String? _costCentre;

  // ─── Contacts / Address / Documents ───────────────────────────────────
  final List<Map<String, String>> _contacts = [];
  final List<Map<String, String>> _addresses = [];
  final List<Map<String, String>> _documents = [];

  static const _tabLabels = [
    'Identification',
    'Attribute',
    'Contacts',
    'Address',
    'Finance',
    'Documents',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _businessNameController.dispose();
    _shortNameController.dispose();
    _storeNumberController.dispose();
    _vendorNumberController.dispose();
    _webLinkController.dispose();
    _creditLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = context.watch<AppState>().headerColor;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: headerColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Supplier Request',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: List.generate(_tabLabels.length, (index) {
                  final isSelected = _tabController.index == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _tabController.animateTo(index),
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          border: isSelected
                              ? const Border(
                                  bottom: BorderSide(
                                    color: Color(0xFF2181FF),
                                    width: 2,
                                  ),
                                )
                              : null,
                        ),
                        child: Text(
                          _tabLabels[index],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF2181FF)
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildIdentificationTab(),
                _buildAttributeTab(),
                _buildContactsTab(),
                _buildAddressTab(),
                _buildFinanceTab(),
                _buildDocumentsTab(),
              ],
            ),
          ),

          // Bottom Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Save As Draft',
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
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Supplier request submitted!',
                              style: GoogleFonts.inter(),
                            ),
                            backgroundColor: AppColors.statusApproved,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2181FF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Submit',
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
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB 1: IDENTIFICATION
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildIdentificationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tabTitle("Identification Tab"),
          const SizedBox(height: 6),
          _tabDescription(
            "Identification Tab records the customer's basic details and information about the industry or sector in which they operate, which helps and categorize the customer within the system.",
          ),
          const SizedBox(height: 20),

          // Supplier Type
          _sectionLabel("Supplier Type"),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildRadioOption("Business", 0, _supplierType, (v) {
                setState(() => _supplierType = v);
              }),
              const SizedBox(width: 24),
              _buildRadioOption("Individual", 1, _supplierType, (v) {
                setState(() => _supplierType = v);
              }),
            ],
          ),
          const SizedBox(height: 20),

          // Date Account Opened
          _sectionLabel("Date Account Opened"),
          const SizedBox(height: 8),
          _buildDateField(_dateAccountOpened, (picked) {
            setState(() => _dateAccountOpened = picked);
          }),
          const SizedBox(height: 20),

          // Account Status
          _sectionLabel("Account Status"),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Active",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              Switch(
                value: _accountActive,
                onChanged: (v) => setState(() => _accountActive = v),
                activeColor: const Color(0xFF2181FF),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Web Link
          _buildTextField(controller: _webLinkController, hint: "Web Link"),
          const SizedBox(height: 20),

          // Business Account Type
          _sectionLabel("Business Account Type"),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildRadioOption("Parent Account", 0, _businessAccountType, (v) {
                setState(() => _businessAccountType = v);
              }),
              const SizedBox(width: 20),
              _buildRadioOption("Child Account", 1, _businessAccountType, (v) {
                setState(() => _businessAccountType = v);
              }),
            ],
          ),
          const SizedBox(height: 20),

          // Text fields
          _buildTextField(
            controller: _businessNameController,
            hint: "Business Name",
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _shortNameController,
            hint: "Short Name",
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            hint: "Currency",
            value: _selectedCurrency,
            items: const ["Peso", "USD", "EUR", "GBP"],
            onChanged: (v) => setState(() => _selectedCurrency = v),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _storeNumberController,
            hint: "Store Number",
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _vendorNumberController,
            hint: "Vendor Number",
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            hint: "Supplier Group",
            value: _selectedSupplierGroup,
            items: const ["Group A", "Group B", "Group C"],
            onChanged: (v) => setState(() => _selectedSupplierGroup = v),
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            hint: "Add tags",
            value: _selectedTags,
            items: const ["Tag 1", "Tag 2", "Tag 3"],
            onChanged: (v) => setState(() => _selectedTags = v),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB 2: ATTRIBUTE
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildAttributeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tabTitle("Attributes Tab"),
          const SizedBox(height: 6),
          _tabDescription(
            "Attributes Tab records the customer's basic details and information about the industry or sector in which they operate, which helps identify and categorize the customer within the system.",
          ),
          const SizedBox(height: 20),
          _buildSwitchRow(
            "Customer Auto Email Order to Supplier",
            _autoEmailOrder,
            (v) => setState(() => _autoEmailOrder = v),
          ),
          _buildSwitchRow(
            "Accept Bulk Orders",
            _acceptBulkOrders,
            (v) => setState(() => _acceptBulkOrders = v),
          ),
          _buildSwitchRow(
            "Accept Part Deliveries",
            _acceptPartDeliveries,
            (v) => setState(() => _acceptPartDeliveries = v),
          ),
          _buildSwitchRow(
            "Round Purchased Orders to Whole Cartoons",
            _roundPurchasedOrders,
            (v) => setState(() => _roundPurchasedOrders = v),
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            hint: "Normal Shipping Method",
            value: _selectedShippingMethod,
            items: const ["Standard", "Express", "Overnight", "Freight"],
            onChanged: (v) => setState(() => _selectedShippingMethod = v),
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            hint: "Shipping Region",
            value: _selectedShippingRegion,
            items: const ["Local", "National", "International"],
            onChanged: (v) => setState(() => _selectedShippingRegion = v),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB 3: CONTACTS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildContactsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tabTitle("Contacts Tab"),
          const SizedBox(height: 6),
          _tabDescription(
            "Contacts Tab records the customer's basic details and information about the industry or sector in which they operate, which helps identify and categorize the customer within the system.",
          ),
          const SizedBox(height: 20),
          _buildAddButton("Add Contact", () {
            setState(() {
              _contacts.add({'name': 'New Contact', 'phone': ''});
            });
          }),
          if (_contacts.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._contacts.asMap().entries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.grey.shade500, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Contact ${entry.key + 1}",
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _contacts.removeAt(entry.key)),
                      child: Icon(Icons.close, size: 18, color: Colors.grey.shade400),
                    ),
                  ],
                ),
              );
            }),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB 4: ADDRESS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildAddressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tabTitle("Address Tab"),
          const SizedBox(height: 6),
          _tabDescription(
            "Address Tab records the customer's basic details and information about the industry or sector in which they operate, which helps identify and categorize the customer within the system.",
          ),
          const SizedBox(height: 20),
          _buildAddButton("Add Address", () {
            setState(() {
              _addresses.add({'address': 'New Address'});
            });
          }),
          if (_addresses.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._addresses.asMap().entries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.grey.shade500, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Address ${entry.key + 1}",
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _addresses.removeAt(entry.key)),
                      child: Icon(Icons.close, size: 18, color: Colors.grey.shade400),
                    ),
                  ],
                ),
              );
            }),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB 5: FINANCE
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildFinanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tabTitle("Finance Tab"),
          const SizedBox(height: 6),
          _tabDescription(
            "Finance Tab records the customer's basic details and information about the industry or sector in which they operate, which helps identify and categorize the customer within the system.",
          ),
          const SizedBox(height: 20),
          _buildDropdownField(
            hint: "Currency",
            value: _financeCurrency,
            items: const ["Peso", "USD", "EUR", "GBP"],
            onChanged: (v) => setState(() => _financeCurrency = v),
            required: true,
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            hint: "Trading Terms",
            value: _tradingTerms,
            items: const ["Net 30", "Net 60", "Net 90", "COD"],
            onChanged: (v) => setState(() => _tradingTerms = v),
            required: true,
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            hint: "Tax Rule",
            value: _taxRule,
            items: const ["Standard", "Exempt", "Reduced"],
            onChanged: (v) => setState(() => _taxRule = v),
            required: true,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _creditLimitController,
            hint: "Credit Limit",
          ),
          const SizedBox(height: 20),

          // Payment Option
          _sectionLabel("Payment Option *"),
          const SizedBox(height: 8),
          _buildRadioOption("Cash", 0, _paymentOption, (v) {
            setState(() => _paymentOption = v);
          }),
          const SizedBox(height: 4),
          _buildRadioOption("Bank", 1, _paymentOption, (v) {
            setState(() => _paymentOption = v);
          }),
          const SizedBox(height: 4),
          _buildRadioOption("GCash", 2, _paymentOption, (v) {
            setState(() => _paymentOption = v);
          }),
          const SizedBox(height: 4),
          _buildRadioOption("Money Remittance", 3, _paymentOption, (v) {
            setState(() => _paymentOption = v);
          }),
          const SizedBox(height: 16),

          _buildDropdownField(
            hint: "WHT/EWt Rate",
            value: _whtRate,
            items: const ["1%", "2%", "5%", "10%"],
            onChanged: (v) => setState(() => _whtRate = v),
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            hint: "Cost Centre",
            value: _costCentre,
            items: const ["Centre A", "Centre B", "Centre C"],
            onChanged: (v) => setState(() => _costCentre = v),
          ),
          const SizedBox(height: 12),
          _buildSwitchRow(
            "Accept Part Deliveries",
            _financeAcceptPartDeliveries,
            (v) => setState(() => _financeAcceptPartDeliveries = v),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB 6: DOCUMENTS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildDocumentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tabTitle("Documents Tab"),
          const SizedBox(height: 6),
          _tabDescription(
            "Documents Tab records the customer's basic details and information about the industry or sector in which they operate, which helps identify and categorize the customer within the system.",
          ),
          const SizedBox(height: 20),
          _buildAddButton("Add Document", () {
            setState(() {
              _documents.add({'name': 'New Document'});
            });
          }),
          if (_documents.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._documents.asMap().entries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.description_outlined, color: Colors.grey.shade500, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Document ${entry.key + 1}",
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _documents.removeAt(entry.key)),
                      child: Icon(Icons.close, size: 18, color: Colors.grey.shade400),
                    ),
                  ],
                ),
              );
            }),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  SHARED WIDGETS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _tabTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _tabDescription(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildRadioOption(
    String label,
    int value,
    int groupValue,
    ValueChanged<int> onChanged,
  ) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.headerOrange : Colors.grey.shade400,
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
                        color: AppColors.headerOrange,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
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
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool required = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: RichText(
            text: TextSpan(
              text: hint,
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted),
              children: required
                  ? [
                      TextSpan(
                        text: ' *',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.headerOrange,
                        ),
                      ),
                    ]
                  : null,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey.shade500,
          ),
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDateField(DateTime date, ValueChanged<DateTime> onChanged) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onChanged(picked);
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
            Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade500),
            const SizedBox(width: 12),
            Text(
              _formatDate(date),
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final suffix = _daySuffix(date.day);
    return '${months[date.month - 1]} ${date.day}$suffix, ${date.year}';
  }

  String _daySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2181FF),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 18, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
