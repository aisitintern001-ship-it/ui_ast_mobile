import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AvailableLeaveModal extends StatelessWidget {
  const AvailableLeaveModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                Expanded(
                  child: Text(
                    "Available Leave",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Below is the total available leave you have accumulated.",
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            // Leave Types List
            _buildLeaveRow(
              "Service Incentive Leave", 
              "0.00", 
              Icons.notification_add_rounded, // Matches the tree icon in wireframe
              const Color(0xFFE0F2FE),
              const Color(0xFF0284C7),
            ),
            const SizedBox(height: 12),
            _buildLeaveRow(
              "Leave Without Pay", 
              "0.12", 
              Icons.coffee_outlined, // Matches the coffee cup icon in wireframe
              const Color(0xFFF0F9FF),
              const Color(0xFF0369A1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveRow(String title, String days, IconData icon, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        // ignore: deprecated_member_use
        border: Border.all(color: textColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: textColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                days,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              Text(
                "days",
                style: GoogleFonts.inter(
                  fontSize: 10,
                  // ignore: deprecated_member_use
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}