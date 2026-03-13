import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OfflineRecordItem {
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;

  const OfflineRecordItem({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
  });
}

class OfflineTabWidget extends StatelessWidget {
  final List<OfflineRecordItem> items;
  final VoidCallback? onSyncAll;
  final VoidCallback? onDeleteRange;

  const OfflineTabWidget({
    super.key,
    required this.items,
    this.onSyncAll,
    this.onDeleteRange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delete Synced Records Section
                Row(
                  children: [
                    const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text("Delete Synced Records", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildDatePicker("Date From")),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDatePicker("Date To")),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: onDeleteRange ?? () {},
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: Text("Delete Synced Range", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 32),

                // Offline Records List
                Row(
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.black87, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Offline Records", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("Records saved while offline, pending sync", style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...items.map((item) => _buildOfflineCard(item)),
              ],
            ),
          ),
        ),
        
        // Sync All Button docked at bottom
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C48C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              onPressed: onSyncAll ?? () {},
              child: Text("Sync All Records", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String hint) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Expanded(
            child: Text(hint, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineCard(OfflineRecordItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                Text(item.subtitle, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: item.status == "Sync Failed" ? item.statusColor : Colors.white,
              border: item.status == "Pending Sync" ? Border.all(color: item.statusColor) : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item.status,
              style: GoogleFonts.inter(
                color: item.status == "Sync Failed" ? Colors.white : item.statusColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}