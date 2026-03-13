import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/advance_filter_widget.dart';
import '../widgets/text_input.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/offline_tab_widget.dart';
import '../widgets/add_button_widget.dart'; // <-- IMPORT REUSABLE BUTTON
import 'create_supplier_request_screen.dart';

class SupplierRequestScreen extends StatefulWidget {
  const SupplierRequestScreen({super.key});

  @override
  State<SupplierRequestScreen> createState() => _SupplierRequestScreenState();
}

class _SupplierRequestScreenState extends State<SupplierRequestScreen> {
  int currentTab = 0; 
  String selectedFilter = "7";
  final Map<String, String?> _supplierFilters = {};

  static final List<Map<String, dynamic>> _suppliers = [
    {'name': 'Maagap Insurance Inc.', 'shortName': 'Maagap', 'currency': 'Peso', 'creditLimit': '90,887', 'dateOpened': '03-February-2026', 'status': 'Active'},
    {'name': 'Alcon Heavy Parts Supply', 'shortName': 'Alcon Heavy', 'currency': 'Peso', 'creditLimit': '10,000', 'dateOpened': '02-February-2026', 'status': 'Active'},
    {'name': 'Genesis Equipment & Fluid...', 'shortName': 'Genesis', 'currency': 'Peso', 'creditLimit': '10,000', 'dateOpened': '02-February-2026', 'status': 'Active'},
    {'name': 'JDM Online Shop', 'shortName': 'JDM', 'currency': 'Peso', 'creditLimit': '50,000', 'dateOpened': '01-February-2026', 'status': 'Draft'},
  ];

  void _openCreateSupplier() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateSupplierRequestScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = context.watch<AppState>().headerColor;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: headerColor, foregroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context)),
        title: Text('Supplier Request', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(25)),
            child: Row(children: [ _buildTabButton("History", Icons.history, 0), _buildTabButton("Offline", Icons.wifi_off, 1) ]),
          ),
          Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: currentTab == 0 ? _buildHistoryTab() : _buildOfflineTab())),
        ],
      ),
      // --- USE REUSABLE BUTTON HERE ---
      floatingActionButton: currentTab == 0 
        ? AddButtonWidget(
            label: "Add Supplier",
            onPressed: _openCreateSupplier,
          )
        : null,
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  Widget _buildHistoryTab() {
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
                AdvanceFilterWidget(
                  fields: const [
                    AdvanceFilterField(key: 'supplierType', label: 'Supplier Type', hint: 'Select Supplier Type', items: ['Business', 'Individual']),
                    AdvanceFilterField(key: 'supplierGroup', label: 'Supplier Group', hint: 'Select Supplier Group', items: ['Group A', 'Group B', 'Group C']),
                    AdvanceFilterField(key: 'accountType', label: 'Account Type', hint: 'Select Account Type', items: ['Parent Account', 'Child Account']),
                    AdvanceFilterField(key: 'currency', label: 'Currency', hint: 'Select Currency', items: ['Peso', 'USD', 'EUR', 'GBP']),
                    AdvanceFilterField(key: 'countryCode', label: 'Country Code', hint: 'Select Country', items: ['PH', 'US', 'AU', 'SG', 'JP']),
                  ],
                  values: _supplierFilters,
                  onChanged: (v) => setState(() => _supplierFilters.addAll(v)),
                  onApply: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: _suppliers.map((s) => _buildSupplierCard(s)).toList()),
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
        OfflineRecordItem(title: "Supplier Draft", subtitle: "Pending Sync • Nov 19, 2025", status: "Pending Sync", statusColor: Colors.amber.shade700),
        OfflineRecordItem(title: "New Supplier", subtitle: "Sync Failed • Nov 15, 2025", status: "Sync Failed", statusColor: Colors.redAccent),
      ],
      onSyncAll: () {},
      onDeleteRange: () {},
    );
  }

  Widget _buildSupplierCard(Map<String, dynamic> supplier) {
    final bool isActive = supplier['status'] == 'Active';
    final Color statusColor = isActive ? const Color(0xFF10B981) : Colors.grey.shade500;
    final Color statusBg = isActive ? const Color(0xFF10B981).withValues(alpha: 0.1) : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Row(children: [ Flexible(child: Text(supplier['name'] as String, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis, maxLines: 1)), const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3), decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)), child: Text(supplier['status'] as String, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor))) ])),
              SizedBox(height: 24, width: 24, child: PopupMenuButton<String>(padding: EdgeInsets.zero, icon: const Icon(Icons.more_vert, size: 20, color: Colors.black54), itemBuilder: (context) => [ PopupMenuItem(value: 'edit', child: Row(children: [const Icon(Icons.edit_outlined, color: Colors.amber, size: 18), const SizedBox(width: 8), Text("Edit", style: GoogleFonts.inter(fontSize: 13))])), PopupMenuItem(value: 'view', child: Row(children: [const Icon(Icons.visibility_outlined, color: Colors.blue, size: 18), const SizedBox(width: 8), Text("View", style: GoogleFonts.inter(fontSize: 13))]))], onSelected: (val) {}))
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow("Short Name:", supplier['shortName'] as String), const SizedBox(height: 6),
          _buildDetailRow("Currency:", supplier['currency'] as String), const SizedBox(height: 6),
          _buildDetailRow("Credit Limit:", supplier['creditLimit'] as String), const SizedBox(height: 6),
          _buildDetailRow("Date Opened:", supplier['dateOpened'] as String),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)), const SizedBox(width: 8),
        Flexible(child: Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis, textAlign: TextAlign.end)),
      ],
    );
  }

  Widget _buildTabButton(String title, IconData icon, int index) {
    final bool isSelected = currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => currentTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(25), boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))] : []),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 16, color: isSelected ? Colors.black87 : Colors.grey.shade500), const SizedBox(width: 6), Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: isSelected ? Colors.black87 : Colors.grey.shade500))]),
        ),
      ),
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