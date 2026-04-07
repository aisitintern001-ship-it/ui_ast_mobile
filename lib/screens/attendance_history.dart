import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/status_pill.dart';

class AttendanceHistory extends StatelessWidget {
  final Color headerColor;
  final String range;
  final DateTimeRange? customRange;
  final List<String> selectedStatuses;
  final List<dynamic> filteredRecords;
  final VoidCallback onClearFilter;
  final VoidCallback onApplyFilter;
  final Function(BuildContext, TapDownDetails) onOpenStatusFilter;
  final Function(BuildContext) onPickCustomRange;

  const AttendanceHistory({
    super.key,
    required this.headerColor,
    required this.range,
    required this.customRange,
    required this.selectedStatuses,
    required this.filteredRecords,
    required this.onClearFilter,
    required this.onApplyFilter,
    required this.onOpenStatusFilter,
    required this.onPickCustomRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Attendance History', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              GestureDetector(
                onTap: () => onApplyFilter(),
                child: _HistoryChip(label: 'Last 7 Days', selected: range == '7', color: headerColor),
              ),
              GestureDetector(
                onTap: () => onApplyFilter(),
                child: _HistoryChip(label: 'Last 30 Days', selected: range == '30', color: headerColor),
              ),
              GestureDetector(
                onTap: () => onApplyFilter(),
                child: _HistoryChip(label: 'Custom', selected: range == 'custom', color: headerColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (selectedStatuses.isNotEmpty) ...[
            Wrap(
              spacing: 4, runSpacing: 4,
              children: selectedStatuses.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE5F2FF), borderRadius: BorderRadius.circular(999)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(s, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textPrimary)),
                      const SizedBox(width: 4),
                      GestureDetector(onTap: onClearFilter, child: const Icon(Icons.close_rounded, size: 14, color: AppColors.textMuted)),
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
                  onTapDown: (details) => onOpenStatusFilter(context, details),
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
              if (range == 'custom') ...[
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onPickCustomRange(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.divider)),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Expanded(child: Text(customRange == null ? 'Date From' : '${customRange!.start.toLocal()}'.split(' ')[0], style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onPickCustomRange(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.divider)),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Expanded(child: Text(customRange == null ? 'Date To' : '${customRange!.end.toLocal()}'.split(' ')[0], style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (range == 'custom') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onClearFilter,
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSecondary, side: const BorderSide(color: AppColors.divider), padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text('Clear Filter', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApplyFilter,
                    style: ElevatedButton.styleFrom(backgroundColor: headerColor, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text('Apply Filter', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
          if (filteredRecords.isEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
              child: Text('No records found in this section yet', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
            )
          else
            Column(
              children: filteredRecords.map((r) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _HistoryRecordCard(record: r))).toList(),
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
  const _HistoryChip({required this.label, required this.selected, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? color.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: selected ? color : AppColors.divider),
      ),
      child: Text(label, style: GoogleFonts.inter(fontSize: 12, color: selected ? color : AppColors.textSecondary)),
    );
  }
}

class _HistoryRecordCard extends StatelessWidget {
  final dynamic record;
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
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(width: 4),
          Text(value.toString(), style: GoogleFonts.inter(fontSize: 11, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
