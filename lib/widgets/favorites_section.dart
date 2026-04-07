import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../screens/leave_request_screen.dart';
import '../screens/expense_claim_screen.dart';
import '../screens/attendance_screen.dart';
import '../screens/product_library_screen.dart';
import '../screens/supplier_request_screen.dart';
import '../screens/customer_request_screen.dart';
import '../screens/team_management_screen.dart';
import '../screens/face_registration_screen.dart';
import '../screens/personal_leave_screen.dart';
import '../screens/team_members_screen.dart';
import '../screens/member_timesheet_screen.dart';
import '../screens/data_integration_screen.dart';
import '../screens/profile_info_screen.dart';
import '../modals/signature_modal.dart';
import 'animations/page_transitions.dart';

class FavoritesSection extends StatelessWidget {
  final VoidCallback? onViewAll;

  const FavoritesSection({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final favorites = state.favorites;
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
                'Favorites',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onViewAll,
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: headerColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          favorites.isEmpty
              ? _EmptyFavorites(
                  onAdd: onViewAll,
                  actionColor: headerColor,
                )
              : _FavoritesGrid(
                  favorites: favorites,
                  themeColor: headerColor,
                  onViewAll: onViewAll,
                ),
        ],
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  final VoidCallback? onAdd;
  final Color actionColor;

  const _EmptyFavorites({this.onAdd, required this.actionColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.star_border_rounded, size: 40, color: AppColors.textMuted),
          const SizedBox(height: 8),
          Text(
            'No favorites yet',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onAdd,
            child: Text('Add favorites', style: GoogleFonts.inter(fontSize: 13, color: actionColor)),
          ),
        ],
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  final List<FavoriteItem> favorites;
  final Color? themeColor;
  final VoidCallback? onViewAll;

  const _FavoritesGrid({
    required this.favorites,
    this.themeColor,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = themeColor ?? AppColors.iconBlue;
    final visibleFavorites = favorites.take(AppState.maxFavorites).toList();
    final isAtMax = visibleFavorites.length >= AppState.maxFavorites;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate items: favorites + add button (if not at max)
        final totalItems = isAtMax ? visibleFavorites.length : visibleFavorites.length + 1;
        const spacing = 6.0;
        final tileWidth = ((constraints.maxWidth - (spacing * (totalItems - 1))) /
                    totalItems)
            .toDouble();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...visibleFavorites.map((item) => _FavoriteIconItem(
                  item: item,
                  themeColor: iconColor,
                  width: tileWidth,
                )),
            // Only show Add button if not at max
            if (!isAtMax)
              _AddNewCard(onTap: onViewAll, width: tileWidth),
          ],
        );
      },
    );
  }
}

class _FavoriteIconItem extends StatefulWidget {
  final FavoriteItem item;
  final Color? themeColor;
  final double width;

  const _FavoriteIconItem({
    required this.item,
    this.themeColor,
    required this.width,
  });

  @override
  State<_FavoriteIconItem> createState() => _FavoriteIconItemState();
}

