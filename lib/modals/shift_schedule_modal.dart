import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShiftScheduleModal extends StatelessWidget {
  const ShiftScheduleModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Shift Schedule",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF334155),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                ),
              ],
            ),
            Text(
              "You can see you available shift schedule here:",
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            // Schedule List
            _buildShiftRow("Monday", "08:00 AM - 5:00 PM", isWorkDay: true),
            _buildShiftRow("Tuesday", "08:00 AM - 5:00 PM", isWorkDay: true),
            _buildShiftRow("Wednesday", "08:00 AM - 5:00 PM", isWorkDay: true),
            _buildShiftRow("Thursday", "08:00 AM - 5:00 PM", isWorkDay: true),
            _buildShiftRow("Friday", "08:00 AM - 5:00 PM", isWorkDay: true),
            _buildShiftRow("Saturday", "Day Off", isWorkDay: false),
            _buildShiftRow("Sunday", "Day Off", isWorkDay: false),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftRow(String day, String time, {required bool isWorkDay}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: isWorkDay ? const Color(0xFFE0F2FE).withOpacity(0.5) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isWorkDay ? const Color(0xFF7DD3FC) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: isWorkDay ? const Color(0xFF0284C7) : Colors.grey.shade400,
          ),
          const SizedBox(width: 12),
          Text(
            day,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isWorkDay ? const Color(0xFF0369A1) : Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontStyle: isWorkDay ? FontStyle.normal : FontStyle.italic,
              color: isWorkDay ? const Color(0xFF0284C7) : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}