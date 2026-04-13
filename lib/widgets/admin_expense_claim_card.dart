import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'approve_decline_buttons.dart';

/// Expense claim card for admin view with approve/decline functionality.
class AdminExpenseClaimCard extends StatefulWidget {
  final Map<String, dynamic> claim;
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;

  const AdminExpenseClaimCard({
    super.key,
    required this.claim,
    this.onEdit,
    this.onCancel,
    this.onApprove,
    this.onDecline,
  });

  @override
  State<AdminExpenseClaimCard> createState() => _AdminExpenseClaimCardState();
}

class _AdminExpenseClaimCardState extends State<AdminExpenseClaimCard> {
  bool expanded = false;

  Color _getStatusColor(String status) {
    final statusLower = status.toLowerCase();
    if (statusLower.contains('pending')) return const Color(0xFFF59E0B);
    if (statusLower.contains('approved')) return const Color(0xFF10B981);
    if (statusLower.contains('declined') || statusLower.contains('denied')) {
      return const Color(0xFFEF4444);
    }
    if (statusLower.contains('finance')) return const Color(0xFF8B5CF6);
    if (statusLower.contains('waiting')) return const Color(0xFFF97316);
    if (statusLower.contains('paid')) return const Color(0xFF10B981);
    return const Color(0xFFF59E0B);
  }

  Widget _buildStatPill(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$label: $count",
        style: GoogleFonts.inter(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.claim;
    final statusColor = _getStatusColor(c['status'] ?? 'Pending');
    final attachments = c['attachments'] as List<String>? ?? [];

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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with employee name, status and edit action
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c['employeeName'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: statusColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              c['status'] ?? 'Pending',
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
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onEdit,
                      child: Icon(
                        LucideIcons.squarePen,
                        size: 20,
                        color: const Color.fromARGB(255, 221, 184, 19),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Category and date row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        c['category'] ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      c['date'] ?? '',
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Amount
                Text(
                  c['amount'] ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFEF532A),
                  ),
                ),
                const SizedBox(height: 12),

                // Description box
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
                            "Description",
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        c['description'] ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Stat pills
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStatPill("Pending", c['pending'] ?? 0, Colors.amber.shade700),
                    _buildStatPill("Approved", c['approved'] ?? 0, Colors.teal),
                    _buildStatPill("Declined", c['declined'] ?? 0, Colors.redAccent),
                  ],
                ),

                // Attachments
                if (attachments.isNotEmpty) ...[
                  const SizedBox(height: 16),
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
                    children: attachments.map((a) {
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
                              a.contains('pdf') ? Icons.picture_as_pdf : Icons.image,
                              size: 14,
                              color: a.contains('pdf') ? Colors.redAccent : Colors.blue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              a,
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
                              Icon(Icons.receipt_long, size: 14, color: Colors.grey.shade700),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  "View Expense Details",
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

                // Expanded content with breakdown and approve/decline buttons
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
                          "EXPENSE BREAKDOWN",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Example breakdown item
                        _buildBreakdownItem(
                          title: c['category'] ?? 'Expense',
                          amount: c['amount'] ?? '',
                          date: c['date'] ?? '',
                          status: c['status'] ?? 'Pending',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ApproveDeclineButtons(
                    onApprove: widget.onApprove,
                    onDecline: widget.onDecline,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem({
    required String title,
    required String amount,
    required String date,
    required String status,
  }) {
    final statusColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(amount, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
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
                    Text(
                      date,
                      style: GoogleFonts.inter(fontSize: 9, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ApproveDeclineIconButtons(
            onApprove: widget.onApprove,
            onDecline: widget.onDecline,
          ),
        ],
      ),
    );
  }
}
