import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ui_ast_mobile/screens/expense_claim_screen.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/header_widgets.dart';
import '../widgets/favorites_section.dart';
import '../widgets/dashboard_section.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/news_modal.dart';
import '../modals/signature_modal.dart';
import 'team_leave_requests_screen.dart';
import 'attendance_screen.dart';
import 'face_registration_screen.dart';
import 'supplier_request_screen.dart';
import 'customer_request_screen.dart';
import 'team_management_screen.dart';
import 'product_library_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showFavoritesManagement(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const FavoritesManagementSheet(),
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
    final selectedCompany =
        state.selectedCompany; // Assumes AppState has selectedCompany
    // Filter news for the selected company
    final companyNews = state.news
        .where((n) => n.companyId == selectedCompany?.id)
        .toList();

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
                  // ...existing code...
                  SizedBox(height: 16),
                  // Company News section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Company News',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (companyNews.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: AppColors.textMuted.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${companyNews.length} update${companyNews.length > 1 ? 's' : ''}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (companyNews.isNotEmpty)
                    _NewsBanner(
                      news: companyNews.first,
                      onTap: () => _showNewsModal(context, companyNews.first),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: const Color(0xFF60A5FA),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'No New Announcements Available',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'There are no new announcements at this moments. Check back later for the latest updates and news.',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Favorites
                  FavoritesSection(
                    onViewAll: () => _showFavoritesManagement(context),
                  ),

                  const SizedBox(height: 8),

                  // My Dashboard (Locked minimum height to prevent layout jumping)
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 400, // This locks the empty space just like the wireframe
                    ),
                    child: const DashboardSection(),
                  ),

                  const SizedBox(height: 16),

                  // Main Menu section
                  const _MainMenuSection(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: news.imageUrl != null
                  ? Image.asset(
                      news.imageUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        width: 48,
                        height: 48,
                        color: AppColors.statusPending.withValues(alpha: 0.12),
                        child: const Icon(
                          Icons.campaign_rounded,
                          color: AppColors.statusPending,
                          size: 22,
                        ),
                      ),
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      color: AppColors.statusPending.withValues(alpha: 0.12),
                      child: const Icon(
                        Icons.campaign_rounded,
                        color: AppColors.statusPending,
                        size: 22,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFE9E6FD),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Event',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7C4DFF),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        news.date,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (news.isImportant)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFE3E3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'NEW',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFD32F2F),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    news.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    news.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (news.attachments.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.attach_file,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${news.attachments.length} attachment${news.attachments.length > 1 ? 's' : ''}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _MainMenuSection extends StatefulWidget {
  const _MainMenuSection();

  @override
  State<_MainMenuSection> createState() => _MainMenuSectionState();
}

class _MainMenuSectionState extends State<_MainMenuSection> {
  final Map<String, bool> _expanded = {
    'employeeHub': false,
    'productLibrary': false,
    'managementConsole': false,
    'companyForms': false,
    'service': false,
    'tasks': false,
  };

  void _toggle(String key) =>
      setState(() => _expanded[key] = !(_expanded[key] ?? false));

