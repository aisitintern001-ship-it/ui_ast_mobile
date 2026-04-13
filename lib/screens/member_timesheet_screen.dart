import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/expandable_status_filter.dart';
import '../widgets/filter_tabs.dart';

// ─── Models ──────────────────────────────────────────────────────────────────

class _DayEntry {
  final String date;
  final String status; // 'Mngr. Approved', 'Mngr. Pending', 'No Attendance'
  final double normalHours;
  final double overtimeHours;
  final double tardyMinutes;
  final double nightDifferential;
  final double underTime;
  final double paidLeave;
  final double totalAllowance;
  final double publicHoliday;

  const _DayEntry({
    required this.date,
    required this.status,
    this.normalHours = 0,
    this.overtimeHours = 0,
    this.tardyMinutes = 0,
    this.nightDifferential = 0,
    this.underTime = 0,
    this.paidLeave = 0,
    this.totalAllowance = 0,
    this.publicHoliday = 0,
  });
}

class _EmployeeTimesheet {
  final String name;
  final String initials;
  final Color avatarColor;
  final double totalAllowance;
  final double overtime;
  final double totalNormalTime;
  final List<_DayEntry> days;

  const _EmployeeTimesheet({
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.totalAllowance,
    required this.overtime,
    required this.totalNormalTime,
    required this.days,
  });
}

// ─── Mock Data ───────────────────────────────────────────────────────────────

