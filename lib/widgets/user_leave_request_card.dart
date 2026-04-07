import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A leave request card for regular users (non-admin).
/// Shows leave status and history without approve/decline functionality.
class UserLeaveRequestCard extends StatefulWidget {
  final Map<String, dynamic> request;

  const UserLeaveRequestCard({super.key, required this.request});

  @override
  State<UserLeaveRequestCard> createState() => _UserLeaveRequestCardState();
}

class _UserLeaveRequestCardState extends State<UserLeaveRequestCard> {
  bool expanded = false;

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'approved':
        return const Color(0xFF10B981);
      case 'denied':
      case 'declined':
        return const Color(0xFFEF4444);
      case 'cancelled':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.request;
    final statusColor = _getStatusColor(r['status'] ?? 'Pending');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Colored Border
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with leave type and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              r['leaveType'] ?? 'Leave Request',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: statusColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              r['status'] ?? 'Pending',
                              style: GoogleFonts.inter(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Menu for edit/cancel
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.more_vert, size: 20, color: Colors.black87),
                        onSelected: (val) {
                          // Handle edit/cancel actions
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                const Icon(LucideIcons.squarePen, color: Colors.amber, size: 18),
                                const SizedBox(width: 8),
                                Text("Edit", style: GoogleFonts.inter(fontSize: 13)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'cancel',
                            child: Row(
                              children: [
                                const Icon(Icons.close, color: Colors.red, size: 18),
                                const SizedBox(width: 8),
                                Text("Cancel", style: GoogleFonts.inter(fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Date Submitted
                _buildDateRow(Icons.calendar_today, "Date Submitted: ", r['dateSubmitted'] ?? '-'),
                const SizedBox(height: 4),
                // Start Date
                _buildDateRow(Icons.calendar_month, "Start: ", r['startDate'] ?? r['dateRange']?.split(' - ').first ?? '-'),
                const SizedBox(height: 4),
                // End Date
                _buildDateRow(Icons.calendar_month, "End: ", r['endDate'] ?? r['dateRange']?.split(' - ').last ?? '-'),
                const SizedBox(height: 12),

                // Reason Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey.shade700),
                          const SizedBox(width: 6),
                          Text(
                            "Reason",
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        r['reason'] ?? 'No reason provided',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Attachments section (if any)
                if (r['attachments'] != null && (r['attachments'] as List).isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.attach_file, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(
                        "Attachments",
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (r['attachments'] as List).map<Widget>((attachment) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              attachment.toString().endsWith('.pdf')
                                  ? Icons.picture_as_pdf
                                  : Icons.image,
                              size: 14,
                              color: attachment.toString().endsWith('.pdf')
                                  ? Colors.redAccent
                                  : Colors.blue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              attachment.toString(),
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 16),

                // View Details Accordion
                GestureDetector(
                  onTap: () => setState(() => expanded = !expanded),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: expanded ? Colors.white : const Color(0xFFEAF2FF),
                      border: expanded ? Border.all(color: Colors.grey.shade300) : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade700),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  "View Per Day Leave (${r['duration'] ?? ''})",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ),

                // Expanded content (The Breakdown)
                if (expanded) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LEAVE DAYS BREAKDOWN",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Example breakdown item
                        _buildBreakdownItem(
                          date: r['startDate'] ?? "Jan 26, 2026",
                          dayType: "Full Day",
                          status: r['status'] ?? "Pending",
                          time: "8:00 AM - 5:00 PM",
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12),
        ),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownItem({
    required String date,
    required String dayType,
    required String status,
    required String time,
  }) {
    final statusColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(dayType, style: GoogleFonts.inter(fontSize: 9)),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(fontSize: 9, color: statusColor),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                time,
                style: GoogleFonts.inter(fontSize: 9, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
