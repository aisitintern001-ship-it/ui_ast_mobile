import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../modals/admin_edit_expense_modal.dart';
import '../widgets/text_input.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/expandable_status_filter.dart';
import '../widgets/admin_expense_claim_card.dart';
import '../widgets/filter_tabs.dart';
import 'home_screen.dart';

/// Admin Expense Claim Screen - Can see all expense claims from team, approve/decline
class ExpenseClaimAdminScreen extends StatefulWidget {
  const ExpenseClaimAdminScreen({super.key});

  @override
  State<ExpenseClaimAdminScreen> createState() => _ExpenseClaimAdminScreenState();
}

class _ExpenseClaimAdminScreenState extends State<ExpenseClaimAdminScreen> {
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

  void _openAdminEditModal(Map<String, dynamic> claim) {
    showDialog(context: context, builder: (_) => AdminEditExpenseModal(claim: claim));
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
          icon: const Icon(LucideIcons.chevronLeft, size: 18),
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
          'Expense Claims',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildAdminView(),
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
}
