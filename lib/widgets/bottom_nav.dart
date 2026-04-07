import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Import all your main screens here so the Nav Bar can open them:
import '../screens/attendance_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final headerColor = state.headerColor;

    final items = [
      {'icon': Icons.calendar_month_rounded, 'label': 'Attendance'},
      {'icon': LucideIcons.house, 'label': 'Home'},
      {'icon': LucideIcons.settings, 'label': 'Settings'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = state.currentNavIndex == index;
          return _AnimatedNavItem(
            icon: items[index]['icon'] as IconData,
            label: items[index]['label'] as String,
            isSelected: isSelected,
            headerColor: headerColor,
            onTap: () {
              if (isSelected) return;
              
              // Haptic feedback
              HapticFeedback.lightImpact();

              state.setNavIndex(index);

              Widget nextScreen;
              if (index == 0) {
                nextScreen = const AttendanceScreen();
              } else if (index == 1) {
                nextScreen = const HomeScreen();
              } else {
                nextScreen = const SettingsScreen();
              }

              // Smooth fade transition between tabs
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
                  transitionDuration: const Duration(milliseconds: 200),
                  reverseTransitionDuration: const Duration(milliseconds: 150),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      ),
                      child: child,
                    );
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class _AnimatedNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color headerColor;
  final VoidCallback onTap;

  const _AnimatedNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.headerColor,
    required this.onTap,
  });

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: widget.isSelected ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 1.0 + (value * 0.1),
                    child: Icon(
                      widget.icon,
                      size: 24,
                      color: Color.lerp(
                        AppColors.textMuted,
                        widget.headerColor,
                        value,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 3),
              // Animated label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: widget.isSelected ? widget.headerColor : AppColors.textMuted,
                ),
                child: Text(
                  widget.label,
                  textScaler: TextScaler.noScaling,
                ),
              ),
              const SizedBox(height: 2),
              // Animated indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: widget.isSelected ? 20 : 0,
                height: 2,
                decoration: BoxDecoration(
                  color: widget.headerColor,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}