import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/filter_tabs.dart';
import '../widgets/leave_request_card.dart';
import '../widgets/expandable_status_filter.dart';
import '../modals/create_member_leave_modal.dart';
import '../widgets/bottom_nav.dart';
import 'home_screen.dart';

/// Admin Leave Request Screen - Can see all requests, approve/decline, and file members' leave
class LeaveRequestAdminScreen extends StatefulWidget {
  final bool fromDataIntegration;

  const LeaveRequestAdminScreen({
    super.key,
    this.fromDataIntegration = false,
  });

  @override
  State<LeaveRequestAdminScreen> createState() => _LeaveRequestAdminScreenState();
}

class _LeaveRequestAdminScreenState extends State<LeaveRequestAdminScreen> {
  String selectedFilter = "7";
  String? selectedStatus;

  // Status filters for Admin view
  static const List<Map<String, dynamic>> _adminLeaveStatuses = [
    {'label': 'Manager Pending', 'color': Color(0xFFF59E0B)},
    {'label': 'Manager Approved', 'color': Color(0xFF10B981)},
    {'label': 'Manager Declined', 'color': Color(0xFFEF4444)},
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

  void _openCreateMemberLeaveModal() {
    showDialog(
      context: context,
      builder: (_) => const CreateMemberLeaveModal(),
    );
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
          "Leave Requests",
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        actions: [
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
        ],
      ),
      body: _buildAdminView(),
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
}
