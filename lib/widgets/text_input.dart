import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class AppTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool filled;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final bool obscureText;
  final int maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool isDense;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;

  const AppTextInput({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.style,
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.filled = false,
    this.fillColor,
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.onChanged,
    this.isDense = false,
    this.readOnly = false,
    this.onTap,
    this.textInputAction,
  }) : assert(
         !(controller != null && initialValue != null),
         'Provide either controller or initialValue, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.divider),
    );

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      readOnly: readOnly,
      onTap: onTap,
      style:
          style ??
          GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            hintStyle ??
            GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: filled,
        fillColor: fillColor,
        isDense: isDense,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: border ?? defaultBorder,
        enabledBorder: enabledBorder ?? border ?? defaultBorder,
        focusedBorder: focusedBorder ?? border ?? defaultBorder,
      ),
    );
  }
}
