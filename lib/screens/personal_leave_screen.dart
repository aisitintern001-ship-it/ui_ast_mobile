import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PersonalLeaveScreen extends StatelessWidget {
  const PersonalLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: AppColors.iconOrange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Leave Records',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                _TabButton(label: 'History', selected: true),
                const SizedBox(width: 16),
                _TabButton(label: 'Offline', selected: false),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                _FilterChip(label: 'Last 7 Days', selected: true),
                const SizedBox(width: 8),
                _FilterChip(label: 'Last 30 Days', selected: false),
                const SizedBox(width: 8),
                _FilterChip(label: 'Custom', selected: false),
                const Spacer(),
                Icon(Icons.filter_alt_outlined, color: AppColors.iconBlue),
                const SizedBox(width: 4),
                Text('Filter Status', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.iconBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Apply Filter'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _LeaveCard(
                  leaveType: 'Leave Without Pay',
                  status: 'Pending',
                  statusColor: AppColors.statusPending,
                  borderColor: AppColors.statusPending,
                  dateSubmitted: 'Sep 28, 2025',
                  start: 'Sep 29, 2025',
                  end: 'Sep 30, 2025',
                  reason: 'Checkup – need to attend to my monthly health checkup that requires my immediate attention in the next two days.',
                  pending: 2,
                  approved: 0,
                  declined: 0,
                  attachments: const [
                    ('medical_cert.pdf', '245 KB', 'pdf'),
                  ],
                ),
                _LeaveCard(
                  leaveType: 'Service Incentive Leave',
                  status: 'Approved',
                  statusColor: AppColors.statusApproved,
                  borderColor: AppColors.statusApproved,
                  dateSubmitted: 'Sep 16, 2025',
                  start: 'Sep 16, 2025',
                  end: 'Sep 17, 2025',
                  reason: 'Personal Emergency – need to attend to family matters that requires my immediate attention in the next two days.',
                  pending: 0,
                  approved: 2,
                  declined: 0,
                  attachments: const [],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text('Add Leave'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.iconBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  const _TabButton({required this.label, required this.selected});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.iconOrange : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterChip({required this.label, required this.selected});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.iconBlue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.iconBlue : AppColors.divider,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: selected ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _LeaveCard extends StatelessWidget {
  final String leaveType;
  final String status;
  final Color statusColor;
  final Color borderColor;
  final String dateSubmitted;
  final String start;
  final String end;
  final String reason;
  final int pending;
  final int approved;
  final int declined;
  final List<(String, String, String)> attachments;
  const _LeaveCard({
    required this.leaveType,
    required this.status,
    required this.statusColor,
    required this.borderColor,
    required this.dateSubmitted,
    required this.start,
    required this.end,
    required this.reason,
    required this.pending,
    required this.approved,
    required this.declined,
    required this.attachments,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    leaveType,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text('Date Submitted: $dateSubmitted', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_month_rounded, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text('Start: $start', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(width: 12),
                Text('End: $end', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: AppColors.iconBlue),
                      const SizedBox(width: 6),
                      Text('Reason', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(reason, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _StatusPill(label: 'Pending', count: pending, color: AppColors.statusPending),
                const SizedBox(width: 8),
                _StatusPill(label: 'Approved', count: approved, color: AppColors.statusApproved),
                const SizedBox(width: 8),
                _StatusPill(label: 'Declined', count: declined, color: AppColors.statusRejected),
              ],
            ),
            const SizedBox(height: 10),
            if (attachments.isNotEmpty) ...[
              Text('Attachments', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              ...attachments.map((a) => _AttachmentRow(filename: a.$1, size: a.$2, type: a.$3)),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatusPill({required this.label, required this.count, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$label: $count', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _AttachmentRow extends StatelessWidget {
  final String filename;
  final String size;
  final String type;
  const _AttachmentRow({required this.filename, required this.size, required this.type});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            type == 'pdf' ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
            size: 20,
            color: type == 'pdf' ? Colors.red.shade400 : AppColors.iconBlue,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(filename, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(size, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.visibility_outlined, size: 20),
            color: AppColors.textMuted,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded, size: 20),
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}
