import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/text_input.dart';
import '../widgets/request_form_widgets.dart';

class CreateCustomerRequestScreen extends StatefulWidget {
  const CreateCustomerRequestScreen({super.key});

  @override
  State<CreateCustomerRequestScreen> createState() =>
      _CreateCustomerRequestScreenState();
}

class _CreateCustomerRequestScreenState
    extends State<CreateCustomerRequestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ─── Identification fields ────────────────────────────────────────────
  int _accountType = 0; // 0 = Business, 1 = Individual
  DateTime _dateAccountOpened = DateTime(2026, 1, 27);
  bool _accountActive = true;
  int _businessAccountType = 0; // 0 = Parent, 1 = Child

  final _businessNameController = TextEditingController();
  final _shortNameController = TextEditingController();
  final _storeNumberController = TextEditingController();
  final _vendorNumberController = TextEditingController();

  String? _selectedCurrency;
  String? _selectedIndustry;
  String? _selectedCustomerType;
  String? _selectedSalesRep;

  // ─── Attribute fields ─────────────────────────────────────────────────
  bool _purchaseOrderRequired = false;
  bool _mailingList = false;
  bool _invoiceWithGoods = false;
  bool _acceptPartDeliveries = false;
  bool _indentOrders = false;
  bool _jobLoggingNotRequired = false;
  bool _autoEmailInvoice = false;
  bool _acceptBackOrders = false;
  bool _roundSalesOrder = false;
  bool _allowMultiplePickingSlips = false;

  // ─── Finance fields ───────────────────────────────────────────────────
  String? _tradingTerms;
  bool _exceptHold = false;
  int _balanceMethod = 0; // 0 = Balance Forward, 1 = Open Method
  final _taxIdController = TextEditingController();
  String? _defaultRevenueAccount;
  final _creditLimitController = TextEditingController();
  bool _sendStatement = false;
  String? _taxRule;
  String? _accountReceivable;

  // ─── Requirements fields ──────────────────────────────────────────────
  final List<TextEditingController> _preAttendanceChecklist = [
    TextEditingController(),
  ];
  final List<TextEditingController> _onSiteChecklist = [
    TextEditingController(),
  ];

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
    'Requirements',
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
    _taxIdController.dispose();
    _creditLimitController.dispose();
    for (final c in _preAttendanceChecklist) {
      c.dispose();
    }
    for (final c in _onSiteChecklist) {
      c.dispose();
    }
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
          'Create Customer Request',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Tab Bar
          FormTabBar(controller: _tabController, labels: _tabLabels),

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
                _buildRequirementsTab(),
                _buildDocumentsTab(),
              ],
            ),
          ),

          // Bottom Buttons
          FormBottomActions(
            onSaveDraft: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Saved as draft!', style: GoogleFonts.inter()),
                  backgroundColor: AppColors.statusApproved,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onSubmit: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Customer request submitted!',
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: AppColors.statusApproved,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pop(context);
            },
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
          const FormTabTitle("Identification Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Identification Tab records the customer's basic details and information about the industry or sector in which they operate, which helps and categorize the customer within the system.",
          ),
          const SizedBox(height: 20),

          // Customer Account Type
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

          // Date Account Opened
          FormDateField(
            date: _dateAccountOpened,
            onChanged: (picked) => setState(() => _dateAccountOpened = picked),
          ),
          const SizedBox(height: 20),

          // Account Status
          const FormSectionLabel("Account Status"),
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
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF2181FF),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFE0E0E0),
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Business Account Type
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

          // Text fields
          FormTextField(
            controller: _businessNameController,
            hint: "Enter Business Name",
          ),
          const SizedBox(height: 12),
          FormTextField(
            controller: _shortNameController,
            hint: "Enter Short Name",
          ),
          const SizedBox(height: 12),
          FormTextField(
            controller: _storeNumberController,
            hint: "Store Number",
          ),
          const SizedBox(height: 12),
          FormDropdownField(
            hint: "Choose Currency",
            value: _selectedCurrency,
            items: const ["Peso", "USD", "EUR", "GBP"],
            onChanged: (v) => setState(() => _selectedCurrency = v),
          ),
          const SizedBox(height: 12),
          FormTextField(
            controller: _vendorNumberController,
            hint: "Vendor Number",
          ),
          const SizedBox(height: 12),
          FormDropdownField(
            hint: "Choose Industry",
            value: _selectedIndustry,
            items: const [
              "Agriculture",
              "Manufacturing",
              "Retail",
              "Technology",
            ],
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

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB 2: ATTRIBUTE
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildAttributeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormTabTitle("Attributes Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Attributes Tab records the customer's basic details and information about the industry or sector in which they operate, which helps identify and categorize the customer within the system.",
          ),
          const SizedBox(height: 20),
          FormSwitchRow(
            label: "Purchase Order Required",
            value: _purchaseOrderRequired,
            onChanged: (v) => setState(() => _purchaseOrderRequired = v),
          ),
          FormSwitchRow(
            label: "Mailing List",
            value: _mailingList,
            onChanged: (v) => setState(() => _mailingList = v),
          ),
          FormSwitchRow(
            label: "Invoice with Goods",
            value: _invoiceWithGoods,
            onChanged: (v) => setState(() => _invoiceWithGoods = v),
          ),
          FormSwitchRow(
            label: "Accept Part Deliveries",
            value: _acceptPartDeliveries,
            onChanged: (v) => setState(() => _acceptPartDeliveries = v),
          ),
          FormSwitchRow(
            label: "Indent Orders for this Customer",
            value: _indentOrders,
            onChanged: (v) => setState(() => _indentOrders = v),
          ),
          FormSwitchRow(
            label: "Job Logging Order Not Required",
            value: _jobLoggingNotRequired,
            onChanged: (v) => setState(() => _jobLoggingNotRequired = v),
          ),
          FormSwitchRow(
            label: "Auto E-mail Invoice to Customer",
            value: _autoEmailInvoice,
            onChanged: (v) => setState(() => _autoEmailInvoice = v),
          ),
          FormSwitchRow(
            label: "Accept Back Orders",
            value: _acceptBackOrders,
            onChanged: (v) => setState(() => _acceptBackOrders = v),
          ),
          FormSwitchRow(
            label: "Round Sales Order Qty. to Whole Cartons",
            value: _roundSalesOrder,
            onChanged: (v) => setState(() => _roundSalesOrder = v),
          ),
          FormSwitchRow(
            label: "Allow Multiple Picking Slips per Invoice",
            value: _allowMultiplePickingSlips,
            onChanged: (v) => setState(() => _allowMultiplePickingSlips = v),
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
          const FormTabTitle("Contacts Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Contacts Tab records the customer's basic details and information about the industry or sector in which they operate, which helps identify and categorize the customer within the system.",
          ),
          const SizedBox(height: 20),
          FormAddButton(
            label: "Add Contact",
            onPressed: () {
              setState(() {
                _contacts.add({'name': 'New Contact', 'phone': ''});
              });
            },
          ),
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
                    Icon(
                      Icons.person_outline,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Contact ${entry.key + 1}",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _contacts.removeAt(entry.key)),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
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
          const FormTabTitle("Address Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Address Tab records the customer's basic details and information about the industry or sector in which they operate, which helps identify and categorize the customer within the system.",
          ),
          const SizedBox(height: 20),
          FormAddButton(
            label: "Add Address",
            onPressed: () {
              setState(() {
                _addresses.add({'address': 'New Address'});
              });
            },
          ),
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
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Address ${entry.key + 1}",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _addresses.removeAt(entry.key)),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
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
          const FormTabTitle("Finance Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Finance Tab records the customer's basic details and information about the industry or sector in which they operate, which helps identify and categorize the customer within the system.",
          ),
          const SizedBox(height: 20),
          FormDropdownField(
            hint: "Trading Terms",
            value: _tradingTerms,
            items: const ["Net 30", "Net 60", "Net 90", "COD"],
            onChanged: (v) => setState(() => _tradingTerms = v),
          ),
          const SizedBox(height: 16),

          // Except Hold
          const FormSectionLabel("Except Hold"),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Switch(
                value: _exceptHold,
                onChanged: (v) => setState(() => _exceptHold = v),
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF2181FF),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFE0E0E0),
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Balance Forward or Open Method
          const FormSectionLabel("Balance Forward or Open Method"),
          const SizedBox(height: 8),
          Row(
            children: [
              FormRadioOption(
                label: "Balance Forward",
                value: 0,
                groupValue: _balanceMethod,
                onChanged: (v) => setState(() => _balanceMethod = v),
              ),
              const SizedBox(width: 20),
              FormRadioOption(
                label: "Open Method",
                value: 1,
                groupValue: _balanceMethod,
                onChanged: (v) => setState(() => _balanceMethod = v),
              ),
            ],
          ),
          const SizedBox(height: 16),

          FormTextField(
            controller: _taxIdController,
            hint: "Tax Identification",
          ),
          const SizedBox(height: 12),
          FormDropdownField(
            hint: "Default Revenue Account",
            value: _defaultRevenueAccount,
            items: const ["Account A", "Account B", "Account C"],
            onChanged: (v) => setState(() => _defaultRevenueAccount = v),
          ),
          const SizedBox(height: 12),
          FormTextField(
            controller: _creditLimitController,
            hint: "Credit Limit",
          ),
          const SizedBox(height: 16),

          // Send Statement
          FormSwitchRow(
            label: "Send Statement",
            value: _sendStatement,
            onChanged: (v) => setState(() => _sendStatement = v),
          ),
          const SizedBox(height: 12),

          FormDropdownField(
            hint: "Tax Rule",
            value: _taxRule,
            items: const ["Standard", "Exempt", "Reduced"],
            onChanged: (v) => setState(() => _taxRule = v),
          ),
          const SizedBox(height: 12),
          FormDropdownField(
            hint: "Account Receivable",
            value: _accountReceivable,
            items: const ["AR Account 1", "AR Account 2", "AR Account 3"],
            onChanged: (v) => setState(() => _accountReceivable = v),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB 6: REQUIREMENTS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildRequirementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormTabTitle("Customer Requirements"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Customer Requirements records the customer's basic details and information about the industry or sector in which they operate, which helps and categorize the customer within the system.",
          ),
          const SizedBox(height: 20),

          // Pre Attendance Checklist
          const FormSectionLabel("Pre Attendance Checklist"),
          const SizedBox(height: 12),
          ..._preAttendanceChecklist.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    "${entry.key + 1}",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppTextInput(
                      controller: entry.value,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                      hintText: 'Enter Pre-Attendance Checklist',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
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
                    onTap: () {
                      if (_preAttendanceChecklist.length > 1) {
                        setState(() {
                          _preAttendanceChecklist[entry.key].dispose();
                          _preAttendanceChecklist.removeAt(entry.key);
                        });
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.dangerRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: AppColors.dangerRed,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 4),
          FormAddButton(
            label: "Add",
            onPressed: () {
              setState(() {
                _preAttendanceChecklist.add(TextEditingController());
              });
            },
          ),
          const SizedBox(height: 24),

          // On Site Checklist
          const FormSectionLabel("On Site Checklist"),
          const SizedBox(height: 12),
          ..._onSiteChecklist.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    "${entry.key + 1}",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppTextInput(
                      controller: entry.value,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                      hintText: 'Enter On Site Checklist',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
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
                    onTap: () {
                      if (_onSiteChecklist.length > 1) {
                        setState(() {
                          _onSiteChecklist[entry.key].dispose();
                          _onSiteChecklist.removeAt(entry.key);
                        });
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.dangerRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: AppColors.dangerRed,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 4),
          FormAddButton(
            label: "Add",
            onPressed: () {
              setState(() {
                _onSiteChecklist.add(TextEditingController());
              });
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB 7: DOCUMENTS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildDocumentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormTabTitle("Documents Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Documents Tab records the customer's basic details and information about the industry or sector in which they operate, which helps identify and categorize the customer within the system.",
          ),
          const SizedBox(height: 20),
          FormAddButton(
            label: "Add Document",
            onPressed: () {
              setState(() {
                _documents.add({'name': 'New Document'});
              });
            },
          ),
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
                    Icon(
                      Icons.description_outlined,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Document ${entry.key + 1}",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _documents.removeAt(entry.key)),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
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
}