  Widget _sectionHeader(
    String key,
    String title, {
    Widget? leading,
    bool showChevron = true,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: showChevron ? () => _toggle(key) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            ...?(leading != null ? [leading, const SizedBox(width: 12)] : null),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ...?(trailing != null ? [trailing] : null),
            if (showChevron)
              Icon(
                _expanded[key] ?? false
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                color: AppColors.textMuted,
              ),
          ],
        ),
      ),
    );
  }

  Widget _hubGrid(Color accent) {
    final items = [
      {
        'id': 'attendance',
        'title': 'Attendance',
        'icon': Icons.access_time_rounded,
      },
      {
        'id': 'leave',
        'title': 'Leave Request',
        'icon': Icons.access_time_rounded,
      },
      {
        'id': 'expense',
        'title': 'Expense Claim',
        'icon': Icons.attach_money_rounded,
      },
      {'id': 'payslip', 'title': 'Payslip', 'icon': Icons.attach_money_rounded},
      {'id': 'team', 'title': 'Team Management', 'icon': Icons.group_rounded},
    ];

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 3 items per row, wrapping as needed – matches reference UI
          const spacing = 12.0;
          final itemWidth = (constraints.maxWidth - (spacing * 2)) / 3;

          return Wrap(
            spacing: spacing,
            runSpacing: 16,
            children: items.map((it) {
              final id = it['id'] as String;
              return SizedBox(
                width: itemWidth,
                child: GestureDetector(
                  onTap: () {
                    if (id == 'attendance') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AttendanceScreen(),
                        ),
                      );
                    } else if (id == 'leave') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TeamLeaveRequestsScreen(),
                        ),
                      );
                    } else if (id == 'expense') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ExpenseClaimScreen(),
                        ),
                      );
                    } else if (id == 'team') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TeamManagementScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening ${it['title']}...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          it['icon'] as IconData,
                          color: accent,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        it['title'] as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _simpleMenuGrid(Color accent, List<Map<String, dynamic>> items) {
    final alignLeft = items.length == 1;
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: alignLeft
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceBetween,
        children: items.map((it) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (it['id'] == 'signature') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignatureModal()),
                  );
                } else if (it['id'] == 'faceReg') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FaceRegistrationScreen()),
                  );
                } else if (it['id'] == 'supplierRequest') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SupplierRequestScreen()),
                  );
                } else if (it['id'] == 'customerRequest') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomerRequestScreen()),
                  );
                } else if (it['id'] == 'product') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProductLibraryScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening ${it['title']}...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: alignLeft
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      it['icon'] as IconData,
                      color: accent,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    it['title'] as String,
                    textAlign: alignLeft ? TextAlign.left : TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = context.watch<AppState>().headerColor;

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Main Menu',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Employee Hub
          _sectionHeader(
            'employeeHub',
            'Employee Hub',
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: headerColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.people_alt_rounded,
                color: headerColor,
                size: 20,
              ),
            ),
            showChevron: true,
          ),
          if (_expanded['employeeHub'] == true) _hubGrid(headerColor),

          const SizedBox(height: 12),

          // Product Library
          _sectionHeader(
            'productLibrary',
            'Product Library',
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: headerColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.inventory_2_rounded,
                color: headerColor,
                size: 20,
              ),
            ),
          ),
          if (_expanded['productLibrary'] == true)
            _simpleMenuGrid(headerColor, [
              {
                'id': 'product',
                'title': 'Product',
                'icon': Icons.inventory_2_rounded,
              },
            ]),

          const SizedBox(height: 12),

          // Management Console
          _sectionHeader(
            'managementConsole',
            'Management Console',
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: headerColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.settings_suggest_rounded,
                color: headerColor,
                size: 20,
              ),
            ),
          ),
          if (_expanded['managementConsole'] == true)
            _simpleMenuGrid(headerColor, [
              {
                'id': 'employee',
                'title': 'Employee',
                'icon': Icons.person_outline_rounded,
              },
              {
                'id': 'signature',
                'title': 'Signature',
                'icon': Icons.border_color_rounded,
              },
              {
                'id': 'faceReg',
                'title': 'Face Registration',
                'icon': Icons.face_retouching_natural_rounded,
              },
            ]),

          const SizedBox(height: 12),

          // Company Forms
          _sectionHeader(
            'companyForms',
            'Company Forms',
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: headerColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.description_rounded,
                color: headerColor,
                size: 20,
              ),
            ),
          ),
          if (_expanded['companyForms'] ?? false)
            _simpleMenuGrid(headerColor, [
              {
                'id': 'supplierRequest',
                'title': 'Supplier Request',
                'icon': Icons.group_outlined,
              },
              {
                'id': 'customerRequest',
                'title': 'Customer Request',
                'icon': Icons.people_alt_outlined,
              },
            ]),

          const SizedBox(height: 12),

          // Service (SOON)
          _sectionHeader(
            'service',
            'Service',
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.iconTeal.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.build_rounded,
                color: AppColors.iconTeal,
                size: 20,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'SOON',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            showChevron: false,
          ),

          const SizedBox(height: 12),

          // Tasks (SOON)
          _sectionHeader(
            'tasks',
            'Tasks',
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: headerColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.checklist_rounded,
                color: headerColor,
                size: 20,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'SOON',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            showChevron: false,
          ),
        ],
      ),
    );
  }
}
