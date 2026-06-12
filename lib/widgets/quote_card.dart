import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../theme/app_theme.dart';

/// The main quote display card shown inside the quote flow.
class QuoteCard extends StatelessWidget {
  final Quote quote;

  const QuoteCard({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight;

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
      padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Opening quote mark
          Text(
            '\u201C',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 64,
              height: 0.6,
              color: (isDark ? AppTheme.onSurfaceDark : AppTheme.onSurfaceLight)
                  .withAlpha(40),
            ),
          ),
          const SizedBox(height: 12),
          // Quote text
          Text(
            quote.text,
            style: AppTheme.quoteTextStyle(isDark: isDark),
          ),
          const SizedBox(height: 24),
          // Divider
          Divider(
            color: (isDark ? AppTheme.onSurfaceDark : AppTheme.onSurfaceLight)
                .withAlpha(30),
          ),
          const SizedBox(height: 16),
          // Author
          Text(
            '— ${quote.author}',
            style: AppTheme.authorStyle(isDark: isDark),
          ),
          const SizedBox(height: 4),
          // Era / category chip row
          Wrap(
            spacing: 6,
            children: [
              _Chip(label: quote.era, isDark: isDark),
              _Chip(label: quote.category.replaceAll('_', ' '), isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _Chip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: (isDark ? AppTheme.onSurfaceDark : AppTheme.onSurfaceLight)
            .withAlpha(14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isDark ? AppTheme.subtleDark : AppTheme.subtleLight,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
