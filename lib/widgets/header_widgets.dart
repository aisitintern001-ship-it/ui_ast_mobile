import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback? onAvatarTap;

  const DashboardHeader({super.key, this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final headerColor = state.headerColor;
    // Hardcoded companies for the dropdown (with color dots)
    final companies = [
      {'name': 'Pacific Harvest Co.', 'color': Color(0xFF6366F1)},
      {'name': 'Australia Farm Innovations', 'color': Color(0xFFF97316)},
      {'name': 'Australia Software Technology', 'color': Color(0xFF2563EB)},
      {'name': 'Innovative Fibre Industries', 'color': Color(0xFF10B981)},
    ];
    // Use selected company index in state, fallback to 0
    int selectedIndex = state.selectedCompany != null
        ? companies.indexWhere((c) => c['name'] == state.selectedCompany!.name)
        : 0;

    return Container(
      color: headerColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 0),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedIndex >= 0 ? selectedIndex : 0,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                      ),
                      dropdownColor: Colors.white,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      onChanged: (int? idx) {
                        if (idx != null) {
                          // Set selected company in state
                          state.selectCompany(
                            CompanyModel(
                              id: idx.toString(),
                              name: companies[idx]['name'] as String,
                              location: '',
                              lastUpdated: '',
                            ),
                          );
                        }
                      },
                      selectedItemBuilder: (context) => companies.map((c) {
                        return Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: c['color'] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              c['name'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      items: List.generate(companies.length, (idx) {
                        final c = companies[idx];
                        return DropdownMenuItem<int>(
                          value: idx,
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: c['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                c['name'] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // AIS logo
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: GestureDetector(
              child: SizedBox(
                width: 80,
                height: 80,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/AIS.svg',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompanyNameSection extends StatelessWidget {
  final VoidCallback? onSelectCompany;
  final VoidCallback? onViewAll;

  const CompanyNameSection({super.key, this.onSelectCompany, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final company = state.selectedCompany;
    final companies = state.companies;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Company Name',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.divider),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CompanyModel>(
                isExpanded: true,
                value: company,
                hint: Row(
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Select Company',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textMuted,
                ),
                items: companies.map((c) {
                  return DropdownMenuItem<CompanyModel>(
                    value: c,
                    child: Row(
                      children: [
                        Icon(
                          Icons.business_outlined,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          c.name,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (selected) {
                  if (selected != null) {
                    state.selectCompany(selected);
                  }
                },
                selectedItemBuilder: (context) {
                  return companies.map((c) {
                    return Row(
                      children: [
                        Icon(
                          Icons.business_outlined,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          c.name,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}