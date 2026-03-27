import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_toast.dart';
import '../widgets/status_pill.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/offline_tab_widget.dart'; // <-- ADDED
import 'face_recognition_screen.dart';
import 'home_screen.dart';

class AttendanceScreen extends StatefulWidget {
  final bool initialShowHistory;
  final bool fromDataIntegration;

  const AttendanceScreen({
    super.key,
    this.initialShowHistory = true,
    this.fromDataIntegration = false,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _hasCurrentTimeIn = false;
  String? _lastAction; // 'Time In' or 'Time Out'
  bool _showFailed = false; // true when attendance fails
  String? _failedAction; // which action failed
  
  late bool _showHistory; // true = History, false = Offline
  
  String _range = '7'; // '7', '30', 'custom'
  DateTimeRange? _customRange;
  final List<String> _selectedStatuses = ['Mngr. Approved', 'Processed Payroll'];

  final List<_AttendanceRecord> _records = [
    _AttendanceRecord(date: DateTime(2026, 1, 20), status: 'Mngr. Approved', normalHours: 8, overtimeHours: 1.25),
    _AttendanceRecord(date: DateTime(2026, 1, 19), status: 'Mngr. Approved', normalHours: 8, overtimeHours: 0),
    _AttendanceRecord(date: DateTime(2026, 1, 18), status: 'Processed Payroll', normalHours: 8, overtimeHours: 0.5),
  ];

  @override
  void initState() {
    super.initState();
    _showHistory = widget.initialShowHistory;
  }

  Future<void> _handleFaceAction(String action) async {
    final result = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => FaceRecognitionScreen(mode: action)));
    if (!mounted) return;
    if (result == true) {
      setState(() {
        _lastAction = action;
        _hasCurrentTimeIn = action == 'Time In';
        _showFailed = false;
        _failedAction = null;
      });
      if (mounted) {
        AppToast.show(context, type: ToastType.success, title: '$action Record Successfully', message: '$action was successfully recorded!');
      }
    } else {
      setState(() {
        _showFailed = true;
        _failedAction = action;
      });
      if (mounted) {
        AppToast.show(context, type: ToastType.error, title: '$action Failed', message: 'Face verification failed. Please try again.');
      }
    }
  }

