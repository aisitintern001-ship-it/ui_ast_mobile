import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/user_leave_request_card.dart';
import '../widgets/expandable_status_filter.dart';
import '../widgets/add_button_widget.dart';
import '../modals/create_leave_modal.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/filter_tabs.dart';
import 'home_screen.dart';

/// Employee Leave Request Screen - Can see their own leave requests with status history
class LeaveRequestEmployeeScreen extends StatefulWidget {
  final bool fromDataIntegration;

  const LeaveRequestEmployeeScreen({
    super.key,
    this.fromDataIntegration = false,
  });

  @override
  State<LeaveRequestEmployeeScreen> createState() => _LeaveRequestEmployeeScreenState();
}

class _LeaveRequestEmployeeScreenState extends State<LeaveRequestEmployeeScreen> {
  String selectedFilter = "7";
  String? selectedStatus;

  // Status filters for User view
  static const List<Map<String, dynamic>> _userLeaveStatuses = [
    {'label': 'Pending', 'color': Color(0xFFF59E0B)},
    {'label': 'Approved', 'color': Color(0xFF10B981)},
    {'label': 'Denied', 'color': Color(0xFFEF4444)},
    {'label': 'Cancelled', 'color': Color(0xFF6B7280)},
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
          "My Leave Requests",
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildUserView(),
      floatingActionButton: AddButtonWidget(
        label: "Add Leave",
        onPressed: _openCreateLeaveModal,
      ),
      bottomNavigationBar: const AppBottomNavBar(),
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
                FilterTabs(
                  selected: selectedFilter,
                  onChanged: (value) => setState(() => selectedFilter = value),
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

}
