import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class DashboardHeader extends StatefulWidget {
  final VoidCallback? onAvatarTap;

  const DashboardHeader({super.key, this.onAvatarTap});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _chevronController;
  late Animation<double> _chevronAnimation;

  @override
  void initState() {
    super.initState();
    _chevronController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _chevronAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _chevronController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _chevronController.dispose();
    super.dispose();
  }

  static String _companyAsset(String? name) {
    if (name == null || name.isEmpty) return 'assets/AST.svg';
    final n = name.toLowerCase();
    if (n.contains('pacific')) return 'assets/PHC.svg';
    if (n.contains('farm') && n.contains('australia')) return 'assets/AFI.svg';
    if (n.contains('software')) return 'assets/AST.svg';
    if (n.contains('innovative') &&
        (n.contains('fiber') || n.contains('fibre')))
      return 'assets/IFI.svg';
    return 'assets/AST.svg';
  }

  Future<void> _showCompanyMenu(BuildContext context, AppState state) async {
    final companies = state.companies;
    if (companies.isEmpty) return;

    setState(() {
      _chevronController.forward();
    });

    final box = context.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = box != null
        ? box.localToGlobal(Offset.zero, ancestor: overlay)
        : Offset.zero;
    final size = box?.size ?? Size.zero;

    final selected = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height,
        position.dx + 280,
        position.dy + size.height + 200,
      ),
      items: companies.asMap().entries.map((e) {
        final c = e.value;
        final color = state.companyColor(c);
        return PopupMenuItem<int>(
          value: e.key,
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  c.name,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
    );

    if (mounted) {
      setState(() {
        _chevronController.reverse();
      });
      if (selected != null && selected < companies.length) {
        state.selectCompany(companies[selected]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final headerColor = state.headerColor;
    final companies = state.companies;
    final selected = state.selectedCompany;

    return Container(
      color: headerColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Vertically centers text and logo
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.name,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: companies.isEmpty
                      ? null
                      : () => _showCompanyMenu(context, state),
                  behavior: HitTestBehavior.opaque,
                  // CHANGED: Removed mainAxisSize: MainAxisSize.min here so Flexible works!
                  child: Row(
                    children: [
                      Flexible(
                        // FlexFit.loose ensures the text only takes up as much space as it needs
                        fit: FlexFit.loose,
                        child: Text(
                          companies.isEmpty
                              ? 'No company'
                              : (selected?.name ?? companies.first.name),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (companies.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        AnimatedBuilder(
                          animation: _chevronAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _chevronAnimation.value * 3.14159,
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: SvgPicture.asset(
                _companyAsset(selected?.name),
                width: 60,
                height: 60,
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
