import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class TeamLeaveRequestsScreen extends StatefulWidget {
  const TeamLeaveRequestsScreen({super.key});

  @override
  State<TeamLeaveRequestsScreen> createState() => _TeamLeaveRequestsScreenState();
}

class _TeamLeaveRequestsScreenState extends State<TeamLeaveRequestsScreen> {
  String _dateRange = '7'; // 7, 30, custom
  DateTimeRange? _customRange;
  String _appliedDateRange = '7';
  DateTimeRange? _appliedCustomRange;
  final Map<String, bool> _expandedPerDay = {};

  void _applyFilter() {
    setState(() {
      _appliedDateRange = _dateRange;
      _appliedCustomRange = _customRange;
    });
  }

  List<Map<String, dynamic>> get _leaveRequests {
    final now = DateTime.now();
    return [
      {
        'id': '1',
        'employeeName': 'Edward Peter',
        'status': 'Manager Pending',
        'statusColor': const Color(0xFFF59E0B),
        'borderColor': const Color(0xFFFEF3C7),
        'leaveType': 'Service Incentive Leave',
        'dateSubmitted': _fmt(now.subtract(const Duration(days: 2))),
        'period': '${_fmt(now.add(const Duration(days: 1)))} - ${_fmt(now.add(const Duration(days: 3)))}',
        'periodStart': now.add(const Duration(days: 1)),
        'periodEnd': now.add(const Duration(days: 3)),
        'days': 3,
      'pendingCount': 2,
      'approvedCount': 1,
      'declinedCount': 0,
      'reason': 'Checkup - need to attend to my monthly health checkup that requires my immediate attention in the next two days.',
      'attachments': [
        ('medical_cert.pdf', '245 KB', 'pdf'),
        ('hotel_reservation.jpg', '1.2 MB', 'image'),
      ],
    },
      {
        'id': '2',
        'employeeName': 'Amanda Roberts',
        'status': 'Manager Approved',
        'statusColor': const Color(0xFF3B82F6),
        'borderColor': const Color(0xFFDBEAFE),
        'leaveType': 'Service Incentive Leave',
        'dateSubmitted': _fmt(now.subtract(const Duration(days: 5))),
        'period': '${_fmt(now.subtract(const Duration(days: 3)))} - ${_fmt(now.subtract(const Duration(days: 2)))}',
        'periodStart': now.subtract(const Duration(days: 3)),
        'periodEnd': now.subtract(const Duration(days: 2)),
      'days': 2,
      'pendingCount': 0,
      'approvedCount': 2,
      'declinedCount': 0,
      'reason': 'Checkup - need to attend to my monthly health checkup that requires my immediate attention in the next two days.',
      'attachments': <(String, String, String)>[],
    },
    ];
  }

