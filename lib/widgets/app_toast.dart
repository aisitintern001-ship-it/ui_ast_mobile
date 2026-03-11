import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable toast notification that appears at the top of the screen.
///
/// Usage:
/// ```dart
/// AppToast.show(context, type: ToastType.success, message: 'Time In was successfully recorded!');
/// AppToast.show(context, type: ToastType.error, message: 'Face verification failed. Please try again.');
/// ```
class AppToast {
  static void show(
    BuildContext context, {
    required ToastType type,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        type: type,
        message: message,
        title: title,
        duration: duration,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
}

enum ToastType { success, error }

class _ToastWidget extends StatefulWidget {
  final ToastType type;
  final String message;
  final String? title;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.type,
    required this.message,
    this.title,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.type == ToastType.success;
    final color = isSuccess ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final bgColor = isSuccess ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2);
    final borderColor = isSuccess ? const Color(0xFF6EE7B7) : const Color(0xFFFCA5A5);
    final icon = isSuccess ? Icons.check_circle : Icons.cancel;

    return Positioned(
      top: MediaQuery.of(context).padding.top + kToolbarHeight + 4,
      left: 12,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 16),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title ?? (isSuccess ? 'Success' : 'Failed'),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      if (widget.message.isNotEmpty) ...[
                        const SizedBox(height: 1),
                        Text(
                          widget.message,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
