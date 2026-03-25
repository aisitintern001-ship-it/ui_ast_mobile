import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class CustomerTabListCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onRemove;

  const CustomerTabListCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 18, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
