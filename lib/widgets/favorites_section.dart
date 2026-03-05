import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ui_ast_mobile/screens/expense_claim_screen.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../screens/team_leave_requests_screen.dart';
import '../screens/attendance_screen.dart';

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
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
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
          if (favorites.isEmpty)
            _EmptyFavorites(onAdd: onViewAll)
          else
            _FavoritesGrid(
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

  const _EmptyFavorites({this.onAdd});

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
            child: Text(
              'Add favorites',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.iconBlue),
            ),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...favorites
              .take(AppState.maxFavorites)
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _FavoriteIconItem(item: item, themeColor: iconColor),
                ),
              ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _AddNewCard(onTap: onViewAll),
          ),
        ],
      ),
    );
  }
}

class _FavoriteIconItem extends StatelessWidget {
  final FavoriteItem item;
  final Color? themeColor;

  const _FavoriteIconItem({required this.item, this.themeColor});

  @override
  Widget build(BuildContext context) {
    final color = themeColor ?? item.color;
    return GestureDetector(
      onTap: () {
        if (item.id == 'attendance') {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const AttendanceScreen()),
  );
} else if (item.id == 'leave_request') {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const TeamLeaveRequestsScreen()),
  );
} else if (item.id == 'expense_claim') {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const ExpenseClaimScreen()),
  );
} else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening ${item.title}...'),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(item.icon, color: color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddNewCard extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddNewCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(Icons.add, color: Colors.black87, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              'Add New',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
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
  State<FavoritesManagementSheet> createState() =>
      _FavoritesManagementSheetState();
}

class _FavoritesManagementSheetState extends State<FavoritesManagementSheet> {
  bool _showOptions = false;
  bool _initialized = false;
  final List<FavoriteItem> _selected = [];

  void _initFromState(AppState state) {
    if (!_initialized) {
      _selected.clear();
      _selected.addAll(state.favorites);
      _initialized = true;
    }
  }

  void _toggleOptions() => setState(() => _showOptions = !_showOptions);

  void _add(FavoriteItem item) {
    if (_selected.length >= AppState.maxFavorites) return;
    if (_selected.any((f) => f.id == item.id)) return;
    setState(() => _selected.add(item));
  }

  void _remove(String id) {
    setState(() => _selected.removeWhere((f) => f.id == id));
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

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
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
                      Text(
                        'Select your top services (Max 5)',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
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

            // My Favorites section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Favorites',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: _toggleOptions,
                  child: Text(
                    _showOptions ? 'Cancel' : 'Edit',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: themeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Selected favorites + Add button
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ..._selected.map(
                  (item) => _FavoriteChip(
                    item: item,
                    themeColor: themeColor,
                    onRemove: () => _remove(item.id),
                    showRemove: true,
                  ),
                ),
                if (_selected.length < AppState.maxFavorites)
                  _AddButton(onTap: () => setState(() => _showOptions = true)),
              ],
            ),

            // Category options (when + or Edit clicked)
            if (_showOptions) ...[
              const SizedBox(height: 20),
              ...categories.map<Widget>((cat) {
                final label = cat['label'] as String;
                final items = cat['items'] as List<FavoriteItem>;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: items.map((item) {
                          final isSelected = _selected.any(
                            (f) => f.id == item.id,
                          );
                          return _FavoriteChip(
                            item: item,
                            themeColor: themeColor,
                            onTap: isSelected ? null : () => _add(item),
                            onRemove: isSelected
                                ? () => _remove(item.id)
                                : null,
                            showRemove: isSelected,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }),
            ],

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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Save Favorites',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
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
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool showRemove;

  const _FavoriteChip({
    required this.item,
    required this.themeColor,
    this.onTap,
    this.onRemove,
    this.showRemove = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: themeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: themeColor, size: 24),
                ),
                const SizedBox(height: 6),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            if (showRemove && onRemove != null)
              Positioned(
                top: -4,
                right: -4,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.dangerRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
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
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.black54,
                size: 28,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
