import 'package:flutter/material.dart';
import '../widgets/filter_tabs.dart';
import '../widgets/leave_request_card.dart';
import '../modals/create_member_leave_modal.dart';
import 'personal_leave_screen.dart';
// Replace with your actual model import
// import '../models/leave_request.dart';

class TeamLeaveRequestsScreen extends StatefulWidget {
  const TeamLeaveRequestsScreen({super.key});

  @override
  State<TeamLeaveRequestsScreen> createState() =>
      _TeamLeaveRequestsScreenState();
}

class _TeamLeaveRequestsScreenState extends State<TeamLeaveRequestsScreen> {
  String selectedFilter = "7";

  // Mocking the request to match the UI
  final List<Map<String, dynamic>> requests = [
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
    }
  ];

 void openCreateModal() {
    showDialog( // <-- Changed to showDialog
      context: context,
      builder: (_) => const CreateMemberLeaveModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF532A),
        foregroundColor: Colors.white,
        elevation: 0,
        // --- UPDATED LEADING PROPERTY ---
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // --------------------------------
        title: const Text("Team Leave Requests", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2181FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              onPressed: openCreateModal,
              icon: const Icon(Icons.add, size: 16),
              label: const Text("File Members Leave", style: TextStyle(fontSize: 12)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // FILTER TABS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilterTabs(
                    selected: selectedFilter,
                    onChanged: (value) => setState(() => selectedFilter = value),
                  ),
                ),
                const SizedBox(height: 12),
                
                // FILTER DROPDOWN
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(Icons.filter_alt_outlined, color: Colors.grey.shade500, size: 20),
                        const SizedBox(width: 8),
                        Text("Filter Status", style: TextStyle(color: Colors.grey.shade600)),
                        const Spacer(),
                        Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // APPLY FILTER BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2181FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: const Text("Apply Filter", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // REQUEST LIST
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return LeaveRequestCard(request: requests[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
}