import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/advance_filter_widget.dart';
import '../widgets/text_input.dart';
import '../widgets/expandable_status_filter.dart';
import '../widgets/request_form_widgets.dart';
import '../widgets/offline_tab_widget.dart';
import '../widgets/add_button_widget.dart'; // <-- IMPORT REUSABLE BUTTON
import 'customer_request/customer_request_screen.dart';

class CustomerRequestScreen extends StatefulWidget {
  const CustomerRequestScreen({super.key});

  @override
  State<CustomerRequestScreen> createState() => _CustomerRequestScreenState();
}

class _CustomerRequestScreenState extends State<CustomerRequestScreen> {
  int currentTab = 0; 
  String selectedFilter = "7";
  String selectedStatus = "Active";
  final Map<String, String?> _customerFilters = {};

  static const List<Map<String, dynamic>> _customerStatuses = [
    {'label': 'All', 'color': Color(0xFF3B82F6)},
    {'label': 'Active', 'color': Color(0xFF10B981)},
    {'label': 'Draft', 'color': Color(0xFF6B7280)},
    {'label': 'Archive', 'color': Color(0xFF3B82F6)},
  ];

  static final List<Map<String, dynamic>> _customers = [
    {'name': "John Doe's Poultry", 'shortName': "JD's Poultry", 'currency': 'Peso', 'creditLimit': '90,887', 'dateOpened': '03-February-2026', 'status': 'Active'},
    {'name': 'ABC Corporation', 'shortName': "ABC's", 'currency': 'Peso', 'creditLimit': '15,000', 'dateOpened': '02-February-2026', 'status': 'Active'},
    {'name': 'Global Trading, Inc.', 'shortName': 'GT', 'currency': 'Peso', 'creditLimit': '25,000', 'dateOpened': '01-February-2026', 'status': 'Active'},
    {'name': 'JDM Online Shop', 'shortName': 'JDM', 'currency': 'Peso', 'creditLimit': '50,000', 'dateOpened': '01-February-2026', 'status': 'Draft'},
  ];

  void _openCreateCustomer() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateCustomerRequestScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = context.watch<AppState>().headerColor;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: headerColor, foregroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context)),
        title: Text('Customer Request', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          RequestTabToggle(currentTab: currentTab, onTabChanged: (i) => setState(() => currentTab = i)),
          Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: currentTab == 0 ? _buildHistoryTab() : _buildOfflineTab())),
        ],
      ),
      // --- USE REUSABLE BUTTON HERE ---
      floatingActionButton: currentTab == 0 
        ? AddButtonWidget(
            label: "Add Customer",
            onPressed: _openCreateCustomer,
          )
        : null,
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  Widget _buildHistoryTab() {
    final filtered = selectedStatus == 'All' ? _customers : _customers.where((c) => c['status'] == selectedStatus).toList();

    return SingleChildScrollView(
      key: const ValueKey("history"),
      child: Column(
        children: [
          Container(
            color: Colors.white, padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppTextInput(hintText: 'Search Records', hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 13), prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20), contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300))),
                const SizedBox(height: 16),
                Row(children: [ _buildFilterChip("Last 7 Days", "7"), const SizedBox(width: 8), _buildFilterChip("Last 30 Days", "30"), const SizedBox(width: 8), _buildFilterChip("Custom", "custom") ]),
                const SizedBox(height: 12),
                ExpandableStatusFilter(statuses: _customerStatuses, selectedStatus: selectedStatus, onChanged: (v) => setState(() => selectedStatus = v ?? 'All')),
                const SizedBox(height: 12),
                AdvanceFilterWidget(
                  fields: const [
                    AdvanceFilterField(key: 'customerType', label: 'Customer Type', hint: 'Choose Customer Type', items: ['Business', 'Individual']),
                    AdvanceFilterField(key: 'businessAccountType', label: 'Business Account Type', hint: 'Choose Business Account', items: ['Parent Account', 'Child Account']),
                    AdvanceFilterField(key: 'customerGroup', label: 'Customer Group', hint: 'Choose Customer Group', items: ['Group A', 'Group B', 'Group C']),
                    AdvanceFilterField(key: 'salesRep', label: 'Sales Rep', hint: 'Choose Representative', items: ['Rep A', 'Rep B', 'Rep C']),
                    AdvanceFilterField(key: 'currency', label: 'Currency', hint: 'Choose Currency', items: ['Peso', 'USD', 'EUR', 'GBP']),
                    AdvanceFilterField(key: 'industry', label: 'Industry', hint: 'Choose Industry', items: ['Agriculture', 'Manufacturing', 'Retail', 'Technology']),
                    AdvanceFilterField(key: 'countryCode', label: 'Country Code', hint: 'Choose Country', items: ['PH', 'US', 'AU', 'SG', 'JP']),
                  ],
                  values: _customerFilters,
                  onChanged: (v) => setState(() => _customerFilters.addAll(v)),
                  onApply: () {},
                ),
              ],
            ),
          ),
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

  Widget _buildOfflineTab() {
    return OfflineTabWidget(
      key: const ValueKey("offline"),
      items: [
        OfflineRecordItem(title: "Customer Draft", subtitle: "Pending Sync • Nov 19, 2025", status: "Pending Sync", statusColor: Colors.amber.shade700),
        OfflineRecordItem(title: "New Customer", subtitle: "Sync Failed • Nov 15, 2025", status: "Sync Failed", statusColor: Colors.redAccent),
      ],
      onSyncAll: () {},
      onDeleteRange: () {},
    );
  }

  Widget _buildFilterChip(String label, String value) {
    bool isSelected = selectedFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedFilter = value),
        child: Container(
          constraints: const BoxConstraints(minHeight: 36), alignment: Alignment.center,
          decoration: BoxDecoration(color: isSelected ? const Color(0xFF2181FF) : Colors.white, border: isSelected ? null : Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
          child: Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade700)),
        ),
      ),
    );
  }
}
