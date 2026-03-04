import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/header_widgets.dart';
import '../widgets/favorites_section.dart';
import '../widgets/dashboard_section.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/news_modal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showFavoritesManagement(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          child: const FavoritesManagementSheet(),
        ),
      ),
    );
  }

  void _showNewsModal(BuildContext context, NewsItem news) {
    showDialog(
      context: context,
      builder: (_) => NewsDetailModal(news: news),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header (profile navigation removed)
          const DashboardHeader(),

          // Body scroll
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 800));
              },
              color: state.headerColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // ...removed CompanyNameSection (company selection now only in header)

                  // News banner (if any)
                  if (state.news.isNotEmpty)
                    _NewsBanner(
                      news: state.news.first,
                      onTap: () => _showNewsModal(context, state.news.first),
                    ),

                  const SizedBox(height: 8),

                  // Favorites
                  FavoritesSection(
                    onViewAll: () => _showFavoritesManagement(context),
                  ),

                  const SizedBox(height: 8),

                  // My Dashboard
                  const DashboardSection(),

                  const SizedBox(height: 8),

                  // Main Menu section
                  _MainMenuSection(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom nav
          const AppBottomNavBar(),
        ],
      ),
    );
  }
}

class _NewsBanner extends StatelessWidget {
  final NewsItem news;
  final VoidCallback onTap;

  const _NewsBanner({required this.news, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.statusPending.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.campaign_rounded, color: AppColors.statusPending, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    news.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _MainMenuSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final allItems = state.allMenuItems;
    final headerColor = state.headerColor;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Main Menu',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: headerColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Grid of all menu items
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemCount: allItems.take(8).length,
            itemBuilder: (context, index) {
              final item = allItems[index];
              final color = headerColor;
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening ${item.title}...'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(item.icon, color: color, size: 26),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
