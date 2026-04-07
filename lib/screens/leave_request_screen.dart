import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/filter_tabs.dart';
import '../widgets/leave_request_card.dart';
import '../widgets/user_leave_request_card.dart';
import '../widgets/expandable_status_filter.dart';
import '../widgets/add_button_widget.dart';
import '../modals/create_member_leave_modal.dart';
import '../modals/create_leave_modal.dart';
import '../widgets/bottom_nav.dart';
import 'home_screen.dart';

/// Unified Leave Request Screen that shows different UI based on user role.
/// - Admin: Can see all requests, approve/decline, and file members' leave
/// - User: Can see their own leave requests with status history
class LeaveRequestScreen extends StatefulWidget {
  final bool fromDataIntegration;

  const LeaveRequestScreen({
    super.key,
    this.fromDataIntegration = false,
  });

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  String selectedFilter = "7";
  String? selectedStatus;

  // Status filters for Admin view
  static const List<Map<String, dynamic>> _adminLeaveStatuses = [
    {'label': 'Manager Pending', 'color': Color(0xFFF59E0B)},
    {'label': 'Manager Approved', 'color': Color(0xFF10B981)},
    {'label': 'Manager Declined', 'color': Color(0xFFEF4444)},
    {'label': 'Cancelled', 'color': Color(0xFF6B7280)},
  ];

  // Status filters for User view
  static const List<Map<String, dynamic>> _userLeaveStatuses = [
    {'label': 'Pending', 'color': Color(0xFFF59E0B)},
    {'label': 'Approved', 'color': Color(0xFF10B981)},
    {'label': 'Denied', 'color': Color(0xFFEF4444)},
    {'label': 'Cancelled', 'color': Color(0xFF6B7280)},
  ];

  // Mock data for Admin view (all team members' requests)
  final List<Map<String, dynamic>> adminRequests = [
    {
      "employeeName": "Edward Peter",
      "leaveType": "Service Incentive Leave",
      "status": "Manager Pending",
      "dateSubmitted": "Jan 23, 2026",
      "dateRange": "Jan 26 - Jan 28, 2026",
      "duration": "3 days",
      "reason": "Checkup - need to attend to my monthly health checkup that requires my immediate attention in the next two days.",
      "attachments": ["medical_cert.pdf", "hotel_reservation.jpg"],
      "color": Colors.amber,
      "pendingCount": 2,
      "approvedCount": 1,
      "declinedCount": 0,
    },
    {
      "employeeName": "Amanda Roberts",
      "leaveType": "Service Incentive Leave",
      "status": "Manager Approved",
      "dateSubmitted": "Jan 02, 2026",
      "dateRange": "Jan 07 - Jan 08, 2026",
      "duration": "2 days",
      "reason": "Checkup - need to attend to my monthly health checkup that requires my immediate attention in the next two days.",
      "attachments": [],
      "color": Colors.blue,
      "pendingCount": 0,
      "approvedCount": 2,
      "declinedCount": 0,
    },
  ];

  // Mock data for User view (personal leave requests)
  final List<Map<String, dynamic>> userRequests = [
    {
      "leaveType": "Leave Without Pay",
      "status": "Pending",
      "dateSubmitted": "Sep 28, 2025",
      "startDate": "Sep 29, 2025",
      "endDate": "Sep 30, 2025",
      "duration": "2 days",
      "reason": "Checkup - need to attend to my monthly health checkup.",
      "attachments": ["medical_cert.pdf"],
    },
    {
      "leaveType": "Service Incentive Leave",
      "status": "Approved",
      "dateSubmitted": "Sep 16, 2025",
      "startDate": "Sep 16, 2025",
      "endDate": "Sep 17, 2025",
      "duration": "2 days",
      "reason": "Personal Emergency - family matters.",
      "attachments": [],
    },
    {
      "leaveType": "Service Incentive Leave",
      "status": "Denied",
      "dateSubmitted": "Aug 10, 2025",
      "startDate": "Aug 15, 2025",
      "endDate": "Aug 16, 2025",
      "duration": "2 days",
      "reason": "Vacation - planned trip.",
      "attachments": [],
    },
  ];

  void _openCreateMemberLeaveModal() {
    showDialog(
      context: context,
      builder: (_) => const CreateMemberLeaveModal(),
    );
  }

  void _openCreateLeaveModal() {
    showDialog(
      context: context,
      builder: (_) => const CreateLeaveModal(),
    );
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
          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
          onPressed: () {
            if (widget.fromDataIntegration) {
              Navigator.pop(context);
            } else {
              context.read<AppState>().setNavIndex(1);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (Route<dynamic> route) => false,
              );
            }
          },
        ),
        title: Text(
          isAdmin ? "Leave Requests" : "My Leave Requests",
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        actions: isAdmin
            ? [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2181FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _openCreateMemberLeaveModal,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text(
                      "File Members Leave",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: isAdmin ? _buildAdminView() : _buildUserView(),
      floatingActionButton: !isAdmin
          ? AddButtonWidget(
              label: "Add Leave",
              onPressed: _openCreateLeaveModal,
            )
          : null,
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  /// Admin view - Shows all team members' leave requests with approve/decline
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
                  statuses: _adminLeaveStatuses,
                  selectedStatus: selectedStatus,
                  onChanged: (v) => setState(() => selectedStatus = v),
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

              // Admin Request List (with approve/decline)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: adminRequests.length,
                itemBuilder: (context, index) {
                  return LeaveRequestCard(request: adminRequests[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// User view - Shows personal leave requests with status history
  Widget _buildUserView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Filter section
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
                ExpandableStatusFilter(
                  statuses: _userLeaveStatuses,
                  selectedStatus: selectedStatus,
                  onChanged: (v) => setState(() => selectedStatus = v),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2181FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
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

          // User Request List (personal leave history)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: userRequests.map((request) {
                return UserLeaveRequestCard(request: request);
              }).toList(),
            ),
          ),
        ],
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
