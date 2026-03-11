import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusPill extends StatelessWidget {
  final String status;

  const StatusPill({super.key, required this.status});

  static _StatusStyle _styleFor(String status) {
    switch (status) {
      case 'Mngr. Pending':
        return _StatusStyle(bg: const Color(0xFFFFF7ED), dot: const Color(0xFFF97316), text: const Color(0xFFEA6F00));
      case 'Mngr. Approved':
        return _StatusStyle(bg: const Color(0xFFEFF6FF), dot: const Color(0xFF3B82F6), text: const Color(0xFF2563EB), check: true);
      case 'HR Pending':
        return _StatusStyle(bg: const Color(0xFFFFFBEB), dot: const Color(0xFFF59E0B), text: const Color(0xFFD97706));
      case 'HR Approved':
        return _StatusStyle(bg: const Color(0xFFEFF6FF), dot: const Color(0xFF3B82F6), text: const Color(0xFF2563EB));
      case 'Pending Payroll':
        return _StatusStyle(bg: const Color(0xFFFFF7ED), dot: const Color(0xFFF97316), text: const Color(0xFFEA6F00));
      case 'In Progress Payroll':
        return _StatusStyle(bg: const Color(0xFFF5F3FF), dot: const Color(0xFF8B5CF6), text: const Color(0xFF7C3AED));
      case 'Released Payroll':
        return _StatusStyle(bg: const Color(0xFFECFDF5), dot: const Color(0xFF10B981), text: const Color(0xFF059669));
      case 'Processed Payroll':
        return _StatusStyle(bg: const Color(0xFFECFDF5), dot: const Color(0xFF22C55E), text: const Color(0xFF16A34A), check: true);
      case 'Approved':
        return _StatusStyle(bg: const Color(0xFFECFDF5), dot: const Color(0xFF22C55E), text: const Color(0xFF16A34A), check: true);
      case 'Denied':
        return _StatusStyle(bg: const Color(0xFFFEF2F2), dot: const Color(0xFFEF4444), text: const Color(0xFFDC2626));
      default:
        return _StatusStyle(bg: const Color(0xFFF3F4F6), dot: const Color(0xFF9CA3AF), text: const Color(0xFF6B7280));
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: style.dot,
              shape: BoxShape.circle,
            ),
            child: style.check
                ? const Icon(Icons.check, size: 6, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: style.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  final Color bg;
  final Color dot;
  final Color text;
  final bool check;
  const _StatusStyle({required this.bg, required this.dot, required this.text, this.check = false});
}
