import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import 'create_supplier_request_screen.dart';

class SupplierRequestScreen extends StatefulWidget {
  const SupplierRequestScreen({super.key});

  @override
  State<SupplierRequestScreen> createState() => _SupplierRequestScreenState();
}

class _SupplierRequestScreenState extends State<SupplierRequestScreen> {
  int currentTab = 0; // 0 = History, 1 = Offline
  String selectedFilter = "7";
  bool isAdvanceFilterExpanded = false;

  // Advance filter values
  String? _filterSupplierType;
  String? _filterSupplierGroup;
  String? _filterAccountType;
  String? _filterCurrency;
  String? _filterCountryCode;

  // Mock supplier data
  static final List<Map<String, dynamic>> _suppliers = [
    {
      'name': 'Maagap Insurance Inc.',
      'shortName': 'Maagap',
      'currency': 'Peso',
      'creditLimit': '90,887',
      'dateOpened': '03-February-2026',
      'status': 'Active',
    },
    {
      'name': 'Alcon Heavy Parts Supply',
      'shortName': 'Alcon Heavy',
      'currency': 'Peso',
      'creditLimit': '10,000',
      'dateOpened': '02-February-2026',
      'status': 'Active',
    },
    {
      'name': 'Genesis Equipment & Fluid...',
      'shortName': 'Genesis',
      'currency': 'Peso',
      'creditLimit': '10,000',
      'dateOpened': '02-February-2026',
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

  void _openCreateSupplier() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateSupplierRequestScreen()),
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
          'Supplier Request',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Tab Toggle
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                _buildTabButton("History", Icons.history, 0),
                _buildTabButton("Offline", Icons.wifi_off, 1),
              ],
            ),
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
        onPressed: _openCreateSupplier,
        backgroundColor: const Color(0xFF2181FF),
        elevation: 4,
        icon: const Icon(Icons.add, color: Colors.white, size: 18),
        label: Text(
          "Add Supplier",
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
                      _advanceFilterLabel("Supplier Type"),
                      const SizedBox(height: 6),
                      _advanceFilterDropdown(
                        hint: "Select Supplier Type",
                        value: _filterSupplierType,
                        items: const ["Business", "Individual"],
                        onChanged: (v) => setState(() => _filterSupplierType = v),
                      ),
                      const SizedBox(height: 12),
                      _advanceFilterLabel("Supplier Group"),
                      const SizedBox(height: 6),
                      _advanceFilterDropdown(
                        hint: "Select Supplier Group",
                        value: _filterSupplierGroup,
                        items: const ["Group A", "Group B", "Group C"],
                        onChanged: (v) => setState(() => _filterSupplierGroup = v),
                      ),
                      const SizedBox(height: 12),
                      _advanceFilterLabel("Account Type"),
                      const SizedBox(height: 6),
                      _advanceFilterDropdown(
                        hint: "Select Account Type",
                        value: _filterAccountType,
                        items: const ["Parent Account", "Child Account"],
                        onChanged: (v) => setState(() => _filterAccountType = v),
                      ),
                      const SizedBox(height: 12),
                      _advanceFilterLabel("Currency"),
                      const SizedBox(height: 6),
                      _advanceFilterDropdown(
                        hint: "Select Currency",
                        value: _filterCurrency,
                        items: const ["Peso", "USD", "EUR", "GBP"],
                        onChanged: (v) => setState(() => _filterCurrency = v),
                      ),
                      const SizedBox(height: 12),
                      _advanceFilterLabel("Country Code"),
                      const SizedBox(height: 6),
                      _advanceFilterDropdown(
                        hint: "Select Country",
                        value: _filterCountryCode,
                        items: const ["PH", "US", "AU", "SG", "JP"],
                        onChanged: (v) => setState(() => _filterCountryCode = v),
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

          // Supplier Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: _suppliers
                  .map((s) => _buildSupplierCard(s))
                  .toList(),
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
                    const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
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
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
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
                    const Icon(Icons.wifi_off, color: Colors.black87, size: 20),
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
                  "Supplier Draft",
                  "Pending Sync • Nov 19, 2025",
                  "Pending Sync",
                  Colors.amber.shade700,
                ),
                _buildOfflineCard(
                  "New Supplier",
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

  // ─── Supplier Card ────────────────────────────────────────────────────

  Widget _buildSupplierCard(Map<String, dynamic> supplier) {
    final bool isActive = supplier['status'] == 'Active';
    final Color statusColor = isActive ? const Color(0xFF10B981) : Colors.grey.shade500;
    final Color statusBg = isActive
        ? const Color(0xFF10B981).withValues(alpha: 0.1)
        : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Status + Menu
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        supplier['name'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        supplier['status'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
                width: 24,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_vert, size: 20, color: Colors.black54),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, color: Colors.amber, size: 18),
                          const SizedBox(width: 8),
                          Text("Edit", style: GoogleFonts.inter(fontSize: 13)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_outlined, color: Colors.blue, size: 18),
                          const SizedBox(width: 8),
                          Text("View", style: GoogleFonts.inter(fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (val) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Detail rows
          _buildDetailRow("Short Name:", supplier['shortName'] as String),
          const SizedBox(height: 6),
          _buildDetailRow("Currency:", supplier['currency'] as String),
          const SizedBox(height: 6),
          _buildDetailRow("Credit Limit:", supplier['creditLimit'] as String),
          const SizedBox(height: 6),
          _buildDetailRow("Date Opened:", supplier['dateOpened'] as String),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────

  Widget _buildTabButton(String title, IconData icon, int index) {
    final bool isSelected = currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => currentTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.black87 : Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isSelected ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
            ],
          ),
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
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2181FF) : Colors.white,
            border: isSelected ? null : Border.all(color: Colors.grey.shade300),
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
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineCard(String title, String subtitle, String status, Color statusColor) {
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
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                color: status == "Sync Failed" ? Colors.white : statusColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _advanceFilterLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _advanceFilterDropdown({
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
          hint: Text(
            hint,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade400),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
