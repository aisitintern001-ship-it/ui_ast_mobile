import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import 'team_members_screen.dart';
import 'member_timesheet_screen.dart';
import 'team_leave_requests_screen.dart';
import 'expense_claim_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TeamManagementScreen extends StatelessWidget {
  const TeamManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final headerColor = context.watch<AppState>().headerColor;

    final items = [
      {
        'icon': Icons.access_time_rounded,
        'iconColor': AppColors.headerOrange,
        'title': 'Team Members',
        'subtitle': 'View and manage team members',
        'screen': const TeamMembersScreen(),
      },
      {
        'icon': Icons.people_alt_outlined,
        'iconColor': AppColors.headerOrange,
        'title': 'Member Timesheet',
        'subtitle': 'Review team attendance records',
        'screen': const MemberTimesheetScreen(),
      },
      {
        'icon': Icons.cases_outlined,
        'iconColor': AppColors.headerOrange,
        'title': 'Leave',
        'subtitle': 'Manage team leave requests',
        'screen': const TeamLeaveRequestsScreen(),
      },
      {
        'icon': LucideIcons.dollarSign,
        'iconColor': AppColors.headerOrange,
        'title': 'Expense Claim Approval',
        'subtitle': 'Review expense claims',
        'screen': ExpenseClaimScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: headerColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Team Management',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return _TeamManagementTile(
            icon: item['icon'] as IconData,
            iconColor: item['iconColor'] as Color,
            title: item['title'] as String,
            subtitle: item['subtitle'] as String,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item['screen'] as Widget),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}

class _TeamManagementTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TeamManagementTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
