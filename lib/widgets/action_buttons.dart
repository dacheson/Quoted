import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The three primary interaction buttons: Like, Dislike, Skip.
class ActionButtons extends StatelessWidget {
  final bool liked;
  final bool disliked;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onSkip;

  const ActionButtons({
    super.key,
    required this.liked,
    required this.disliked,
    required this.onLike,
    required this.onDislike,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionButton(
          icon: disliked ? Icons.thumb_down : Icons.thumb_down_outlined,
          label: 'Dislike',
          active: disliked,
          activeColor: const Color(0xFFE76F51),
          isDark: isDark,
          onTap: onDislike,
        ),
        const SizedBox(width: 24),
        _ActionButton(
          icon: Icons.skip_next_outlined,
          label: 'Skip',
          active: false,
          activeColor: Colors.transparent,
          isDark: isDark,
          onTap: onSkip,
          isSkip: true,
        ),
        const SizedBox(width: 24),
        _ActionButton(
          icon: liked ? Icons.favorite : Icons.favorite_border,
          label: 'Like',
          active: liked,
          activeColor: const Color(0xFFE76F51),
          isDark: isDark,
          onTap: onLike,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color activeColor;
  final bool isDark;
  final VoidCallback onTap;
  final bool isSkip;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.activeColor,
    required this.isDark,
    required this.onTap,
    this.isSkip = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor =
        isDark ? AppTheme.onSurfaceDark.withAlpha(160) : AppTheme.onSurfaceLight.withAlpha(160);
    final color = active ? activeColor : defaultColor;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: Icon(
              icon,
              key: ValueKey('$icon$active'),
              size: isSkip ? 30 : 32,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
