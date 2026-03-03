import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class FavoritesSection extends StatelessWidget {
  final VoidCallback? onViewAll;

  const FavoritesSection({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final favorites = state.favorites;

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
                    color: AppColors.iconBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (favorites.isEmpty)
            _EmptyFavorites(onAdd: onViewAll)
          else
            _FavoritesGrid(favorites: favorites),
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
            child: Text('Add favorites', style: GoogleFonts.inter(fontSize: 13, color: AppColors.iconBlue)),
          ),
        ],
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  final List<FavoriteItem> favorites;

  const _FavoritesGrid({required this.favorites});

  @override
  Widget build(BuildContext context) {
    final displayItems = favorites.take(8).toList();
    final int rowCount = (displayItems.length / 4).ceil();

    return Column(
      children: List.generate(rowCount, (rowIndex) {
        final start = rowIndex * 4;
        final end = (start + 4).clamp(0, displayItems.length);
        final rowItems = displayItems.sublist(start, end);

        return Padding(
          padding: EdgeInsets.only(bottom: rowIndex < rowCount - 1 ? 16 : 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...rowItems.map((item) => _FavoriteIconItem(item: item)),
              // Fill empty slots
              ...List.generate(
                4 - rowItems.length,
                (_) => const SizedBox(width: 72, height: 72),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _FavoriteIconItem extends StatelessWidget {
  final FavoriteItem item;

  const _FavoriteIconItem({required this.item});

  @override
  Widget build(BuildContext context) {
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
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 24),
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
      ),
    );
  }
}

// Full-screen favorites management
class FavoritesManagementSheet extends StatefulWidget {
  const FavoritesManagementSheet({super.key});

  @override
  State<FavoritesManagementSheet> createState() => _FavoritesManagementSheetState();
}

class _FavoritesManagementSheetState extends State<FavoritesManagementSheet> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'My Favorites',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Favorites grid (draggable)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Favorites',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                _EditableFavoritesGrid(favorites: state.favorites),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),
                Text(
                  'Add More',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                _AllMenuItemsGrid(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.headerOrange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Done',
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditableFavoritesGrid extends StatelessWidget {
  final List<FavoriteItem> favorites;

  const _EditableFavoritesGrid({required this.favorites});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: favorites.map((item) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: 64,
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: item.color, size: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: GoogleFonts.inter(fontSize: 10, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -6,
              right: -6,
              child: GestureDetector(
                onTap: () => state.removeFavorite(item.id),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.dangerRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove, size: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _AllMenuItemsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final notFavorited = state.allMenuItems.where((item) => !state.isFavorite(item.id)).toList();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: notFavorited.map((item) {
        return GestureDetector(
          onTap: () => state.addFavorite(item),
          child: SizedBox(
            width: 64,
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color, size: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: GoogleFonts.inter(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
