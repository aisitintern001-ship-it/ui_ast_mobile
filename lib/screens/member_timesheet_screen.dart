import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String _selectedEmployee = 'All';
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
    if (_selectedEmployee != 'All') {
      list = list.where((e) => e.name == _selectedEmployee).toList();
    }
    return list;
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
                _buildDropdown(
                  'Search Employee',
                  _selectedEmployee,
                  ['All', ..._mockTimesheets.map((e) => e.name)],
                  (v) => setState(() => _selectedEmployee = v ?? 'All'),
                ),
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
                      backgroundColor: AppColors.headerOrange,
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
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final emp = _filtered[index];
                final isExpanded = _expandedCard == index;
                return _TimesheetCard(
                  employee: emp,
                  isExpanded: isExpanded,
                  expandedDays: _expandedDays,
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

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 38,
          child: DropdownButtonFormField<String>(
            value: value,
            items:
                items
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: GoogleFonts.inter(fontSize: 13)),
                      ),
                    )
                    .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down, size: 18),
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Timesheet Card ──────────────────────────────────────────────────────────

class _TimesheetCard extends StatelessWidget {
  final _EmployeeTimesheet employee;
  final bool isExpanded;
  final Map<String, bool> expandedDays;
  final VoidCallback onToggle;
  final ValueChanged<String> onToggleDay;

  const _TimesheetCard({
    required this.employee,
    required this.isExpanded,
    required this.expandedDays,
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
  final VoidCallback onToggle;

  const _DayEntryTile({
    required this.entry,
    required this.dayKey,
    required this.isExpanded,
    required this.onToggle,
  });

  Color get _statusColor {
    switch (entry.status) {
      case 'Mngr. Approved':
        return const Color(0xFF2563EB);
      case 'Mngr. Pending':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  Color get _statusBg {
    switch (entry.status) {
      case 'Mngr. Approved':
        return const Color(0xFF2563EB).withValues(alpha: 0.1);
      case 'Mngr. Pending':
        return const Color(0xFFF59E0B).withValues(alpha: 0.1);
      default:
        return const Color(0xFF9CA3AF).withValues(alpha: 0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNoAttendance = entry.status == 'No Attendance';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.date,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _statusBg,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            entry.status,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action icons
                  if (!isNoAttendance) ...[
                    _actionIcon(Icons.check_circle_outline, const Color(0xFF10B981)),
                    const SizedBox(width: 6),
                    _actionIcon(Icons.add_circle_outline, const Color(0xFF2563EB)),
                    const SizedBox(width: 6),
                    _actionIcon(Icons.cancel_outlined, AppColors.dangerRed),
                  ] else
                    _actionIcon(Icons.add_circle_outline, const Color(0xFF2563EB)),
                  const SizedBox(width: 4),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: AppColors.divider),
            Padding(
              padding: const EdgeInsets.all(12),
              child:
                  isNoAttendance
                      ? Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'No time entries for this day. Click + to add a manual entry.',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textMuted,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      )
                      : _metricsGrid(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color) {
    return Icon(icon, size: 20, color: color);
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
        const SizedBox(height: 8),
        Row(
          children: [
            _metricCell('Tardy Minutes', entry.tardyMinutes),
            _metricCell('Night Differential', entry.nightDifferential),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _metricCell('Under Time', entry.underTime),
            _metricCell('Paid Leave', entry.paidLeave),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _metricCell('Total Allowance', entry.totalAllowance),
            _metricCell('Public Holiday', entry.publicHoliday),
          ],
        ),
      ],
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
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1),
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
