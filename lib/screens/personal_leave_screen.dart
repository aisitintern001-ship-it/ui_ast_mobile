import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/expandable_status_filter.dart';
import '../widgets/offline_tab_widget.dart';
import '../widgets/add_button_widget.dart'; // <-- IMPORT REUSABLE BUTTON
import '../modals/edit_leave_modal.dart';
import '../modals/create_leave_modal.dart';
import 'home_screen.dart'; 

class PersonalLeaveScreen extends StatefulWidget {
  final int initialTab;
  final bool fromDataIntegration;

  const PersonalLeaveScreen({
    super.key, 
    this.initialTab = 0,
    this.fromDataIntegration = false,
  });

  @override
  State<PersonalLeaveScreen> createState() => _PersonalLeaveScreenState();
}

class _PersonalLeaveScreenState extends State<PersonalLeaveScreen> {
  late int currentTab;
  String selectedFilter = "7";
  String? selectedStatus;

  static const List<Map<String, dynamic>> _leaveStatuses = [
    {'label': 'Pending', 'color': Color(0xFFF59E0B)},
    {'label': 'Approved', 'color': Color(0xFF10B981)},
    {'label': 'Denied', 'color': Color(0xFFEF4444)},
    {'label': 'Cancelled', 'color': Color(0xFF6B7280)},
  ];

  @override
  void initState() {
    super.initState();
    currentTab = widget.initialTab;
  }

  void _openCreateModal() {
    showDialog(context: context, builder: (_) => const CreateLeaveModal());
  }

  void _openEditModal() {
    showDialog(context: context, builder: (_) => const EditLeaveModal());
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
          onPressed: () {
            if (widget.fromDataIntegration) {
              Navigator.pop(context);
            } else {
              context.read<AppState>().setNavIndex(1); 
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
            }
          },
        ),
        title: Text('Leave Records', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
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
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: currentTab == 0 ? _buildHistoryTab() : _buildOfflineTab(),
            ),
          )
        ],
      ),
      // --- USE REUSABLE BUTTON HERE ---
      floatingActionButton: currentTab == 0 
          ? AddButtonWidget(
              label: "Add Leave",
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
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildFilterChip("Last 7 Days", "7"), const SizedBox(width: 8),
                    _buildFilterChip("Last 30 Days", "30"), const SizedBox(width: 8),
                    _buildFilterChip("Custom", "custom"),
                  ],
                ),
                const SizedBox(height: 12),
                ExpandableStatusFilter(
                  statuses: _leaveStatuses,
                  selectedStatus: selectedStatus,
                  onChanged: (v) => setState(() => selectedStatus = v),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2181FF), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 10)),
                    onPressed: () {},
                    child: Text("Apply Filter", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLeaveCard(type: "Leave Without Pay", status: "Pending", color: Colors.amber.shade700, submitted: "Sep 28, 2025", start: "Sep 29, 2025", end: "Sep 30, 2025", reason: "Checkup - need to attend to my monthly health checkup.", pending: 2, approved: 0, declined: 0, hasAttachment: true),
                _buildLeaveCard(type: "Service Incentive Leave", status: "Approved", color: Colors.teal, submitted: "Sep 16, 2025", start: "Sep 16, 2025", end: "Sep 17, 2025", reason: "Personal Emergency - family matters.", pending: 0, approved: 2, declined: 0, hasAttachment: false),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOfflineTab() {
    return OfflineTabWidget(
      key: const ValueKey("offline"),
      items: [
        OfflineRecordItem(title: "Leave Without Pay", subtitle: "Sep 29 - Sep 30, 2025", status: "Pending Sync", statusColor: Colors.amber.shade700),
        OfflineRecordItem(title: "Service Incentive Leave", subtitle: "Sep 16 - Sep 17, 2025", status: "Pending Sync", statusColor: Colors.amber.shade700),
        OfflineRecordItem(title: "Leave Without Pay", subtitle: "Feb 12 - Feb 12, 2025", status: "Sync Failed", statusColor: Colors.redAccent),
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(25), boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))] : []),
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
          height: 36, constraints: const BoxConstraints(minHeight: 36), alignment: Alignment.center,
          decoration: BoxDecoration(color: isSelected ? const Color(0xFF2181FF) : Colors.white, border: isSelected ? null : Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
          child: Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade700)),
        ),
      ),
    );
  }

  Widget _buildLeaveCard({ required String type, required String status, required Color color, required String submitted, required String start, required String end, required String reason, required int pending, required int approved, required int declined, required bool hasAttachment }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
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
                    Expanded(child: Row(children: [ Flexible(child: Text(type, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14))), const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(12)), child: Text(status, style: GoogleFonts.inter(color: color, fontSize: 10, fontWeight: FontWeight.bold))) ])),
                    SizedBox(
                      height: 24, width: 24,
                      child: PopupMenuButton<String>(
                        padding: EdgeInsets.zero, icon: const Icon(Icons.more_vert, size: 20, color: Colors.black87), onSelected: (val) { if (val == 'edit') _openEditModal(); },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'edit', child: Row(children: [const Icon(Icons.edit_outlined, color: Colors.amber, size: 18), const SizedBox(width: 8), Text("Edit", style: GoogleFonts.inter(fontSize: 13))])),
                          PopupMenuItem(value: 'cancel', child: Row(children: [const Icon(Icons.close, color: Colors.red, size: 18), const SizedBox(width: 8), Text("Cancel", style: GoogleFonts.inter(fontSize: 13))])),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                _buildDateRow(Icons.calendar_today, "Date Submitted: ", submitted), const SizedBox(height: 4),
                _buildDateRow(Icons.calendar_month, "Start: ", start), const SizedBox(height: 4),
                _buildDateRow(Icons.calendar_month, "End: ", end), const SizedBox(height: 12),
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Row(children: [Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey.shade700), const SizedBox(width: 6), Text("Reason", style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12))]), const SizedBox(height: 6), Text(reason, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade700, height: 1.4)) ])), const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: [ _buildStatPill("Pending", pending, Colors.amber.shade700), _buildStatPill("Approved", approved, Colors.teal), _buildStatPill("Declined", declined, Colors.redAccent) ]),
                if (hasAttachment) ...[
                  const SizedBox(height: 16), const Divider(), const SizedBox(height: 8),
                  Row(children: [Icon(Icons.attach_file, size: 14, color: Colors.grey.shade600), const SizedBox(width: 6), Text("Attachments", style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600))]), const SizedBox(height: 8),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.picture_as_pdf, size: 14, color: Colors.redAccent), const SizedBox(width: 6), Text("medical_cert.pdf", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500))]))
                ]
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDateRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500), const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12)),
        Flexible(child: Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12), overflow: TextOverflow.ellipsis)),
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