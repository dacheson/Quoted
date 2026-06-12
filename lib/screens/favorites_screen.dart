import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/expandable_context.dart';

/// Displays all quotes the user has bookmarked.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Quote> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = StorageService.getFavorites();
  }

  Future<void> _remove(Quote quote) async {
    await StorageService.removeFavorite(quote.id);
    setState(() => _favorites.removeWhere((q) => q.id == quote.id));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Favorites'),
      ),
      body: SafeArea(
        child: _favorites.isEmpty
            ? _buildEmptyState(isDark)
            : _buildList(isDark),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 56,
              color: isDark ? AppTheme.subtleDark : AppTheme.subtleLight,
            ),
            const SizedBox(height: 24),
            Text(
              'No favorites yet.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color:
                    isDark ? AppTheme.onSurfaceDark : AppTheme.onSurfaceLight,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tap the bookmark icon on any quote\nto save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppTheme.subtleDark : AppTheme.subtleLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      itemCount: _favorites.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final quote = _favorites[index];
        return _FavoriteCard(
          quote: quote,
          isDark: isDark,
          onRemove: () => _remove(quote),
        );
      },
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Quote quote;
  final bool isDark;
  final VoidCallback onRemove;

  const _FavoriteCard({
    required this.quote,
    required this.isDark,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight;
    final onSurface =
        isDark ? AppTheme.onSurfaceDark : AppTheme.onSurfaceLight;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 14),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Opening quote mark
          Text(
            '\u201C',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 48,
              height: 0.6,
              color: onSurface.withAlpha(40),
            ),
          ),
          const SizedBox(height: 10),
          // Quote text
          Text(
            quote.text,
            style: AppTheme.quoteTextStyle(isDark: isDark, fontSize: 18),
          ),
          const SizedBox(height: 16),
          Divider(color: onSurface.withAlpha(30)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '— ${quote.author}',
                  style: AppTheme.authorStyle(isDark: isDark),
                ),
              ),
              // Remove bookmark button
              IconButton(
                icon: const Icon(Icons.bookmark, size: 20),
                tooltip: 'Remove from favorites',
                color: onSurface.withAlpha(140),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onRemove,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ExpandableContext(quote: quote),
        ],
      ),
    );
  }
}
