import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../modals/create_expense_modal.dart';
import '../modals/admin_edit_expense_modal.dart';
import '../widgets/text_input.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/expandable_status_filter.dart';
import '../widgets/offline_tab_widget.dart';
import '../widgets/add_button_widget.dart';
import '../widgets/history_offline_tabs.dart';
import '../widgets/admin_expense_claim_card.dart';
import '../widgets/user_expense_claim_card.dart';
import '../widgets/filter_tabs.dart';
import 'home_screen.dart';

/// Unified Expense Claim Screen that shows different UI based on user role.
/// - Admin: Can see all expense claims from team, approve/decline
/// - User: Can see their own expense claims with status history
class ExpenseClaimScreen extends StatefulWidget {
  const ExpenseClaimScreen({super.key});

  @override
  State<ExpenseClaimScreen> createState() => _ExpenseClaimScreenState();
}

class _ExpenseClaimScreenState extends State<ExpenseClaimScreen> {
  int currentTab = 0;
  String selectedFilter = "7";
  String? selectedStatus;

  // Status filters for Admin view
  static const List<Map<String, dynamic>> _adminExpenseStatuses = [
    {'label': 'Mngr. Pending', 'color': Color(0xFFF59E0B)},
    {'label': 'Mngr. Approved', 'color': Color(0xFF2181FF)},
    {'label': 'Mngr. Declined', 'color': Color(0xFFEF4444)},
    {'label': 'Pending Finance', 'color': Color(0xFF8B5CF6)},
    {'label': 'Finance Declined', 'color': Color(0xFFEF4444)},
    {'label': 'Waiting Payment', 'color': Color(0xFFF97316)},
    {'label': 'Paid by Finance', 'color': Color(0xFF10B981)},
  ];

  // Status filters for User view
  static const List<Map<String, dynamic>> _userExpenseStatuses = [
    {'label': 'Pending', 'color': Color(0xFFF59E0B)},
    {'label': 'Approved', 'color': Color(0xFF10B981)},
    {'label': 'Declined', 'color': Color(0xFFEF4444)},
    {'label': 'Paid', 'color': Color(0xFF10B981)},
    {'label': 'Cancelled', 'color': Color(0xFF6B7280)},
  ];

  // Mock data for Admin view (all team members' expense claims)
  final List<Map<String, dynamic>> adminClaims = [
    {
      "employeeName": "Edward Peter",
      "category": "Transportation",
      "status": "Manager Pending",
      "date": "Jan 24, 2026",
      "amount": "₱1,500.00",
      "description": "Taxi fare for client meeting at Makati office.",
      "attachments": ["medical_cert.pdf"],
      "pending": 2,
      "approved": 0,
      "declined": 0,
    },
    {
      "employeeName": "Amanda Roberts",
      "category": "Meals",
      "status": "Manager Approved",
      "date": "Jan 19, 2026",
      "amount": "₱2,160.00",
      "description": "Team lunch for project kickoff meeting.",
      "attachments": ["medical_cert.pdf", "sampledocs.png"],
      "pending": 0,
      "approved": 2,
      "declined": 0,
    },
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

  void _openAdminEditModal(Map<String, dynamic> claim) {
    showDialog(context: context, builder: (_) => AdminEditExpenseModal(claim: claim));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final headerColor = appState.headerColor;
    final isAdmin = appState.isAdmin;

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
          isAdmin ? 'Expense Claims' : 'My Expense Claims',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: isAdmin ? _buildAdminView() : _buildUserView(),
      floatingActionButton: !isAdmin && currentTab == 0
          ? AddButtonWidget(
              label: "Add Expense Claim",
              onPressed: _openCreateModal,
            )
          : null,
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  /// Admin view - Shows all team members' expense claims with approve/decline
  Widget _buildAdminView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Search input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppTextInput(
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
              ),
              const SizedBox(height: 16),

              // Filter Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilterTabs(
                  selected: selectedFilter,
                  onChanged: (value) => setState(() => selectedFilter = value),
                ),
              ),
              const SizedBox(height: 12),

              // Status Filter Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ExpandableStatusFilter(
                  statuses: _adminExpenseStatuses,
                  selectedStatus: selectedStatus,
                  onChanged: (v) => setState(() => selectedStatus = v),
                  placeholder: 'Filter by Status',
                ),
              ),
              const SizedBox(height: 12),

              // Apply Filter Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
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
              ),
              const SizedBox(height: 20),

              // Admin Expense Claim List (with approve/decline)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: adminClaims.length,
                itemBuilder: (context, index) {
                  final claim = adminClaims[index];
                  return AdminExpenseClaimCard(
                    claim: claim,
                    onEdit: () => _openAdminEditModal(claim),
                    onApprove: () {
                      // Handle approve
                    },
                    onDecline: () {
                      // Handle decline
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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

  Widget _buildFilterChip(String label, String value) {
    bool isSelected = selectedFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedFilter = value),
        child: Container(
          constraints: const BoxConstraints(minHeight: 36),
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
}
