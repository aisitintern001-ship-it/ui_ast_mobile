import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AddButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF2181FF),
      elevation: 4,
      icon: const Icon(Icons.add, color: Colors.white, size: 18),
      label: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}