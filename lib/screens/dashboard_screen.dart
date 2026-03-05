import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/header_widgets.dart';
import '../widgets/dashboard_section.dart';
import '../widgets/bottom_nav.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          DashboardHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Summary cards
                Text(
                  'My Dashboard',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // Stats row
                Row(
                  children: [
                    _StatCard(
                      label: 'Pending',
                      count: state.pendingCount,
                      color: AppColors.statusPending,
                      icon: Icons.hourglass_empty_rounded,
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      label: 'Approved',
                      count: state.approvedCount,
                      color: AppColors.statusApproved,
                      icon: Icons.check_circle_rounded,
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      label: 'In Review',
                      count: state.sentForReviewCount,
                      color: AppColors.statusSentReview,
                      icon: Icons.rate_review_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Full dashboard section
                SizedBox(
  height: 260, // fixed height to keep layout stable
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.divider),
    ),
    child: const DashboardSection(),
  ),
),
              ],
            ),
          ),
          const AppBottomNavBar(),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
