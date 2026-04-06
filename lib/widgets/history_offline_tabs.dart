import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryOfflineTabs extends StatelessWidget {
  final bool showHistory;
  final ValueChanged<bool> onChanged;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final double borderRadius;

  const HistoryOfflineTabs({
    super.key,
    required this.showHistory,
    required this.onChanged,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = backgroundColor ?? const Color(0xFFE5E7EB);
    final Color active = activeColor ?? Colors.white;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = (constraints.maxWidth - 12) / 2; // Account for padding and gap
        
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Stack(
            children: [
              // Animated sliding indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: showHistory ? 0 : tabWidth + 4,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: active,
                    borderRadius: BorderRadius.circular(borderRadius - 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
              // Tab buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(true),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.history_rounded,
                                key: ValueKey(showHistory),
                                size: 16,
                                color: showHistory ? Colors.black : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 6),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: showHistory ? Colors.black : Colors.grey,
                              ),
                              child: const Text('History'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(false),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.wifi_off_rounded,
                                key: ValueKey(!showHistory),
                                size: 16,
                                color: !showHistory ? Colors.black : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 6),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: !showHistory ? Colors.black : Colors.grey,
                              ),
                              child: const Text('Offline'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
