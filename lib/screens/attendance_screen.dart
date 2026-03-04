import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import 'face_recognition_screen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _hasCurrentTimeIn = false;
  String? _lastAction; // 'Time In' or 'Time Out'
  bool _showHistory = true; // true = History, false = Offline
  String _range = '7'; // '7', '30', 'custom'
  DateTimeRange? _customRange;
  final List<String> _selectedStatuses = ['Mngr. Approved', 'Processed Payroll'];

  final List<_AttendanceRecord> _records = [
    _AttendanceRecord(
      date: DateTime(2026, 1, 20),
      status: 'Mngr. Approved',
      normalHours: 8,
      overtimeHours: 1.25,
    ),
    _AttendanceRecord(
      date: DateTime(2026, 1, 19),
      status: 'Mngr. Approved',
      normalHours: 8,
      overtimeHours: 0,
    ),
    _AttendanceRecord(
      date: DateTime(2026, 1, 18),
      status: 'Processed Payroll',
      normalHours: 8,
      overtimeHours: 0.5,
    ),
  ];

  Future<void> _handleFaceAction(BuildContext context, String action) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FaceRecognitionScreen(mode: action),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _lastAction = action;
        _hasCurrentTimeIn = action == 'Time In';
      });

      // ignore: use_build_context_synchronously
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$action recorded via face recognition'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  List<_AttendanceRecord> get _filteredRecords {
    final now = DateTime.now();
    DateTime from;
    DateTime to;

    if (_range == '7') {
      to = DateTime(now.year, now.month, now.day);
      from = to.subtract(const Duration(days: 7));
    } else if (_range == '30') {
      to = DateTime(now.year, now.month, now.day);
      from = to.subtract(const Duration(days: 30));
    } else if (_customRange != null) {
      from = _customRange!.start;
      to = _customRange!.end;
    } else {
      from = DateTime(2000);
      to = DateTime(2100);
    }

    return _records.where((r) {
      final d = DateTime(r.date.year, r.date.month, r.date.day);
      final inRange = !d.isBefore(from) && !d.isAfter(to);
      final statusOk =
          _selectedStatuses.isEmpty || _selectedStatuses.contains(r.status);
      return inRange && statusOk;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _pickCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final initial = _customRange ??
        DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
        );
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      initialDateRange: initial,
    );
    if (picked != null) {
      setState(() {
        _range = 'custom';
        _customRange = picked;
      });
    }
  }

  Future<void> _openStatusFilter(BuildContext context, TapDownDetails details) async {
    const options = [
      'Mngr. Pending',
      'Mngr. Approved',
      'HR Pending',
      'HR Approved',
      'Pending Payroll',
      'In Progress Payroll',
      'Released Payroll',
      'Processed Payroll',
    ];
    final tempSelected = Set<String>.from(_selectedStatuses);

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromLTWH(
        details.globalPosition.dx,
        details.globalPosition.dy,
        0,
        0,
      ),
      Offset.zero & overlay.size,
    );

    await showMenu<int>(
      context: context,
      position: position,
      items: [
        PopupMenuItem<int>(
          enabled: false,
          child: SizedBox(
            width: 260,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Status',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedStatuses.clear();
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Clear all',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 260,
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (_, index) {
                      final label = options[index];
                      final selected = tempSelected.contains(label);
                      return CheckboxListTile(
                        value: selected,
                        dense: true,
                        onChanged: (v) {
                          setState(() {
                            if (v == true) {
                              tempSelected.add(label);
                            } else {
                              tempSelected.remove(label);
                            }
                            _selectedStatuses
                              ..clear()
                              ..addAll(tempSelected);
                          });
                        },
                        title: Text(
                          label,
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
          // Simple colored header bar
          Container(
            color: headerColor,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              children: [
                Text(
                  'Attendance',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Current status card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_filled_rounded,
                        size: 40,
                        color: headerColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _hasCurrentTimeIn ? 'You are currently timed in' : 'No Current Time In',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Started at 0:00 AM',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _handleFaceAction(context, 'Time In'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Time In',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _handleFaceAction(context, 'Time Out'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Time Out',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_lastAction != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Last action: $_lastAction',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // History / Offline toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showHistory = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: _showHistory ? headerColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'History',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _showHistory ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showHistory = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: !_showHistory ? headerColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Offline',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: !_showHistory ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                if (_showHistory)
                  // History card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attendance History',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() {
                                _range = '7';
                                _customRange = null;
                              }),
                              child: _HistoryChip(
                                label: 'Last 7 Days',
                                selected: _range == '7',
                                color: headerColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setState(() {
                                _range = '30';
                                _customRange = null;
                              }),
                              child: _HistoryChip(
                                label: 'Last 30 Days',
                                selected: _range == '30',
                                color: headerColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setState(() => _range = 'custom'),
                              child: _HistoryChip(
                                label: 'Custom',
                                selected: _range == 'custom',
                                color: headerColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Filter row (date range only for Custom)
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTapDown: (details) => _openStatusFilter(context, details),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.divider),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.filter_list_rounded,
                                        size: 16,
                                        color: AppColors.textMuted,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _selectedStatuses.isEmpty
                                              ? 'Filter Status'
                                              : '${_selectedStatuses.length} selected',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (_range == 'custom') ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: _DateFieldPlaceholder(
                                  label: _customRange == null
                                      ? 'Date From'
                                      : '${_customRange!.start.toLocal()}'.split(' ')[0],
                                  onTap: () => _pickCustomRange(context),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _DateFieldPlaceholder(
                                  label: _customRange == null
                                      ? 'Date To'
                                      : '${_customRange!.end.toLocal()}'.split(' ')[0],
                                  onTap: () => _pickCustomRange(context),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (_range == 'custom') ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _customRange = null;
                                      _selectedStatuses.clear();
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.textSecondary,
                                    side: const BorderSide(color: AppColors.divider),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Clear Filter',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Filtering is reactive; this just triggers a rebuild.
                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: headerColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Apply Filter',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        // Filtered records
                        if (_filteredRecords.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'No records found in this section yet',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          )
                        else
                          Column(
                            children: _filteredRecords
                                .map((r) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: _HistoryRecordCard(record: r),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  )
                else
                  // Offline card
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.delete_rounded, size: 16, color: AppColors.textMuted),
                                const SizedBox(width: 6),
                                Text(
                                  'Delete Synced Records',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _DateFieldPlaceholder(label: 'Date From'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _DateFieldPlaceholder(label: 'Date To'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6B6B),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Delete Synced Range',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.wifi_off_rounded, size: 16, color: AppColors.textMuted),
                                const SizedBox(width: 6),
                                Text(
                                  'Offline Records (Time-In)',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Time-in records saved while offline, pending sync',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Example offline record rows
                            _OfflineRecordTile(date: '2025-12-26', time: '07:22 AM'),
                            const SizedBox(height: 8),
                            _OfflineRecordTile(date: '2025-12-29', time: '08:02 AM'),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Sync All Records',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const AppBottomNavBar(),
        ],
      ),
    );
  }
}

class _DateFieldPlaceholder extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _DateFieldPlaceholder({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineRecordTile extends StatelessWidget {
  final String date;
  final String time;

  const _OfflineRecordTile({required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'In: $time',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Pending Sync',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFF97316),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceRecord {
  final DateTime date;
  final String status;
  final double normalHours;
  final double overtimeHours;

  const _AttendanceRecord({
    required this.date,
    required this.status,
    required this.normalHours,
    required this.overtimeHours,
  });
}

class _HistoryRecordCard extends StatelessWidget {
  final _AttendanceRecord record;

  const _HistoryRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final dateStr = '${record.date.toLocal()}'.split(' ')[0];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  record.status,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _metricRow('Normal Hours', record.normalHours),
                    _metricRow('Overtime Hours', record.overtimeHours),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _metricRow('Night Differential', 0),
                    _metricRow('Public Holiday', 0),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// ignore: camel_case_types

// ignore: camel_case_types
class _metricRow extends StatelessWidget {
  final String label;
  final double value;

  const _metricRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;

  const _HistoryChip({
    required this.label,
    required this.selected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? color.withValues(alpha: 0.12) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
        border: selected ? Border.all(color: color, width: 1) : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected ? color : AppColors.textSecondary,
        ),
      ),
    );
  }
}