final List<_EmployeeTimesheet> _mockTimesheets = [
  _EmployeeTimesheet(
    name: 'Edward Peter',
    initials: 'EP',
    avatarColor: const Color(0xFF2563EB),
    totalAllowance: 50,
    overtime: 8,
    totalNormalTime: 40,
    days: const [
      _DayEntry(
        date: 'Mon, Jan 06 2025',
        status: 'Mngr. Approved',
        normalHours: 8,
        overtimeHours: 2,
        tardyMinutes: 0,
        nightDifferential: 0,
        underTime: 0,
        paidLeave: 0,
        totalAllowance: 10,
        publicHoliday: 0,
      ),
      _DayEntry(
        date: 'Tue, Jan 07 2025',
        status: 'Mngr. Pending',
        normalHours: 8,
        overtimeHours: 1,
        tardyMinutes: 15,
        nightDifferential: 0,
        underTime: 0,
        paidLeave: 0,
        totalAllowance: 10,
        publicHoliday: 0,
      ),
      _DayEntry(date: 'Wed, Jan 08 2025', status: 'No Attendance'),
    ],
  ),
  _EmployeeTimesheet(
    name: 'Daniel Gray',
    initials: 'DG',
    avatarColor: const Color(0xFF7C3AED),
    totalAllowance: 50,
    overtime: 4,
    totalNormalTime: 40,
    days: const [
      _DayEntry(
        date: 'Mon, Jan 06 2025',
        status: 'Mngr. Approved',
        normalHours: 8,
        overtimeHours: 1,
        tardyMinutes: 0,
        nightDifferential: 0,
        underTime: 0,
        paidLeave: 0,
        totalAllowance: 10,
        publicHoliday: 0,
      ),
      _DayEntry(
        date: 'Tue, Jan 07 2025',
        status: 'Mngr. Approved',
        normalHours: 8,
        overtimeHours: 0,
        tardyMinutes: 0,
        nightDifferential: 0,
        underTime: 0,
        paidLeave: 0,
        totalAllowance: 10,
        publicHoliday: 0,
      ),
    ],
  ),
  _EmployeeTimesheet(
    name: 'Amanda Roberts',
    initials: 'AR',
    avatarColor: const Color(0xFFEC4899),
    totalAllowance: 45,
    overtime: 2,
    totalNormalTime: 32,
    days: const [
      _DayEntry(
        date: 'Mon, Jan 06 2025',
        status: 'Mngr. Pending',
        normalHours: 8,
        overtimeHours: 2,
        tardyMinutes: 0,
        nightDifferential: 0,
        underTime: 0,
        paidLeave: 0,
        totalAllowance: 10,
        publicHoliday: 0,
      ),
      _DayEntry(date: 'Tue, Jan 07 2025', status: 'No Attendance'),
    ],
  ),
  _EmployeeTimesheet(
    name: 'Maria Dela Rosa',
    initials: 'MR',
    avatarColor: const Color(0xFF10B981),
    totalAllowance: 50,
    overtime: 6,
    totalNormalTime: 40,
    days: const [
      _DayEntry(
        date: 'Mon, Jan 06 2025',
        status: 'Mngr. Approved',
        normalHours: 8,
        overtimeHours: 3,
        tardyMinutes: 0,
        nightDifferential: 0,
        underTime: 0,
        paidLeave: 0,
        totalAllowance: 10,
        publicHoliday: 0,
      ),
    ],
  ),
  _EmployeeTimesheet(
    name: 'Michael Chen',
    initials: 'MC',
    avatarColor: const Color(0xFFF59E0B),
    totalAllowance: 48,
    overtime: 3,
    totalNormalTime: 38,
    days: const [
      _DayEntry(
        date: 'Mon, Jan 06 2025',
        status: 'Mngr. Approved',
        normalHours: 8,
        overtimeHours: 1,
        tardyMinutes: 0,
        nightDifferential: 0,
        underTime: 0,
        paidLeave: 0,
        totalAllowance: 10,
        publicHoliday: 0,
      ),
      _DayEntry(
        date: 'Tue, Jan 07 2025',
        status: 'Mngr. Pending',
        normalHours: 8,
        overtimeHours: 2,
        tardyMinutes: 10,
        nightDifferential: 0,
        underTime: 0,
        paidLeave: 0,
        totalAllowance: 10,
        publicHoliday: 0,
      ),
    ],
  ),
  _EmployeeTimesheet(
    name: 'Anika Carder',
    initials: 'AC',
    avatarColor: const Color(0xFFEF4444),
    totalAllowance: 40,
    overtime: 0,
    totalNormalTime: 32,
    days: const [
      _DayEntry(
        date: 'Mon, Jan 06 2025',
        status: 'Mngr. Approved',
        normalHours: 8,
        overtimeHours: 0,
        tardyMinutes: 0,
        nightDifferential: 0,
        underTime: 0,
        paidLeave: 8,
        totalAllowance: 10,
        publicHoliday: 0,
      ),
      _DayEntry(date: 'Tue, Jan 07 2025', status: 'No Attendance'),
      _DayEntry(date: 'Wed, Jan 08 2025', status: 'No Attendance'),
    ],
  ),
];

// ─── Screen ──────────────────────────────────────────────────────────────────

class MemberTimesheetScreen extends StatefulWidget {
  const MemberTimesheetScreen({super.key});

  @override
  State<MemberTimesheetScreen> createState() => _MemberTimesheetScreenState();
}

class _MemberTimesheetScreenState extends State<MemberTimesheetScreen> {
  String? _employeeQuery;
  String? _selectedStatus;
  String _selectedDateFilter = '7';
  int? _expandedCard;
  final Map<String, bool> _expandedDays = {};

  static const List<Map<String, dynamic>> _timesheetStatuses = [
    {'label': 'Mngr. Approved', 'color': Color(0xFF10B981)},
    {'label': 'Mngr. Pending', 'color': Color(0xFFF59E0B)},
    {'label': 'No Attendance', 'color': Color(0xFFEF4444)},
  ];

