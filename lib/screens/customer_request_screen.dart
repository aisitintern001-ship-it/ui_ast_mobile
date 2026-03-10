import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/request_form_widgets.dart';
import 'create_customer_request_screen.dart';

class CustomerRequestScreen extends StatefulWidget {
  const CustomerRequestScreen({super.key});

  @override
  State<CustomerRequestScreen> createState() => _CustomerRequestScreenState();
}

class _CustomerRequestScreenState extends State<CustomerRequestScreen> {
  int currentTab = 0; // 0 = History, 1 = Offline
  String selectedFilter = "7";
  String selectedStatus = "Active";
  bool isAdvanceFilterExpanded = false;

  // Advance filter values
  String? _filterCustomerType;
  String? _filterBusinessAccountType;
  String? _filterCustomerGroup;
  String? _filterSalesRep;
  String? _filterCurrency;
  String? _filterIndustry;
  String? _filterCountryCode;

  // Mock customer data
  static final List<Map<String, dynamic>> _customers = [
    {
      'name': "John Doe's Poultry",
      'shortName': "JD's Poultry",
      'currency': 'Peso',
      'creditLimit': '90,887',
      'dateOpened': '03-February-2026',
      'status': 'Active',
    },
    {
      'name': 'ABC Corporation',
      'shortName': "ABC's",
      'currency': 'Peso',
      'creditLimit': '15,000',
      'dateOpened': '02-February-2026',
      'status': 'Active',
    },
    {
      'name': 'Global Trading, Inc.',
      'shortName': 'GT',
      'currency': 'Peso',
      'creditLimit': '25,000',
      'dateOpened': '01-February-2026',
      'status': 'Active',
    },
    {
      'name': 'JDM Online Shop',
      'shortName': 'JDM',
      'currency': 'Peso',
      'creditLimit': '50,000',
      'dateOpened': '01-February-2026',
      'status': 'Draft',
    },
  ];

