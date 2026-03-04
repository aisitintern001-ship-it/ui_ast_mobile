import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/company_selection_screen.dart';
import 'screens/attendance_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const ASTDashboardApp(),
    ),
  );
}

class ASTDashboardApp extends StatelessWidget {
  const ASTDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AST Dashboard',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const MainShell());
          case '/company-selection':
            return MaterialPageRoute(builder: (_) => const CompanySelectionScreen());
          default:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
      },
    );
  }
}

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    switch (state.currentNavIndex) {
      case 0:
        return const AttendanceScreen();
      case 1:
        return const HomeScreen();
      case 2:
        return const _SettingsPlaceholder();
      default:
        return const HomeScreen();
    }
  }
}

class _SettingsPlaceholder extends StatelessWidget {
  const _SettingsPlaceholder();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            color: state.headerColor,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              children: [
                Text(
                  'Settings',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings, size: 64, color: AppColors.textMuted),
                  SizedBox(height: 16),
                  Text(
                    '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Coming soon',
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
          const _SettingsBottomNav(),
        ],
      ),
    );
  }
}

class _SettingsBottomNav extends StatelessWidget {
  const _SettingsBottomNav();

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
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = state.currentNavIndex == index;
          return GestureDetector(
            onTap: () => state.setNavIndex(index),
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
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? headerColor : AppColors.textMuted,
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
