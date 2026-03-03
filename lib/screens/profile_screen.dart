import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/header_widgets.dart';
import '../widgets/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final headerColor = state.headerColor;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          DashboardHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile card
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: headerColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              state.currentUser.initials,
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.currentUser.name,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.currentUser.email,
                          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: headerColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            state.currentUser.role,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: headerColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Theme color picker
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme Color',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            AppColors.headerOrange,
                            AppColors.headerBlue,
                            AppColors.headerGreen,
                            AppColors.headerTeal,
                            const Color(0xFF7C3AED),
                            const Color(0xFFDB2777),
                          ].map((color) {
                          final isSelected = state.headerColor == color;
                            return GestureDetector(
                              onTap: () => state.setHeaderColor(color),
                              child: Container(
                                width: 36,
                                height: 36,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: isSelected
                                      ? Border.all(color: AppColors.textPrimary, width: 2)
                                      : null,
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Settings menu
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        _SettingsItem(
                          icon: Icons.person_outline_rounded,
                          title: 'Edit Profile',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.security_rounded,
                          title: 'Security',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.help_outline_rounded,
                          title: 'Help & Support',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: Icons.info_outline_rounded,
                          title: 'About',
                          onTap: () {},
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Logout
                  Container(
                    color: Colors.white,
                    child: _SettingsItem(
                      icon: Icons.logout_rounded,
                      title: 'Sign Out',
                      textColor: AppColors.dangerRed,
                      iconColor: AppColors.dangerRed,
                      showDivider: false,
                      onTap: () {
                        state.logout();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'AST Dashboard v1.0.0',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const AppBottomNavBar(),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;
  final bool showDivider;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: iconColor ?? AppColors.textSecondary),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: textColor ?? AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (textColor == null)
                  const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 50),
      ],
    );
  }
}