  static String _fmt(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  List<Map<String, dynamic>> get _filteredRequests {
    final now = DateTime.now();
    DateTime from;
    DateTime to;

    if (_appliedDateRange == '7') {
      to = DateTime(now.year, now.month, now.day);
      from = to.subtract(const Duration(days: 7));
    } else if (_appliedDateRange == '30') {
      to = DateTime(now.year, now.month, now.day);
      from = to.subtract(const Duration(days: 30));
    } else if (_appliedDateRange == 'custom' && _appliedCustomRange != null) {
      from = DateTime(_appliedCustomRange!.start.year, _appliedCustomRange!.start.month, _appliedCustomRange!.start.day);
      to = DateTime(_appliedCustomRange!.end.year, _appliedCustomRange!.end.month, _appliedCustomRange!.end.day);
    } else {
      return _leaveRequests;
    }

    return _leaveRequests.where((r) {
      final start = r['periodStart'] as DateTime;
      final end = r['periodEnd'] as DateTime;
      final rangeStart = DateTime(start.year, start.month, start.day);
      final rangeEnd = DateTime(end.year, end.month, end.day);
      return !rangeEnd.isBefore(from) && !rangeStart.isAfter(to);
    }).toList();
  }

  Future<void> _pickDateFrom() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _customRange?.start ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) {
      setState(() {
        _customRange = DateTimeRange(
          start: picked,
          end: _customRange?.end ?? picked.add(const Duration(days: 7)),
        );
      });
    }
  }

  Future<void> _pickDateTo() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _customRange?.end ?? DateTime.now(),
      firstDate: _customRange?.start ?? DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) {
      setState(() {
        _customRange = DateTimeRange(
          start: _customRange?.start ?? picked.subtract(const Duration(days: 7)),
          end: picked,
        );
      });
    }
  }

  void _togglePerDay(String id) {
    setState(() {
      _expandedPerDay[id] = !(_expandedPerDay[id] ?? false);
    });
  }

  void _showCreateMembersLeave() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
            maxWidth: 500,
          ),
          child: const _CreateMembersLeaveModal(),
        ),
      ),
    );
  }

  void _showViewAttachment(String filename, String size) {
    showDialog(
      context: context,
      builder: (_) => _ViewAttachmentDialog(filename: filename, size: size),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final headerColor = state.headerColor;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context, headerColor),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildFilterSection(headerColor),
                const SizedBox(height: 16),
                ..._filteredRequests.map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _LeaveRequestCard(
                        id: r['id'] as String,
                        employeeName: r['employeeName'] as String,
                        status: r['status'] as String,
                        statusColor: r['statusColor'] as Color,
                        borderColor: r['borderColor'] as Color,
                        leaveType: r['leaveType'] as String,
                        dateSubmitted: r['dateSubmitted'] as String,
                        period: r['period'] as String,
                        days: r['days'] as int,
                        pendingCount: r['pendingCount'] as int,
                        approvedCount: r['approvedCount'] as int,
                        declinedCount: r['declinedCount'] as int,
                        reason: r['reason'] as String,
                        attachments: r['attachments'] as List<(String, String, String)>,
                        onViewAttachment: _showViewAttachment,
                        expanded: _expandedPerDay[r['id']] ?? false,
                        onTogglePerDay: () => _togglePerDay(r['id'] as String),
                      ),
                    )),
              ],
            ),
          ),
          const AppBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color headerColor) {
    return Container(
      color: headerColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Team Leave Requests',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: _showCreateMembersLeave,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.iconBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'File Members Leave',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(Color headerColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _FilterChip(
                label: 'Last 7 Days',
                selected: _dateRange == '7',
                onTap: () => setState(() => _dateRange = '7'),
                color: headerColor,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Last 30 Days',
                selected: _dateRange == '30',
                onTap: () => setState(() => _dateRange = '30'),
                color: headerColor,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Custom',
                selected: _dateRange == 'custom',
                onTap: () => setState(() => _dateRange = 'custom'),
                color: headerColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_dateRange == 'custom') ...[
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickDateFrom,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textMuted),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _customRange != null
                                  ? '${_customRange!.start.year}-${_customRange!.start.month.toString().padLeft(2, '0')}-${_customRange!.start.day.toString().padLeft(2, '0')}'
                                  : 'Date From',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: _customRange != null ? AppColors.textPrimary : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickDateTo,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textMuted),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _customRange != null
                                  ? '${_customRange!.end.year}-${_customRange!.end.month.toString().padLeft(2, '0')}-${_customRange!.end.day.toString().padLeft(2, '0')}'
                                  : 'Date To',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: _customRange != null ? AppColors.textPrimary : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                const Icon(Icons.filter_list_rounded, size: 18, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Filter Status',
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.textMuted),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilter,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.iconBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Apply Filter',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      ),
    );
  }
}

class _LeaveRequestCard extends StatelessWidget {
  final String id;
  final String employeeName;
  final String status;
  final Color statusColor;
  final Color borderColor;
  final String leaveType;
  final String dateSubmitted;
  final String period;
  final int days;
  final int pendingCount;
  final int approvedCount;
  final int declinedCount;
  final String reason;
  final List<(String, String, String)> attachments;
  final void Function(String filename, String size) onViewAttachment;
  final bool expanded;
  final VoidCallback onTogglePerDay;

