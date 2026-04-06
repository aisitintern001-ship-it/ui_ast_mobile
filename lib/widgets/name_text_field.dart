import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NameTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final ValueChanged<String>? onChanged;

  const NameTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText ?? 'Name',
        hintText: hintText ?? 'Enter your name',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      style: GoogleFonts.inter(fontSize: 14),
      onChanged: onChanged,
    );
  }
}
