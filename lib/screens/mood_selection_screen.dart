import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../screens/favorites_screen.dart';
import '../screens/quote_flow_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/mood_button.dart';
import '../theme/app_theme.dart';

/// The home screen where users select their current mood.
class MoodSelectionScreen extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onToggleDarkMode;

  const MoodSelectionScreen({
    super.key,
    required this.darkMode,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moods = Mood.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quoted'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            tooltip: 'Favorites',
            onPressed: () => _openFavorites(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'OFFLINE QUOTE COMPANION',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: isDark ? AppTheme.subtleDark : AppTheme.subtleLight,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'How are you\nfeeling?',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: isDark
                      ? AppTheme.onSurfaceDark
                      : AppTheme.onSurfaceLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pick a mood and Quoted will surface something thoughtful in seconds.',
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? AppTheme.subtleDark : AppTheme.subtleLight,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: moods.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    final mood = moods[index];
                    return MoodButton(
                      mood: mood,
                      onTap: () => _navigate(context, mood),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, Mood mood) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            QuoteFlowScreen(mood: mood),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _openFavorites(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const FavoritesScreen(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SettingsScreen(
        darkMode: darkMode,
        onToggleDarkMode: onToggleDarkMode,
      ),
    );
  }
}
