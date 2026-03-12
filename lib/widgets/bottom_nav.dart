import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';

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
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.settings_rounded, 'label': 'Settings'},
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
          return GestureDetector(
            onTap: () {
              // 1. Do nothing if the user clicks the tab they are already on
              if (isSelected) return;

              // 2. Update the state so the icon changes color instantly
              state.setNavIndex(index);

              // 3. Determine which screen to open based on the index
              Widget nextScreen;
              if (index == 0) {
                nextScreen = const AttendanceScreen();
              } else if (index == 1) {
                nextScreen = const HomeScreen();
              } else {
                nextScreen = const SettingsScreen();
              }

              // 4. Navigate to the new screen without the "slide" animation so it feels like a tab switch
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => nextScreen,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[index]['icon'] as IconData,
                    size: 24,
                    color: isSelected ? headerColor : AppColors.textMuted,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    items[index]['label'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? headerColor : AppColors.textMuted,
                    ),
                    textScaler: TextScaler.noScaling,
                  ),
                  const SizedBox(height: 2),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 20 : 0,
                    height: 2,
                    decoration: BoxDecoration(
                      color: headerColor,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}