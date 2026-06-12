import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../theme/app_theme.dart';

/// Single mood selection card shown in the mood grid.
class MoodButton extends StatelessWidget {
  final Mood mood;
  final VoidCallback onTap;

  const MoodButton({super.key, required this.mood, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final config = mood.config;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: config.color.withAlpha(60),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 40 : 12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(config.icon, color: config.color, size: 32),
              const SizedBox(height: 10),
              Text(
                config.label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppTheme.onSurfaceDark
                      : AppTheme.onSurfaceLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