  const _LeaveRequestCard({
    required this.id,
    required this.employeeName,
    required this.status,
    required this.statusColor,
    required this.borderColor,
    required this.leaveType,
    required this.dateSubmitted,
    required this.period,
    required this.days,
    required this.pendingCount,
    required this.approvedCount,
    required this.declinedCount,
    required this.reason,
    required this.attachments,
    required this.onViewAttachment,
    required this.expanded,
    required this.onTogglePerDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      employeeName,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
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
                const SizedBox(height: 4),
                Text(
                  leaveType,
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      'Date Submitted: $dateSubmitted',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_month_rounded, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      'Period: $period',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$days days',
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _StatusPill(label: 'Pending', count: pendingCount, color: AppColors.statusPending),
                    _StatusPill(label: 'Approved', count: approvedCount, color: AppColors.statusApproved),
                    _StatusPill(label: 'Declined', count: declinedCount, color: AppColors.statusRejected),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.chat_bubble_outline_rounded, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reason',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            reason,
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (attachments.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.attach_file_rounded, size: 16, color: AppColors.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        'ATTACHMENTS (${attachments.length})',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...attachments.map((a) => _AttachmentRow(
                        filename: a.$1,
                        size: a.$2,
                        type: a.$3,
                        onView: () => onViewAttachment(a.$1, a.$2),
                      )),
                ],
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: onTogglePerDay,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month_rounded, size: 18, color: AppColors.textMuted),
                        const SizedBox(width: 8),
                        Text(
                          'View Per Day Leave ($days days)',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                          size: 22,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
                if (expanded) ...[
                  const SizedBox(height: 12),
                  _LeaveDaysBreakdown(id: id),
                ],
              ],
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $count',
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _AttachmentRow extends StatelessWidget {
  final String filename;
  final String size;
  final String type;
  final VoidCallback onView;

  const _AttachmentRow({
    required this.filename,
    required this.size,
    required this.type,
    required this.onView,
  });

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
                Text(
                  filename,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  size,
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onView,
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

class _LeaveDaysBreakdown extends StatelessWidget {
  final String id;

  const _LeaveDaysBreakdown({required this.id});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'LEAVE DAYS BREAKDOWN',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        _LeaveDayTile(
          date: 'Friday, Dec 26, 2025',
          type: 'Full Day',
          status: 'Pending',
          statusColor: AppColors.statusPending,
          time: '8:00 AM - 5:00 PM',
          bgColor: const Color(0xFFFEF3C7),
        ),
        const SizedBox(height: 8),
        _LeaveDayTile(
          date: 'Saturday, Dec 27, 2025',
          type: 'Full Day',
          status: 'Approved',
          statusColor: AppColors.statusApproved,
          time: '8:00 AM - 5:00 PM',
          bgColor: const Color(0xFFD1FAE5),
        ),
        const SizedBox(height: 8),
        _LeaveDayTile(
          date: 'Sunday, Dec 28, 2025',
          type: 'Half Day (AM)',
          status: 'Pending',
          statusColor: AppColors.statusPending,
          time: '8:00 AM - 5:00 PM',
          bgColor: const Color(0xFFFEF3C7),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: Text(
                  'Approve All',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statusApproved,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: Text(
                  'Deny All',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statusRejected,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LeaveDayTile extends StatelessWidget {
  final String date;
  final String type;
  final String status;
  final Color statusColor;
  final String time;
  final Color bgColor;

  const _LeaveDayTile({
    required this.date,
    required this.type,
    required this.status,
    required this.statusColor,
    required this.time,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        type,
                        style: GoogleFonts.inter(fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.check_circle_outline_rounded, color: AppColors.statusApproved, size: 22),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.cancel_outlined, color: AppColors.statusRejected, size: 22),
          ),
        ],
      ),
    );
  }
}

class _CreateMembersLeaveModal extends StatefulWidget {
  const _CreateMembersLeaveModal();

  @override
  State<_CreateMembersLeaveModal> createState() => _CreateMembersLeaveModalState();
}

class _CreateMembersLeaveModalState extends State<_CreateMembersLeaveModal> {
  String? _selectedEmployee;
  String? _selectedLeaveType;
  final List<DateTime> _selectedDates = [];
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Members Leave',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sub-description will be here',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.close_rounded),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDropdown(
                  label: 'Select Employee',
                  value: _selectedEmployee,
                  options: const ['Daniel Gray', 'Edward Peter', 'Amanda Roberts', 'Maria Dela Rosa'],
                  onChanged: (v) => setState(() => _selectedEmployee = v),
                ),
                const SizedBox(height: 12),
                _buildDropdown(
                  label: 'Select Leave Type',
                  value: _selectedLeaveType,
                  options: const ['Leave Without Pay', 'Service Incentive Leave', 'Maternity Leave'],
                  onChanged: (v) => setState(() => _selectedLeaveType = v),
                ),
                const SizedBox(height: 12),
                _buildDateSelector(),
                const SizedBox(height: 12),
                Text(
                  'Enter a Reason',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _reasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter a Reason',
                    hintStyle: GoogleFonts.inter(color: AppColors.textMuted),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 12),
                _buildFileUpload(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.iconBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => SafeArea(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (_, i) {
                return ListTile(
                  title: Text(options[i]),
                  onTap: () {
                    onChanged(options[i]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: value != null ? AppColors.textPrimary : AppColors.textMuted,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    final count = _selectedDates.length;
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() => _selectedDates.add(date));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.textMuted),
            const SizedBox(width: 10),
            Text(
              count == 0 ? 'Select dates' : '$count date(s) selected',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: count > 0 ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildFileUpload() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1.5),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_upload_outlined, size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(
            'Click or drag files to upload',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.divider),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Select Files',
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewAttachmentDialog extends StatelessWidget {
  final String filename;
  final String size;

  const _ViewAttachmentDialog({required this.filename, required this.size});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.attach_file_rounded, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'View attachment',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.close_rounded, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                filename.endsWith('.pdf') ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
                size: 40,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              filename,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              size,
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.download_rounded, size: 18),
                label: Text(
                  'Download File',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.divider),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