  List<_AttendanceRecord> get _filteredRecords {
    final now = DateTime.now();
    DateTime from; DateTime to;
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
      final statusOk = _selectedStatuses.isEmpty || _selectedStatuses.contains(r.status);
      return inRange && statusOk;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _pickCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final initial = _customRange ?? DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now);
    final picked = await showDateRangePicker(context: context, firstDate: DateTime(now.year - 2), lastDate: DateTime(now.year + 2), initialDateRange: initial);
    if (picked != null) {
      setState(() {
        _range = 'custom';
        _customRange = picked;
      });
    }
  }

  Future<void> _openStatusFilter(BuildContext context, TapDownDetails details) async {
    const options = ['Mngr. Pending', 'Mngr. Approved', 'HR Pending', 'HR Approved', 'Pending Payroll', 'In Progress Payroll', 'Released Payroll', 'Processed Payroll'];
    final tempSelected = Set<String>.from(_selectedStatuses);
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(Rect.fromLTWH(details.globalPosition.dx, details.globalPosition.dy, 0, 0), Offset.zero & overlay.size);

    await showMenu<int>(
      context: context, position: position,
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
                    Text('Filter Status', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                    TextButton(
                      onPressed: () {
                        setState(() => _selectedStatuses.clear());
                        Navigator.of(context).pop();
                      },
                      child: Text('Clear all', style: GoogleFonts.inter(fontSize: 12, color: Colors.red)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 260,
                  child: StatefulBuilder(
                    builder: (ctx, localSetState) {
                      return ListView.builder(
                        itemCount: options.length,
                        itemBuilder: (_, index) {
                          final label = options[index];
                          final selected = tempSelected.contains(label);
                          return InkWell(
                            onTap: () {
                              localSetState(() {
                                if (selected) {
                                  tempSelected.remove(label);
                                } else {
                                  tempSelected.add(label);
                                }
                              });
                              setState(() {
                                _selectedStatuses..clear()..addAll(tempSelected);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18, height: 18,
                                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: selected ? const Color(0xFF2181FF) : AppColors.textMuted, width: 1.5)),
                                    child: selected ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF2181FF), shape: BoxShape.circle))) : null,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 13))),
                                ],
                              ),
                            ),
                          );
                        },
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
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  headerColor,
                  headerColor.withValues(alpha: 0.85),
                ],
              ),
            ),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () {
                    if (widget.fromDataIntegration) {
                      Navigator.pop(context);
                    } else {
                      context.read<AppState>().setNavIndex(1);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
                    }
                  },
                ),
                const SizedBox(width: 4),
                Text('Attendance', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
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
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time_filled_rounded, size: 40, color: headerColor),
                      const SizedBox(height: 8),
                      Text(_hasCurrentTimeIn ? 'You are currently timed in' : 'No Current Time In', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text('Started at 0:00 AM', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _handleFaceAction('Time In'),
                              icon: const Icon(Icons.access_time_rounded, size: 18),
                              label: Text('Time In', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _handleFaceAction('Time Out'),
                              icon: const Icon(Icons.access_time_rounded, size: 18),
                              label: Text('Time Out', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        ],
                      ),
                      if (_showFailed) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity, padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFECACA))),
                          child: Column(
                            children: [
                              Container(width: 48, height: 48, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEF4444)), child: const Icon(Icons.close_rounded, size: 28, color: Colors.white)),
                              const SizedBox(height: 12),
                              Text('${_failedAction ?? "Attendance"} Failed', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFFEF4444))),
                              const SizedBox(height: 4),
                              Text('Face verification could not be completed.\nPlease try again.', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6B7280), height: 1.4)),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (_failedAction != null) _handleFaceAction(_failedAction!);
                                  },
                                  icon: const Icon(Icons.refresh_rounded, size: 18),
                                  label: Text('Try Again', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => setState(() { _showFailed = false; _failedAction = null; }),
                                child: Text('Dismiss', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF6B7280), decoration: TextDecoration.underline)),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (_lastAction != null) ...[
                        const SizedBox(height: 12),
                        Text('Last action: $_lastAction', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // History / Offline toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.divider)),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showHistory = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(color: _showHistory ? headerColor : Colors.transparent, borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.history_rounded, size: 16, color: _showHistory ? Colors.white : AppColors.textMuted),
                                const SizedBox(width: 6),
                                Text('History', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: _showHistory ? Colors.white : AppColors.textSecondary)),
                              ],
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
                            decoration: BoxDecoration(color: !_showHistory ? headerColor : Colors.transparent, borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.wifi_off_rounded, size: 16, color: !_showHistory ? Colors.white : AppColors.textMuted),
                                const SizedBox(width: 6),
                                Text('Offline', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: !_showHistory ? Colors.white : AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                if (_showHistory)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Attendance History', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: [
                            GestureDetector(onTap: () => setState(() { _range = '7'; _customRange = null; }), child: _HistoryChip(label: 'Last 7 Days', selected: _range == '7', color: headerColor)),
                            GestureDetector(onTap: () => setState(() { _range = '30'; _customRange = null; }), child: _HistoryChip(label: 'Last 30 Days', selected: _range == '30', color: headerColor)),
                            GestureDetector(onTap: () => setState(() => _range = 'custom'), child: _HistoryChip(label: 'Custom', selected: _range == 'custom', color: headerColor)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_selectedStatuses.isNotEmpty) ...[
                          Wrap(
                            spacing: 4, runSpacing: 4,
                            children: _selectedStatuses.map((s) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFE5F2FF), borderRadius: BorderRadius.circular(999)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(s, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textPrimary)),
                                    const SizedBox(width: 4),
                                    GestureDetector(onTap: () => setState(() => _selectedStatuses.remove(s)), child: const Icon(Icons.close_rounded, size: 14, color: AppColors.textMuted)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTapDown: (details) => _openStatusFilter(context, details),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.divider)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.filter_list_rounded, size: 16, color: AppColors.textMuted),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text('Filter Status', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
                                      const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textMuted),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (_range == 'custom') ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _pickCustomRange(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.divider)),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textMuted),
                                        const SizedBox(width: 6),
                                        Expanded(child: Text(_customRange == null ? 'Date From' : '${_customRange!.start.toLocal()}'.split(' ')[0], style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted), overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _pickCustomRange(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.divider)),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textMuted),
                                        const SizedBox(width: 6),
                                        Expanded(child: Text(_customRange == null ? 'Date To' : '${_customRange!.end.toLocal()}'.split(' ')[0], style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted), overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  ),
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
                                  onPressed: () => setState(() { _customRange = null; _selectedStatuses.clear(); }),
                                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSecondary, side: const BorderSide(color: AppColors.divider), padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  child: Text('Clear Filter', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => setState(() {}),
                                  style: ElevatedButton.styleFrom(backgroundColor: headerColor, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  child: Text('Apply Filter', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (_filteredRecords.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
                            child: Text('No records found in this section yet', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                          )
                        else
                          Column(
                            children: _filteredRecords.map((r) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _HistoryRecordCard(record: r))).toList(),
                          ),
                      ],
                    ),
                  )
                else
                  // --- CALL TO OUR NEW REUSABLE OFFLINE WIDGET ---
                  SizedBox(
                    height: 400, // Fixed height to allow scrolling inner area if needed
                    child: OfflineTabWidget(
                      key: const ValueKey("offline"),
                      items: [
                        OfflineRecordItem(title: "2025-12-26", subtitle: "In: 07:22 AM", status: "Pending Sync", statusColor: Colors.amber.shade700),
                        OfflineRecordItem(title: "2025-12-29", subtitle: "In: 08:02 AM", status: "Pending Sync", statusColor: Colors.amber.shade700),
                      ],
                      onSyncAll: () {},
                      onDeleteRange: () {},
                    ),
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

class _AttendanceRecord {
  final DateTime date;
  final String status;
  final double normalHours;
  final double overtimeHours;
  const _AttendanceRecord({required this.date, required this.status, required this.normalHours, required this.overtimeHours});
}

class _HistoryRecordCard extends StatelessWidget {
  final _AttendanceRecord record;
  const _HistoryRecordCard({required this.record});
  @override
  Widget build(BuildContext context) {
    final dateStr = '${record.date.toLocal()}'.split(' ')[0];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(child: Text(dateStr, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 8),
              StatusPill(status: record.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ _MetricRow('Normal Hours', record.normalHours), _MetricRow('Overtime Hours', record.overtimeHours) ])),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [ _MetricRow('Night Differential', 0), _MetricRow('Public Holiday', 0) ])),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final double value;
  const _MetricRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary))),
          Text(value.toStringAsFixed(2), style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _HistoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  const _HistoryChip({required this.label, required this.selected, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? color.withValues(alpha: 0.12) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
        border: selected ? Border.all(color: color, width: 1) : null,
      ),
      child: Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: selected ? FontWeight.w600 : FontWeight.w500, color: selected ? color : AppColors.textSecondary)),
    );
  }
}