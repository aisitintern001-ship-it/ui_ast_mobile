import 'package:flutter/material.dart';
import '../widgets/offline_tab_widget.dart';

class AttendanceOffline extends StatelessWidget {
  final List<OfflineRecordItem> items;
  final VoidCallback? onSyncAll;
  final VoidCallback? onDeleteRange;

  const AttendanceOffline({
    super.key,
    required this.items,
    this.onSyncAll,
    this.onDeleteRange,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // Fixed height to allow scrolling inner area if needed
      child: OfflineTabWidget(
        key: const ValueKey("offline"),
        items: items,
        onSyncAll: onSyncAll,
        onDeleteRange: onDeleteRange,
      ),
    );
  }
}
