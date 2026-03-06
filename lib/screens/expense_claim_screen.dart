import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../modals/create_expense_modal.dart';

// Assuming you saved the reusable widgets from the previous step:
// import '../widgets/custom_tab_button.dart';
// import '../widgets/filter_chip_widget.dart';
// import 'create_expense_modal.dart';

class ExpenseClaimScreen extends StatefulWidget {
  const ExpenseClaimScreen({super.key});

  @override
  State<ExpenseClaimScreen> createState() => _ExpenseClaimScreenState();
}

class _ExpenseClaimScreenState extends State<ExpenseClaimScreen> {
  int currentTab = 0; // 0 = History, 1 = Offline
  String selectedFilter = "7";

  void _openCreateModal() {
    showDialog(context: context, builder: (_) => const CreateExpenseModal(isEdit: false));
  }

  void _openEditModal() {
    showDialog(context: context, builder: (_) => const CreateExpenseModal(isEdit: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF532A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Expense Claim', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // 1. ANIMATED TAB TOGGLE
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(25)),
            child: Row(
              children: [
                _buildTabButton("History", Icons.history, 0),
                _buildTabButton("Offline", Icons.wifi_off, 1),
              ],
            ),
          ),

          // 2. TAB CONTENT
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: currentTab == 0 ? _buildHistoryTab() : _buildOfflineTab(),
            ),
          )
        ],
      ),
      
      floatingActionButton: currentTab == 0 
          ? FloatingActionButton.extended(
              onPressed: _openCreateModal,
              backgroundColor: const Color(0xFF2181FF),
              elevation: 4,
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: Text("Add Expense Claim", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
            ) 
          : null,
      
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFFEF532A),
        unselectedItemColor: Colors.grey.shade600,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Attendance"),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "Settings"),
        ],
      ),
    );
  }

  // --- TAB LAYOUTS ---

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      key: const ValueKey("history"),
      child: Column(
        children: [
          // Search & Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Records',
                    hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 13),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildFilterChip("Last 7 Days", "7"), const SizedBox(width: 8),
                    _buildFilterChip("Last 30 Days", "30"), const SizedBox(width: 8),
                    _buildFilterChip("Custom", "custom"),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 40,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt_outlined, color: Colors.grey.shade500, size: 20),
                      const SizedBox(width: 8),
                      Text("Filter by Status", style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13)),
                      const Spacer(),
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500)
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity, height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2181FF), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
                    onPressed: () {},
                    child: Text("Apply Filter", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          
          // Expense Cards List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildExpenseCard(
                  employeeName: "Edward Peter", // <-- ADDED NAME
                  category: "Transportation", status: "Manager Pending", color: Colors.amber.shade700,
                  date: "Jan 24, 2026", amount: "₱1,500.00",
                  description: "Taxi fare for client meeting at Makati office. Round trip from home office to client site for quarterly business review presentation.",
                  pending: 2, approved: 0, declined: 0,
                  attachments: ["medical_cert.pdf"],
                ),
                _buildExpenseCard(
                  employeeName: "Amanda Roberts", // <-- ADDED NAME
                  category: "Meals", status: "Manager Approved", color: Colors.blue,
                  date: "Jan 19, 2026", amount: "₱2,160.00",
                  description: "Team lunch for project kickoff meeting. Hosted lunch meeting with 5 team members to discuss Q1 project deliverables.",
                  pending: 0, approved: 2, declined: 0,
                  attachments: ["medical_cert.pdf", "sampledocs.png"],
                ),
              ],
            ),
          ),
          const SizedBox(height: 60), // Spacing for FAB
        ],
      ),
    );
  }

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
                    Text("Delete Synced Records", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildDatePicker("Date From")), const SizedBox(width: 12),
                    Expanded(child: _buildDatePicker("Date To")),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity, height: 40,
                  child: ElevatedButton.icon(
                    // ignore: deprecated_member_use
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.8), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
                    onPressed: () {}, icon: const Icon(Icons.delete_outline, size: 16), label: Text("Delete Synced Range", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
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
                        Text("Offline Records", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text("Records saved while offline, pending sync", style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 11)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                _buildOfflineCard("Lunch Meals", "₱1,500.00 • Nov 19, 2025", "Pending Sync", Colors.amber.shade700),
                _buildOfflineCard("Transportation", "₱3,000.00 • Nov 15, 2025", "Sync Failed", Colors.redAccent),
                _buildOfflineCard("General Expense", "₱2,100.00 • Nov 06, 2025", "Pending Sync", Colors.amber.shade700),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16), color: Colors.white,
          child: SizedBox(
            width: double.infinity, height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C48C), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
              onPressed: () {}, child: Text("Sync All Records", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        )
      ],
    );
  }

  // --- HELPERS ---

  Widget _buildExpenseCard({
    required String employeeName,
    required String category, required String status, required Color color, required String date, 
    required String amount, required String description, required int pending, required int approved, 
    required int declined, required List<String> attachments
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      // ignore: deprecated_member_use
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        children: [
          Container(height: 4, decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(8)))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP ROW: Employee Name, Status Pill & 3-Dot Menu
                Row(
                  children: [
                    Text(employeeName, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(20)),
                      child: Text(status, style: GoogleFonts.inter(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 24, width: 24,
                      child: PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.more_vert, size: 20, color: Colors.black87),
                        onSelected: (val) {
                          if (val == 'edit') _openEditModal();
                          if (val == 'cancel') {
                            // Cancel logic here
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'edit', child: Row(children: [const Icon(Icons.edit_outlined, color: Colors.amber, size: 18), const SizedBox(width: 8), Text("Edit", style: GoogleFonts.inter(fontSize: 13))])),
                          PopupMenuItem(value: 'cancel', child: Row(children: [const Icon(Icons.close, color: Colors.red, size: 18), const SizedBox(width: 8), Text("Cancel", style: GoogleFonts.inter(fontSize: 13))])),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                
                // SECOND ROW: Category Pill & Date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)),
                      child: Text(category, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ),
                    const Spacer(),
                    Text(date, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 12),
                
                // AMOUNT
                Text(amount, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFFEF532A))),
                const SizedBox(height: 12),
                
                // DESCRIPTION BOX
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey.shade700), const SizedBox(width: 6), Text("Description", style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12))],
                      ),
                      const SizedBox(height: 6),
                      Text(description, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade700, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                
                // PENDING / APPROVED / DECLINED PILLS
                Row(
                  children: [
                    _buildStatPill("Pending", pending, Colors.amber.shade700), const SizedBox(width: 8),
                    _buildStatPill("Approved", approved, Colors.teal), const SizedBox(width: 8),
                    _buildStatPill("Declined", declined, Colors.redAccent),
                  ],
                ),
                
                // ATTACHMENTS
                if (attachments.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(children: [Icon(Icons.attach_file, size: 14, color: Colors.grey.shade600), const SizedBox(width: 6), Text("Attachments", style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600))]),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: attachments.map((a) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(a.contains('pdf') ? Icons.picture_as_pdf : Icons.image, size: 14, color: a.contains('pdf') ? Colors.redAccent : Colors.blue),
                          const SizedBox(width: 6),
                          Text(a, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )).toList(),
                  )
                ]
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, IconData icon, int index) {
    final bool isSelected = currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => currentTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          // ignore: deprecated_member_use
          decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(25), boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : []),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.black87 : Colors.grey.shade500), const SizedBox(width: 6),
              Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: isSelected ? Colors.black87 : Colors.grey.shade500)),
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
          height: 36, alignment: Alignment.center,
          decoration: BoxDecoration(color: isSelected ? const Color(0xFF2181FF) : Colors.white, border: isSelected ? null : Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
          child: Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade700)),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String hint) {
    return Container(
      height: 40, padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500), const SizedBox(width: 8), Text(hint, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500))]),
    );
  }

  Widget _buildOfflineCard(String title, String subtitle, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: status == "Sync Failed" ? statusColor : Colors.white, border: status == "Pending Sync" ? Border.all(color: statusColor) : null, borderRadius: BorderRadius.circular(12)),
            child: Text(status, style: GoogleFonts.inter(color: status == "Sync Failed" ? Colors.white : statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildStatPill(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: color), borderRadius: BorderRadius.circular(20)),
      child: Text("$label: $count", style: GoogleFonts.inter(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}