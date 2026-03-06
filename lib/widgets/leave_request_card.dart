import 'package:flutter/material.dart';

class LeaveRequestCard extends StatefulWidget {
  final Map<String, dynamic> request;

  const LeaveRequestCard({super.key, required this.request});

  @override
  State<LeaveRequestCard> createState() => _LeaveRequestCardState();
}

class _LeaveRequestCardState extends State<LeaveRequestCard> {
  bool expanded = false;

  Widget _buildStatPill(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$label: $count",
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.request;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          // ignore: deprecated_member_use
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Colored Border
          Container(height: 4, decoration: BoxDecoration(color: r['color'], borderRadius: const BorderRadius.vertical(top: Radius.circular(8)))),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r['employeeName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: r['color']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(r['status'], style: TextStyle(color: r['color'], fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(r['leaveType'], style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                const SizedBox(height: 12),
                
                // Dates
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text("Date Submitted: ", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    Text(r['dateSubmitted'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 14, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text("Period: ", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    Text(r['dateRange'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                      child: Text(r['duration'], style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                    )
                  ],
                ),
                const SizedBox(height: 12),

                // Stat Pills
                Row(
                  children: [
                    _buildStatPill("Pending", r['pendingCount'], Colors.amber.shade700),
                    const SizedBox(width: 8),
                    _buildStatPill("Approved", r['approvedCount'], Colors.teal),
                    const SizedBox(width: 8),
                    _buildStatPill("Declined", r['declinedCount'], Colors.redAccent),
                  ],
                ),
                const SizedBox(height: 16),

                // Reason Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey.shade700),
                          const SizedBox(width: 8),
                          const Text("Reason", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(r['reason'], style: TextStyle(fontSize: 12, color: Colors.grey.shade800, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // View Details Accordion
                GestureDetector(
                  onTap: () => setState(() => expanded = !expanded),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(color: expanded ? Colors.white : const Color(0xFFEAF2FF), border: expanded ? Border.all(color: Colors.grey.shade300) : null, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade700),
                            const SizedBox(width: 8),
                            Text("View Per Day Leave (${r['duration']})", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
                          ],
                        ),
                        Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey.shade600)
                      ],
                    ),
                  ),
                ),

                // Expanded content (The Breakdown & Action Buttons)
                if (expanded) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("LEAVE DAYS BREAKDOWN", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 12),
                        // Example mock item inside breakdown
                        Container(
                          padding: const EdgeInsets.all(12),
                          // ignore: deprecated_member_use
                          decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), border: Border.all(color: Colors.amber), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Friday, Dec 26, 2025", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: const Text("Full Day", style: TextStyle(fontSize: 9))),
                                      const SizedBox(width: 6),
                                      // ignore: deprecated_member_use
                                      Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: const Text("Pending", style: TextStyle(fontSize: 9, color: Colors.amber))),
                                      const SizedBox(width: 6),
                                      const Text("8:00 AM - 5:00 PM", style: TextStyle(fontSize: 9, color: Colors.grey)),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  // ignore: deprecated_member_use
                                  Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.check, size: 14, color: Colors.teal)),
                                  const SizedBox(width: 8),
                                  // ignore: deprecated_member_use
                                  Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.close, size: 14, color: Colors.red)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, elevation: 0),
                          onPressed: () {},
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text("Approve All"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, elevation: 0),
                          onPressed: () {},
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text("Deny All"),
                        ),
                      )
                    ],
                  )
                ]
              ],
            ),
          )
        ],
      ),
    );
  }
}