class _FavoriteIconItemState extends State<_FavoriteIconItem>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
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
    HapticFeedback.lightImpact();
    _navigateToScreen();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  void _navigateToScreen() {
    late final Widget screen;
    switch (widget.item.id) {
      // Attendance category
      case 'attendance':
        screen = const AttendanceScreen();
        break;
      case 'payslip':
        // Show coming soon for payslip
        _showComingSoon('Payslip');
        return;
      case 'leave_request':
        screen = const LeaveRequestScreen();
        break;
      case 'team_management':
        screen = const TeamManagementScreen();
        break;
      
      // Product Library category
      case 'product':
        screen = const ProductLibraryScreen();
        break;
      
      // Company Forms category
      case 'supplier_request':
        screen = const SupplierRequestScreen();
        break;
      case 'customer_request':
        screen = const CustomerRequestScreen();
        break;
      
      // Expense Claim category
      case 'expense_claim':
        screen = const ExpenseClaimScreen();
        break;
      
      // Management Console category
      case 'employee':
        screen = const TeamMembersScreen();
        break;
      case 'signature':
        _showSignatureModal();
        return;
      case 'face_registration':
        screen = const FaceRegistrationScreen();
        break;
      
      // Additional menu items
      case 'personal_leave':
        screen = const PersonalLeaveScreen();
        break;
      case 'team_members':
        screen = const TeamMembersScreen();
        break;
      case 'member_timesheet':
        screen = const MemberTimesheetScreen();
        break;
      case 'data_integration':
        screen = const DataIntegrationScreen();
        break;
      case 'profile':
        screen = const ProfileInfoScreen();
        break;
      
      default:
        _showComingSoon(widget.item.title);
        return;
    }
    
    Navigator.of(context).push(
      AppPageTransitions.slideLeft(screen),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$feature - Coming Soon!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF6366F1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSignatureModal() {
    showDialog(
      context: context,
      builder: (context) => const SignatureModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.themeColor ?? widget.item.color;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          height: 70,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEFF1F5)),
            boxShadow: const [
              BoxShadow(
                color: AppColors.dashboardCardShadow,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.item.icon, color: color, size: 16),
            ),
            const SizedBox(height: 4),
            Text(
              widget.item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _AddNewCard extends StatelessWidget {
  final VoidCallback? onTap;
  final double width;

  const _AddNewCard({this.onTap, required this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: width,
        height: 70,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEFF1F5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, color: Color(0xFF9CA3AF), size: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Add',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: GoogleFonts.inter(
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// My Favorites modal - matches reference: max 5, + reveals options, categories
class FavoritesManagementSheet extends StatefulWidget {
  const FavoritesManagementSheet({super.key});

  @override
  State<FavoritesManagementSheet> createState() => _FavoritesManagementSheetState();
}

class _FavoritesManagementSheetState extends State<FavoritesManagementSheet>
    with TickerProviderStateMixin {
  bool _showOptions = false;
  bool _initialized = false;
  final List<FavoriteItem> _selected = [];
  
  // Animation controllers for each favorite item
  final Map<String, AnimationController> _itemAnimations = {};
  
  @override
  void dispose() {
    for (final controller in _itemAnimations.values) {
      controller.dispose();
    }
    super.dispose();
  }

  AnimationController _getOrCreateController(String id) {
    if (!_itemAnimations.containsKey(id)) {
      _itemAnimations[id] = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      )..forward();
    }
    return _itemAnimations[id]!;
  }

  void _initFromState(AppState state) {
    if (!_initialized) {
      _selected.clear();
      _selected.addAll(state.favorites);
      // Initialize animations for existing favorites
      for (final item in _selected) {
        _getOrCreateController(item.id);
      }
      _initialized = true;
    }
  }

  void _toggleOptions() => setState(() => _showOptions = !_showOptions);

  void _add(FavoriteItem item) {
    if (_selected.length >= AppState.maxFavorites) return;
    if (_selected.any((f) => f.id == item.id)) return;
    
    final controller = _getOrCreateController(item.id);
    controller.forward(from: 0.0);
    
    setState(() => _selected.add(item));
  }

  void _remove(String id) {
    final controller = _itemAnimations[id];
    if (controller != null) {
      controller.reverse().then((_) {
        if (mounted) {
          setState(() {
            _selected.removeWhere((f) => f.id == id);
          });
          controller.dispose();
          _itemAnimations.remove(id);
        }
      });
    } else {
      setState(() => _selected.removeWhere((f) => f.id == id));
    }
  }

  void _save() {
    context.read<AppState>().setFavorites(_selected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    _initFromState(state);
    final themeColor = state.headerColor;
    final categories = state.favoriteCategories;
    final isAtMax = _selected.length >= AppState.maxFavorites;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400, maxHeight: MediaQuery.of(context).size.height * 0.85),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Favorites',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Select your top services ',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isAtMax
                                  ? themeColor.withValues(alpha: 0.15)
                                  : Colors.grey.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_selected.length}/${AppState.maxFavorites}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isAtMax ? themeColor : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.close_rounded, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // My Favorites section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Favorites',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _toggleOptions,
                          child: Text(
                            _showOptions ? 'Cancel' : 'Edit',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: themeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Selected favorites + Add button - LEFT ALIGNED with animations
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8,
                      runSpacing: 12,
                      children: [
                        ..._selected.map((item) {
                          final controller = _itemAnimations[item.id];
                          if (controller == null) {
                            return _FavoriteChip(
                              item: item,
                              themeColor: themeColor,
                              onRemove: () => _remove(item.id),
                              showRemove: true,
                              isFavorited: true,
                            );
                          }
                          return AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              final scaleValue = Curves.elasticOut.transform(
                                controller.value.clamp(0.0, 1.0),
                              );
                              return Transform.scale(
                                scale: scaleValue,
                                child: Opacity(
                                  opacity: controller.value.clamp(0.0, 1.0),
                                  child: child,
                                ),
                              );
                            },
                            child: _FavoriteChip(
                              item: item,
                              themeColor: themeColor,
                              onRemove: () => _remove(item.id),
                              showRemove: true,
                              isFavorited: true,
                            ),
                          );
                        }),
                        // Only show Add button if not at max
                        if (!isAtMax)
                          _AddButton(
                            onTap: () => setState(() => _showOptions = true),
                          ),
                      ],
                    ),

                    // Max limit message
                    if (isAtMax)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: themeColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: themeColor.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline_rounded,
                                size: 16,
                                color: themeColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Maximum of 5 favorites reached. Remove one to add another.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: themeColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Category options (when + or Edit clicked) - LEFT ALIGNED
                    // Items already in favorites are hidden from these lists
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _showOptions
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                ...categories.map<Widget>((cat) {
                                  final label = cat['label'] as String;
                                  final allItems = cat['items'] as List<FavoriteItem>;
                                  // Filter out items that are already in favorites
                                  final availableItems = allItems
                                      .where((item) => !_selected.any((f) => f.id == item.id))
                                      .toList();

                                  // Don't show category if all items are already favorited
                                  if (availableItems.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          label,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Wrap(
                                          alignment: WrapAlignment.start,
                                          spacing: 8,
                                          runSpacing: 12,
                                          children: availableItems.map((item) {
                                            return AnimatedOpacity(
                                              duration: const Duration(milliseconds: 200),
                                              opacity: isAtMax ? 0.5 : 1.0,
                                              child: _AnimatedFavoriteChip(
                                                item: item,
                                                themeColor: themeColor,
                                                onTap: isAtMax ? null : () => _add(item),
                                                showRemove: false,
                                                isFavorited: false,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  'Save Favorites',
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteChip extends StatelessWidget {
  final FavoriteItem item;
  final Color themeColor;
  final VoidCallback? onRemove;
  final bool showRemove;
  final bool isFavorited;

  const _FavoriteChip({
    required this.item,
    required this.themeColor,
    this.onRemove,
    this.showRemove = false,
    this.isFavorited = false,
  });

  @override
  Widget build(BuildContext context) {
    // Gray color for non-favorited items, theme color for favorited items
    final iconColor = isFavorited ? themeColor : const Color(0xFF9CA3AF);
    final bgColor = isFavorited
        ? themeColor.withValues(alpha: 0.12)
        : const Color(0xFFF3F4F6);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: isFavorited
                        ? null
                        : Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Icon(
                    item.icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 26,
                  child: Text(
                    item.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: isFavorited
                          ? AppColors.textSecondary
                          : const Color(0xFF9CA3AF),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            if (showRemove && onRemove != null)
              Positioned(
                top: -3,
                right: -2,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onRemove,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: themeColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check_rounded, size: 10, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Animated version of _FavoriteChip with tap scale animation
class _AnimatedFavoriteChip extends StatefulWidget {
  final FavoriteItem item;
  final Color themeColor;
  final VoidCallback? onTap;
  final bool showRemove;
  final bool isFavorited;

  const _AnimatedFavoriteChip({
    required this.item,
    required this.themeColor,
    this.onTap,
    this.showRemove = false,
    this.isFavorited = false,
  });

  @override
  State<_AnimatedFavoriteChip> createState() => _AnimatedFavoriteChipState();
}

class _AnimatedFavoriteChipState extends State<_AnimatedFavoriteChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTap == null) return;
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onTap?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.isFavorited ? widget.themeColor : const Color(0xFF9CA3AF);
    final bgColor = widget.isFavorited
        ? widget.themeColor.withValues(alpha: 0.12)
        : const Color(0xFFF3F4F6);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: SizedBox(
          width: 56,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: widget.isFavorited
                          ? null
                          : Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Icon(
                      widget.item.icon,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 26,
                    child: Text(
                      widget.item.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: widget.isFavorited
                            ? AppColors.textSecondary
                            : const Color(0xFF9CA3AF),
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 56,
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.divider,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Icon(Icons.add_rounded, color: Color(0xFF6B7280), size: 22),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 26,
              child: Text(
                'Add',
                style: GoogleFonts.inter(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