  List<_EmployeeTimesheet> get _filtered {
    var list = _mockTimesheets;
    final query = (_employeeQuery ?? '').trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((e) => e.name.toLowerCase().contains(query)).toList();
    }
    return list;
  }

  String _expandDateLabel(String value) {
    const dayMap = {
      'Mon': 'Monday',
      'Tue': 'Tuesday',
      'Wed': 'Wednesday',
      'Thu': 'Thursday',
      'Fri': 'Friday',
      'Sat': 'Saturday',
      'Sun': 'Sunday',
    };
    final parts = value.split(', ');
    if (parts.length != 2) return value;
    final longDay = dayMap[parts.first] ?? parts.first;
    final monthDayYear = parts.last.split(' ');
    if (monthDayYear.length != 3) return '$longDay, ${parts.last}';
    return '$longDay, ${monthDayYear[0]} ${monthDayYear[1]}, ${monthDayYear[2]}';
  }

  void _openAddTimesheetSheet(String employeeName, _DayEntry entry) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => FractionallySizedBox(
            heightFactor: 0.88,
            child: _AddTimesheetSheet(
              employeeName: employeeName,
              dateLabel: _expandDateLabel(entry.date),
            ),
          ),
    );
  }

  void _openAddAllowanceSheet(String employeeName, _DayEntry entry) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => FractionallySizedBox(
            heightFactor: 0.88,
            child: _AddAllowanceSheet(
              employeeName: employeeName,
              dateLabel: _expandDateLabel(entry.date),
            ),
          ),
    );
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Member Timesheet',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Date filter chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: FilterTabs(
              selected: _selectedDateFilter,
              onChanged: (v) => setState(() => _selectedDateFilter = v),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          // Filter row
          Container(
            color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Column(
                children: [
                  _buildEmployeeSearchBar(),
                const SizedBox(height: 8),
                ExpandableStatusFilter(
                  statuses: _timesheetStatuses,
                  selectedStatus: _selectedStatus,
                  onChanged: (v) => setState(() => _selectedStatus = v),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () => setState(() {}),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2181FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Apply Filter'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          // Timesheet list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final emp = _filtered[index];
                final isExpanded = _expandedCard == index;
                return _TimesheetCard(
                  employee: emp,
                  isExpanded: isExpanded,
                  expandedDays: _expandedDays,
                  onAddTimesheet: _openAddTimesheetSheet,
                  onAddAllowance: _openAddAllowanceSheet,
                  onToggle: () {
                    setState(() {
                      _expandedCard = isExpanded ? null : index;
                    });
                  },
                  onToggleDay: (key) {
                    setState(() {
                      _expandedDays[key] = !(_expandedDays[key] ?? false);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  Widget _buildEmployeeSearchBar() {
    return SizedBox(
      height: 38,
      child: TextField(
        onChanged: (value) => setState(() => _employeeQuery = value),
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search Employee',
          hintStyle: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
          prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF9CA3AF)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ─── Timesheet Card ──────────────────────────────────────────────────────────

class _TimesheetCard extends StatelessWidget {
  final _EmployeeTimesheet employee;
  final bool isExpanded;
  final Map<String, bool> expandedDays;
  final void Function(String employeeName, _DayEntry entry) onAddTimesheet;
  final void Function(String employeeName, _DayEntry entry) onAddAllowance;
  final VoidCallback onToggle;
  final ValueChanged<String> onToggleDay;

  const _TimesheetCard({
    required this.employee,
    required this.isExpanded,
    required this.expandedDays,
    required this.onAddTimesheet,
    required this.onAddAllowance,
    required this.onToggle,
    required this.onToggleDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          // Header row
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: employee.avatarColor.withValues(alpha: 0.15),
                    child: Text(
                      employee.initials,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: employee.avatarColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                            children: [
                              const TextSpan(text: 'Total Allowance: '),
                              TextSpan(
                                text: employee.totalAllowance
                                    .toStringAsFixed(0),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const TextSpan(text: '  Overtime: '),
                              TextSpan(
                                text: employee.overtime.toStringAsFixed(0),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text.rich(
                          TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                            children: [
                              const TextSpan(text: 'Total Normal Time: '),
                              TextSpan(
                                text: employee.totalNormalTime
                                    .toStringAsFixed(0),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          // Expanded day entries
          if (isExpanded) ...[
            const Divider(height: 1, color: AppColors.divider),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                children: [
                  for (int i = 0; i < employee.days.length; i++) ...[
                    if (i > 0) const SizedBox(height: 8),
                    _DayEntryTile(
                      entry: employee.days[i],
                      dayKey: '${employee.name}_$i',
                      isExpanded:
                          expandedDays['${employee.name}_$i'] ?? false,
                      onOpenTimesheet:
                          () => onAddTimesheet(employee.name, employee.days[i]),
                      onOpenAllowance:
                          () => onAddAllowance(employee.name, employee.days[i]),
                      onToggle: () => onToggleDay('${employee.name}_$i'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Day Entry Tile ──────────────────────────────────────────────────────────

class _DayEntryTile extends StatelessWidget {
  final _DayEntry entry;
  final String dayKey;
  final bool isExpanded;
  final VoidCallback onOpenTimesheet;
  final VoidCallback onOpenAllowance;
  final VoidCallback onToggle;

  const _DayEntryTile({
    required this.entry,
    required this.dayKey,
    required this.isExpanded,
    required this.onOpenTimesheet,
    required this.onOpenAllowance,
    required this.onToggle,
  });

  Color get _statusColor {
    switch (entry.status) {
      case 'Mngr. Approved':
        return const Color(0xFF2563EB);
      case 'Mngr. Pending':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color get _statusBg {
    switch (entry.status) {
      case 'Mngr. Approved':
        return const Color(0xFF2563EB).withValues(alpha: 0.1);
      case 'Mngr. Pending':
        return const Color(0xFFF59E0B).withValues(alpha: 0.1);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNoAttendance = entry.status == 'No Attendance';

    return Container(
      decoration: BoxDecoration(
        color: isNoAttendance ? const Color(0xFFFCF8EB) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                entry.date,
                                style: GoogleFonts.inter(
                                  fontSize: 22 / 2,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: _statusBg,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: _statusColor.withValues(alpha: 0.35),
                                ),
                              ),
                              child: Text(
                                entry.status,
                                style: GoogleFonts.inter(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w600,
                                  color: _statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            if (isNoAttendance) ...[
                              _actionButton(
                                icon: Icons.access_time_filled_rounded,
                                backgroundColor: const Color(0xFFF59E0B),
                                onTap: onOpenTimesheet,
                              ),
                              const SizedBox(width: 6),
                            ] else ...[
                              _actionButton(
                                icon: Icons.check_rounded,
                                backgroundColor: const Color(0xFF10B981),
                              ),
                              const SizedBox(width: 6),
                            ],
                            _actionButton(
                              icon: Icons.add_rounded,
                              backgroundColor: const Color(0xFF2181FF),
                              onTap: onOpenTimesheet,
                            ),
                            const SizedBox(width: 6),
                            _actionButton(
                              icon: LucideIcons.handCoins,
                              backgroundColor: const Color(0xFFEF532A),
                              onTap: onOpenAllowance,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 17,
                    color: const Color(0xFF7C8793),
                  ),
                ],
              ),
            ),
          ),
          if (!isNoAttendance) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
              child: _metricsGrid(),
            ),
          ],
          if (isExpanded) ...[
            const Divider(height: 1, color: AppColors.divider),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child:
                  isNoAttendance
                      ? Column(
                        children: [
                          const Divider(height: 1, color: AppColors.divider),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              'No time entries for this day. Click + to add a manual entry.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      )
                      : _expandedEntryDetails(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color backgroundColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: 18,
          height: 18,
          child: Icon(icon, size: 11.5, color: Colors.white),
        ),
      ),
    );
  }

  Widget _metricsGrid() {
    return Column(
      children: [
        Row(
          children: [
            _metricCell('Normal Hours', entry.normalHours),
            _metricCell('Overtime Hours', entry.overtimeHours),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            _metricCell('Tardy Minutes', entry.tardyMinutes),
            _metricCell('Night Differential', entry.nightDifferential),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            _metricCell('Under Time', entry.underTime),
            _metricCell('Paid Leave', entry.paidLeave),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            _metricCell('Total Allowance', entry.totalAllowance),
            _metricCell('Public Holiday', entry.publicHoliday),
          ],
        ),
      ],
    );
  }

  Widget _expandedEntryDetails() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendDot(const Color(0xFF2181FF)),
            const SizedBox(width: 3),
            Text(
              'Actual',
              style: GoogleFonts.inter(fontSize: 9.5, color: const Color(0xFF374151)),
            ),
            const SizedBox(width: 8),
            _legendDot(const Color(0xFFF59E0B)),
            const SizedBox(width: 3),
            Text(
              'Manual',
              style: GoogleFonts.inter(fontSize: 9.5, color: const Color(0xFF374151)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, color: AppColors.divider),
        const SizedBox(height: 7),
        Row(
          children: [
            Expanded(
              child: Text(
                'ACTUAL',
                style: GoogleFonts.inter(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ),
            Expanded(
              child: Text(
                'CALCULATED',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ),
            SizedBox(
              width: 62,
              child: Text(
                'ACTIONS',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            Expanded(
              child: Text(
                '08:15 AM - 5:30 PM',
                style: GoogleFonts.inter(fontSize: 9.5, color: const Color(0xFF374151)),
              ),
            ),
            Expanded(
              child: Text(
                '08:00 AM - 5:00 PM',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 9.5, color: const Color(0xFF374151)),
              ),
            ),
            SizedBox(
              width: 62,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.squarePen, size: 11, color: const Color(0xFFF59E0B)),
                  const SizedBox(width: 7),
                  Icon(LucideIcons.trash2, size: 11, color: const Color(0xFFEF4444)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _legendDot(Color color) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _metricCell(String label, double value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1677FF),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddTimesheetSheet extends StatefulWidget {
  final String employeeName;
  final String dateLabel;

  const _AddTimesheetSheet({
    required this.employeeName,
    required this.dateLabel,
  });

  @override
  State<_AddTimesheetSheet> createState() => _AddTimesheetSheetState();
}

class _AddTimesheetSheetState extends State<_AddTimesheetSheet> {
  bool _isNextDay = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 22,
            right: 22,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Add Timesheet',
                style: GoogleFonts.inter(
                  fontSize: 31 / 2,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.dateLabel,
                style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                widget.employeeName,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Entry',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Time In',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _sheetInput(
                        hint: 'In',
                        prefixIcon: Icons.access_time,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isNextDay,
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                            onChanged: (v) => setState(() => _isNextDay = v ?? false),
                          ),
                          Text(
                            'Does time out next day?',
                            style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF374151)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Time Out',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _sheetInput(
                        hint: 'Out',
                        prefixIcon: Icons.access_time,
                      ),
                      const SizedBox(height: 10),
                      _sheetInput(
                        hint: 'Enter a Reason',
                        maxLines: 7,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF2181FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddAllowanceSheet extends StatelessWidget {
  final String employeeName;
  final String dateLabel;

  const _AddAllowanceSheet({
    required this.employeeName,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 22,
            right: 22,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Add Allowance',
                style: GoogleFonts.inter(
                  fontSize: 31 / 2,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                dateLabel,
                style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                employeeName,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.divider),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Entry',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _sheetInput(hint: 'Value'),
                            const SizedBox(height: 10),
                            _sheetInput(hint: 'Enter a Reason', maxLines: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 36,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                            label: Text(
                              'Add Allowance',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              backgroundColor: const Color(0xFF2181FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF2181FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _sheetInput({
  required String hint,
  IconData? prefixIcon,
  int maxLines = 1,
}) {
  return TextFormField(
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 11,
        color: const Color(0xFF9CA3AF),
      ),
      prefixIcon:
          prefixIcon == null
              ? null
              : Icon(prefixIcon, size: 16, color: const Color(0xFF9CA3AF)),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: maxLines == 1 ? 10 : 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF2181FF)),
      ),
    ),
    style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF111827)),
  );
}
