import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../modals/create_expense_modal.dart';
import '../widgets/text_input.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/expandable_status_filter.dart';
import '../widgets/offline_tab_widget.dart';
import '../widgets/add_button_widget.dart';
import '../widgets/history_offline_tabs.dart';
import '../widgets/user_expense_claim_card.dart';
import '../widgets/filter_tabs.dart';
import 'home_screen.dart';

/// Employee Expense Claim Screen - Can see their own expense claims with status history
class ExpenseClaimEmployeeScreen extends StatefulWidget {
  const ExpenseClaimEmployeeScreen({super.key});

  @override
  State<ExpenseClaimEmployeeScreen> createState() => _ExpenseClaimEmployeeScreenState();
}

class _ExpenseClaimEmployeeScreenState extends State<ExpenseClaimEmployeeScreen> {
  int currentTab = 0;
  String selectedFilter = "7";
  String? selectedStatus;

  // Status filters for User view
  static const List<Map<String, dynamic>> _userExpenseStatuses = [
    {'label': 'Pending', 'color': Color(0xFFF59E0B)},
    {'label': 'Approved', 'color': Color(0xFF10B981)},
    {'label': 'Declined', 'color': Color(0xFFEF4444)},
    {'label': 'Paid', 'color': Color(0xFF10B981)},
    {'label': 'Cancelled', 'color': Color(0xFF6B7280)},
  ];

  // Mock data for User view (personal expense claims)
  final List<Map<String, dynamic>> userClaims = [
    {
      "category": "Transportation",
      "status": "Pending",
      "dateSubmitted": "Jan 24, 2026",
      "amount": "₱1,500.00",
      "description": "Taxi fare for client meeting at Makati office.",
      "attachments": ["receipt.pdf"],
    },
    {
      "category": "Meals",
      "status": "Approved",
      "dateSubmitted": "Jan 10, 2026",
      "amount": "₱850.00",
      "description": "Client lunch meeting.",
      "attachments": [],
    },
    {
      "category": "Office Supplies",
      "status": "Paid",
      "dateSubmitted": "Dec 15, 2025",
      "amount": "₱2,300.00",
      "description": "Office supplies for the team.",
      "attachments": ["receipt.jpg"],
    },
  ];

  void _openCreateModal() {
    showDialog(context: context, builder: (_) => const CreateExpenseModal(isEdit: false));
  }

  void _openEditModal() {
    showDialog(context: context, builder: (_) => const CreateExpenseModal(isEdit: true));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final headerColor = appState.headerColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: headerColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () {
            context.read<AppState>().setNavIndex(1);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Text(
          'My Expense Claims',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildUserView(),
      floatingActionButton: currentTab == 0
          ? AddButtonWidget(
              label: "Add Expense Claim",
              onPressed: _openCreateModal,
            )
          : null,
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  /// User view - Shows personal expense claims with status history
  Widget _buildUserView() {
    return Column(
      children: [
        // Tabs for History / Offline
        Padding(
          padding: const EdgeInsets.all(16),
          child: HistoryOfflineTabs(
            showHistory: currentTab == 0,
            onChanged: (val) => setState(() => currentTab = val ? 0 : 1),
            backgroundColor: Colors.grey.shade200,
            activeColor: Colors.white,
            inactiveColor: Colors.transparent,
            borderRadius: 25,
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: currentTab == 0 ? _buildUserHistoryTab() : _buildOfflineTab(),
          ),
        ),
      ],
    );
  }

  Widget _buildUserHistoryTab() {
    return SingleChildScrollView(
      key: const ValueKey("history"),
      child: Column(
        children: [
          // Filter section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppTextInput(
                  hintText: 'Search Records',
                  hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(height: 16),
                FilterTabs(
                  selected: selectedFilter,
                  onChanged: (value) => setState(() => selectedFilter = value),
                ),
                const SizedBox(height: 12),
                ExpandableStatusFilter(
                  statuses: _userExpenseStatuses,
                  selectedStatus: selectedStatus,
                  onChanged: (v) => setState(() => selectedStatus = v),
                  placeholder: 'Filter by Status',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2181FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
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

          // User Expense Claim List (personal claims without approve/decline)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: userClaims.map((claim) {
                return UserExpenseClaimCard(
                  claim: claim,
                  onEdit: _openEditModal,
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
        OfflineRecordItem(
          title: "Lunch Meals",
          subtitle: "₱1,500.00 • Nov 19, 2025",
          status: "Pending Sync",
          statusColor: Colors.amber.shade700,
        ),
        OfflineRecordItem(
          title: "Transportation",
          subtitle: "₱3,000.00 • Nov 15, 2025",
          status: "Sync Failed",
          statusColor: Colors.redAccent,
        ),
        OfflineRecordItem(
          title: "General Expense",
          subtitle: "₱2,100.00 • Nov 06, 2025",
          status: "Pending Sync",
          statusColor: Colors.amber.shade700,
        ),
      ],
      onSyncAll: () {},
      onDeleteRange: () {},
    );
  }

}
