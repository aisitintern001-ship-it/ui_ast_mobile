import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/bottom_nav.dart';
import '../modals/edit_leave_modal.dart';
import '../modals/create_leave_modal.dart';

class PersonalLeaveScreen extends StatefulWidget {
  const PersonalLeaveScreen({super.key});

  @override
  State<PersonalLeaveScreen> createState() => _PersonalLeaveScreenState();
}

class _PersonalLeaveScreenState extends State<PersonalLeaveScreen> {
  // 0 = History, 1 = Offline
  int currentTab = 0;
  String selectedFilter = "7";
  bool isStatusFilterExpanded = false;
  String? selectedStatus;

  static const List<Map<String, dynamic>> _leaveStatuses = [
    {'label': 'Pending', 'color': Color(0xFFF59E0B)},
    {'label': 'Approved', 'color': Color(0xFF10B981)},
    {'label': 'Denied', 'color': Color(0xFFEF4444)},
    {'label': 'Cancelled', 'color': Color(0xFF6B7280)},
  ];

  void _openCreateModal() {
    showDialog(
      context: context,
      builder: (_) => const CreateLeaveModal(),
    );
  }

  void _openEditModal() {
    showDialog(
      context: context,
      builder: (_) => const EditLeaveModal(),
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
        title: Text('Leave Records', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // 1. ANIMATED TAB TOGGLE (History / Offline)
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
      
      // Floating Action Button (Only visible on History Tab)
      floatingActionButton: currentTab == 0 
          ? FloatingActionButton.extended(
              onPressed: _openCreateModal,
              backgroundColor: const Color(0xFF2181FF),
              elevation: 4,
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: Text("Add Leave", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
            ) 
          : null,
      
      // Bottom Navigation Bar (Matches Team Leave)
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  // --- TAB CONTENT BUILDERS ---

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      key: const ValueKey("history"),
      child: Column(
        children: [
          // Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
                GestureDetector(
                  onTap: () => setState(() => isStatusFilterExpanded = !isStatusFilterExpanded),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(Icons.filter_alt_outlined, color: Colors.grey.shade500, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          selectedStatus ?? "Filter Status",
                          style: GoogleFonts.inter(color: selectedStatus != null ? Colors.black87 : Colors.grey.shade600, fontSize: 13),
                        ),
                        const Spacer(),
                        AnimatedRotation(
                          turns: isStatusFilterExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: _leaveStatuses.map((s) {
                        final bool isSelected = selectedStatus == s['label'];
                        return InkWell(
                          onTap: () => setState(() {
                            selectedStatus = isSelected ? null : s['label'] as String;
                          }),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 20, height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: isSelected ? const Color(0xFF2181FF) : Colors.grey.shade400, width: 2),
                                  ),
                                  child: isSelected
                                      ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2181FF))))
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: s['color'] as Color)),
                                const SizedBox(width: 8),
                                Text(s['label'] as String, style: GoogleFonts.inter(fontSize: 13, color: Colors.black87)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  crossFadeState: isStatusFilterExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2181FF), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
                    onPressed: () {},
                    child: Text("Apply Filter", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          
          // Leave Cards List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLeaveCard(
                  type: "Leave Without Pay",
                  status: "Pending",
                  color: Colors.amber.shade700,
                  submitted: "Sep 28, 2025",
                  start: "Sep 29, 2025", end: "Sep 30, 2025",
                  reason: "Checkup - need to attend to my monthly health checkup that requires my immediate attention in the next two days.",
                  pending: 2, approved: 0, declined: 0,
                  hasAttachment: true,
                ),
                _buildLeaveCard(
                  type: "Service Incentive Leave",
                  status: "Approved",
                  color: Colors.teal,
                  submitted: "Sep 16, 2025",
                  start: "Sep 16, 2025", end: "Sep 17, 2025",
                  reason: "Personal Emergency - need to attend to family matters that requires my immediate attention in the next two days.",
                  pending: 0, approved: 2, declined: 0,
                  hasAttachment: false,
                ),
              ],
            ),
          )
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
                // Delete Synced Records Section
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
                    // ignore: deprecated_member_use
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.8), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: Text("Delete Synced Range", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Offline Records List
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
                _buildOfflineCard("Leave Without Pay", "Sep 29 - Sep 30, 2025", "Pending Sync", Colors.amber.shade700),
                _buildOfflineCard("Service Incentive Leave", "Sep 16 - Sep 17, 2025", "Pending Sync", Colors.amber.shade700),
                _buildOfflineCard("Leave Without Pay", "Feb 12 - Feb 12, 2025", "Sync Failed", Colors.redAccent),
              ],
            ),
          ),
        ),
        // Sync All Button docked at the bottom of the tab
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C48C), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
              onPressed: () {},
              child: Text("Sync All Records", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        )
      ],
    );
  }


  // --- REUSABLE COMPONENTS ---

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
            // ignore: deprecated_member_use
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.black87 : Colors.grey.shade500),
              const SizedBox(width: 6),
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
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2181FF) : Colors.white,
            border: isSelected ? null : Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade700)),
        ),
      ),
    );
  }

  Widget _buildLeaveCard({
    required String type, required String status, required Color color, 
    required String submitted, required String start, required String end, 
    required String reason, required int pending, required int approved, 
    required int declined, required bool hasAttachment
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(type, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(12)),
                            child: Text(status, style: GoogleFonts.inter(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    // 3-DOT MENU WITH EDIT & CANCEL
                    SizedBox(
                      height: 24, width: 24,
                      child: PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.more_vert, size: 20, color: Colors.black87),
                        onSelected: (val) {
                          if (val == 'edit') _openEditModal();
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
                _buildDateRow(Icons.calendar_today, "Date Submitted: ", submitted),
                const SizedBox(height: 4),
                _buildDateRow(Icons.calendar_month, "Start: ", start),
                const SizedBox(height: 4),
                _buildDateRow(Icons.calendar_month, "End: ", end),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey.shade700),
                          const SizedBox(width: 6),
                          Text("Reason", style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(reason, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade700, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatPill("Pending", pending, Colors.amber.shade700),
                    const SizedBox(width: 8),
                    _buildStatPill("Approved", approved, Colors.teal),
                    const SizedBox(width: 8),
                    _buildStatPill("Declined", declined, Colors.redAccent),
                  ],
                ),
                if (hasAttachment) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.attach_file, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text("Attachments", style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.picture_as_pdf, size: 14, color: Colors.redAccent),
                        const SizedBox(width: 6),
                        Text("medical_cert.pdf", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )
                ]
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOfflineCard(String title, String period, String status, Color statusColor) {
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
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text("Period: ", style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500)),
                  Text(period, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
                ],
              )
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

  Widget _buildDatePicker(String hint) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Text(hint, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildDateRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12)),
        Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12)),
      ],
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