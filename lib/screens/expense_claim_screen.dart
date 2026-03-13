import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../modals/create_expense_modal.dart';
import '../widgets/text_input.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/expandable_status_filter.dart';
import '../widgets/offline_tab_widget.dart';
import '../widgets/add_button_widget.dart'; // <-- IMPORT REUSABLE BUTTON

class ExpenseClaimScreen extends StatefulWidget {
  const ExpenseClaimScreen({super.key});

  @override
  State<ExpenseClaimScreen> createState() => _ExpenseClaimScreenState();
}

class _ExpenseClaimScreenState extends State<ExpenseClaimScreen> {
  int currentTab = 0;
  String selectedFilter = "7";
  String? selectedStatus;

  static const List<Map<String, dynamic>> _expenseStatuses = [
    {'label': 'Mngr. Pending', 'color': Color(0xFFF59E0B)},
    {'label': 'Mngr. Approved', 'color': Color(0xFF2181FF)},
    {'label': 'Mngr. Declined', 'color': Color(0xFFEF4444)},
    {'label': 'Pending Finance', 'color': Color(0xFF8B5CF6)},
    {'label': 'Finance Declined', 'color': Color(0xFFEF4444)},
    {'label': 'Waiting Payment', 'color': Color(0xFFF97316)},
    {'label': 'Paid by Finance', 'color': Color(0xFF10B981)},
  ];

  void _openCreateModal() {
    showDialog(context: context, builder: (_) => const CreateExpenseModal(isEdit: false));
  }

  void _openEditModal() {
    showDialog(context: context, builder: (_) => const CreateExpenseModal(isEdit: true));
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
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context)),
        title: Text('Expense Claim', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(25)),
            child: Row(
              children: [ _buildTabButton("History", Icons.history, 0), _buildTabButton("Offline", Icons.wifi_off, 1) ],
            ),
          ),
          Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: currentTab == 0 ? _buildHistoryTab() : _buildOfflineTab()))
        ],
      ),
      // --- USE REUSABLE BUTTON HERE ---
      floatingActionButton: currentTab == 0 
          ? AddButtonWidget(
              label: "Add Expense Claim",
              onPressed: _openCreateModal,
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
                ExpandableStatusFilter(statuses: _expenseStatuses, selectedStatus: selectedStatus, onChanged: (v) => setState(() => selectedStatus = v), placeholder: 'Filter by Status'),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, height: 40, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2181FF), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0), onPressed: () {}, child: Text("Apply Filter", style: GoogleFonts.inter(fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildExpenseCard(employeeName: "Edward Peter", category: "Transportation", status: "Manager Pending", color: Colors.amber.shade700, date: "Jan 24, 2026", amount: "₱1,500.00", description: "Taxi fare for client meeting at Makati office.", pending: 2, approved: 0, declined: 0, attachments: ["medical_cert.pdf"]),
                _buildExpenseCard(employeeName: "Amanda Roberts", category: "Meals", status: "Manager Approved", color: Colors.blue, date: "Jan 19, 2026", amount: "₱2,160.00", description: "Team lunch for project kickoff meeting.", pending: 0, approved: 2, declined: 0, attachments: ["medical_cert.pdf", "sampledocs.png"]),
              ],
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
        OfflineRecordItem(title: "Lunch Meals", subtitle: "₱1,500.00 • Nov 19, 2025", status: "Pending Sync", statusColor: Colors.amber.shade700),
        OfflineRecordItem(title: "Transportation", subtitle: "₱3,000.00 • Nov 15, 2025", status: "Sync Failed", statusColor: Colors.redAccent),
        OfflineRecordItem(title: "General Expense", subtitle: "₱2,100.00 • Nov 06, 2025", status: "Pending Sync", statusColor: Colors.amber.shade700),
      ],
      onSyncAll: () {},
      onDeleteRange: () {},
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

  Widget _buildExpenseCard({ required String employeeName, required String category, required String status, required Color color, required String date, required String amount, required String description, required int pending, required int approved, required int declined, required List<String> attachments }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        children: [
          Container(height: 4, decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(8)))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(employeeName, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87), overflow: TextOverflow.ellipsis)), const SizedBox(width: 8),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(20)), child: Text(status, style: GoogleFonts.inter(color: color, fontSize: 10, fontWeight: FontWeight.bold))), const Spacer(),
                    SizedBox(height: 24, width: 24, child: PopupMenuButton<String>(padding: EdgeInsets.zero, icon: const Icon(Icons.more_vert, size: 20, color: Colors.black87), onSelected: (val) { if (val == 'edit') _openEditModal(); }, itemBuilder: (context) => [ PopupMenuItem(value: 'edit', child: Row(children: [const Icon(Icons.edit_outlined, color: Colors.amber, size: 18), const SizedBox(width: 8), Text("Edit", style: GoogleFonts.inter(fontSize: 13))])), PopupMenuItem(value: 'cancel', child: Row(children: [const Icon(Icons.close, color: Colors.red, size: 18), const SizedBox(width: 8), Text("Cancel", style: GoogleFonts.inter(fontSize: 13))]))]))
                  ],
                ),
                const SizedBox(height: 12),
                Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)), child: Text(category, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87))), const Spacer(), Text(date, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 11))]), const SizedBox(height: 12),
                Text(amount, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFFEF532A))), const SizedBox(height: 12),
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey.shade700), const SizedBox(width: 6), Text("Description", style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12))]), const SizedBox(height: 6), Text(description, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade700, height: 1.4))])), const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: [_buildStatPill("Pending", pending, Colors.amber.shade700), _buildStatPill("Approved", approved, Colors.teal), _buildStatPill("Declined", declined, Colors.redAccent)]),
                if (attachments.isNotEmpty) ...[
                  const SizedBox(height: 16), Row(children: [Icon(Icons.attach_file, size: 14, color: Colors.grey.shade600), const SizedBox(width: 6), Text("Attachments", style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600))]), const SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 8, children: attachments.map((a) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(a.contains('pdf') ? Icons.picture_as_pdf : Icons.image, size: 14, color: a.contains('pdf') ? Colors.redAccent : Colors.blue), const SizedBox(width: 6), Text(a, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500))]))).toList())
                ]
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatPill(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: color), borderRadius: BorderRadius.circular(20)),
      child: Text("$label: $count", style: GoogleFonts.inter(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}