  void _openCreateCustomer() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateCustomerRequestScreen()),
    );
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
          'Customer Request',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Tab Toggle
          RequestTabToggle(
            currentTab: currentTab,
            onTabChanged: (i) => setState(() => currentTab = i),
          ),

          // Tab Content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: currentTab == 0 ? _buildHistoryTab() : _buildOfflineTab(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateCustomer,
        backgroundColor: const Color(0xFF2181FF),
        elevation: 4,
        icon: const Icon(Icons.add, color: Colors.white, size: 18),
        label: Text(
          "Add Customer",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  // ─── History Tab ──────────────────────────────────────────────────────

  Widget _buildHistoryTab() {
    // Filter customers based on selected status
    final filtered = selectedStatus == 'All'
        ? _customers
        : _customers.where((c) => c['status'] == selectedStatus).toList();

    return SingleChildScrollView(
      key: const ValueKey("history"),
      child: Column(
        children: [
          // Search & Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Records',
                    hintStyle: GoogleFonts.inter(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Filter Chips
                Row(
                  children: [
                    _buildFilterChip("Last 7 Days", "7"),
                    const SizedBox(width: 8),
                    _buildFilterChip("Last 30 Days", "30"),
                    const SizedBox(width: 8),
                    _buildFilterChip("Custom", "custom"),
                  ],
                ),
                const SizedBox(height: 12),

                // Status filter dropdown
                StatusFilterDropdown(
                  selectedStatus: selectedStatus,
                  onChanged: (v) => setState(() => selectedStatus = v),
                ),
                const SizedBox(height: 12),

                // Advance Filter dropdown
                GestureDetector(
                  onTap: () => setState(
                    () => isAdvanceFilterExpanded = !isAdvanceFilterExpanded,
                  ),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Advance Filter",
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        AnimatedRotation(
                          turns: isAdvanceFilterExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Advance Filter expandable section
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      const AdvanceFilterLabel("Customer Type"),
                      const SizedBox(height: 6),
                      AdvanceFilterDropdown(
                        hint: "Choose Customer Type",
                        value: _filterCustomerType,
                        items: const ["Business", "Individual"],
                        onChanged: (v) =>
                            setState(() => _filterCustomerType = v),
                      ),
                      const SizedBox(height: 12),
                      const AdvanceFilterLabel("Business Account Type"),
                      const SizedBox(height: 6),
                      AdvanceFilterDropdown(
                        hint: "Choose Business Account",
                        value: _filterBusinessAccountType,
                        items: const ["Parent Account", "Child Account"],
                        onChanged: (v) =>
                            setState(() => _filterBusinessAccountType = v),
                      ),
                      const SizedBox(height: 12),
                      const AdvanceFilterLabel("Customer Group"),
                      const SizedBox(height: 6),
                      AdvanceFilterDropdown(
                        hint: "Choose Customer Group",
                        value: _filterCustomerGroup,
                        items: const ["Group A", "Group B", "Group C"],
                        onChanged: (v) =>
                            setState(() => _filterCustomerGroup = v),
                      ),
                      const SizedBox(height: 12),
                      const AdvanceFilterLabel("Sales Rep"),
                      const SizedBox(height: 6),
                      AdvanceFilterDropdown(
                        hint: "Choose Representative",
                        value: _filterSalesRep,
                        items: const ["Rep A", "Rep B", "Rep C"],
                        onChanged: (v) =>
                            setState(() => _filterSalesRep = v),
                      ),
                      const SizedBox(height: 12),
                      const AdvanceFilterLabel("Select Currency"),
                      const SizedBox(height: 6),
                      AdvanceFilterDropdown(
                        hint: "Choose Currency",
                        value: _filterCurrency,
                        items: const ["Peso", "USD", "EUR", "GBP"],
                        onChanged: (v) =>
                            setState(() => _filterCurrency = v),
                      ),
                      const SizedBox(height: 12),
                      const AdvanceFilterLabel("Select Industry"),
                      const SizedBox(height: 6),
                      AdvanceFilterDropdown(
                        hint: "Choose Industry",
                        value: _filterIndustry,
                        items: const [
                          "Agriculture",
                          "Manufacturing",
                          "Retail",
                          "Technology",
                        ],
                        onChanged: (v) =>
                            setState(() => _filterIndustry = v),
                      ),
                      const SizedBox(height: 12),
                      const AdvanceFilterLabel("Country Code"),
                      const SizedBox(height: 6),
                      AdvanceFilterDropdown(
                        hint: "Choose Country",
                        value: _filterCountryCode,
                        items: const ["PH", "US", "AU", "SG", "JP"],
                        onChanged: (v) =>
                            setState(() => _filterCountryCode = v),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                  crossFadeState: isAdvanceFilterExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),

                // Apply Filter Button
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2181FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Apply Filter",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Customer Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: filtered.map((c) {
                return RequestRecordCard(
                  name: c['name'] as String,
                  status: c['status'] as String,
                  details: {
                    'Short Name:': c['shortName'] as String,
                    'Currency:': c['currency'] as String,
                    'Credit Limit:': c['creditLimit'] as String,
                    'Date Opened:': c['dateOpened'] as String,
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  // ─── Offline Tab ──────────────────────────────────────────────────────

  Widget _buildOfflineTab() {
    return Column(
      key: const ValueKey("offline"),
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.delete_outline,
                        color: Colors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Delete Synced Records",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildDatePicker("Date From")),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDatePicker("Date To")),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.redAccent.withValues(alpha: 0.8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: Text(
                      "Delete Synced Range",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Icon(Icons.wifi_off,
                        color: Colors.black87, size: 20),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Offline Records",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Records saved while offline, pending sync",
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildOfflineCard(
                  "Customer Draft",
                  "Pending Sync • Nov 19, 2025",
                  "Pending Sync",
                  Colors.amber.shade700,
                ),
                _buildOfflineCard(
                  "New Customer",
                  "Sync Failed • Nov 15, 2025",
                  "Sync Failed",
                  Colors.redAccent,
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C48C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              child: Text(
                "Sync All Records",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────

  Widget _buildFilterChip(String label, String value) {
    bool isSelected = selectedFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedFilter = value),
        child: Container(
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2181FF) : Colors.white,
            border:
                isSelected ? null : Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String hint) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Text(
            hint,
            style: GoogleFonts.inter(
                fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineCard(
    String title,
    String subtitle,
    String status,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                    fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: status == "Sync Failed" ? statusColor : Colors.white,
              border: status == "Pending Sync"
                  ? Border.all(color: statusColor)
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                color:
                    status == "Sync Failed" ? Colors.white : statusColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
