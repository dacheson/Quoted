import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

/// Settings bottom sheet with theme, reset, and about actions.
class SettingsScreen extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onToggleDarkMode;

  const SettingsScreen({
    super.key,
    required this.darkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _darkMode;

  @override
  void initState() {
    super.initState();
    _darkMode = widget.darkMode;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight;
    final onSurface =
        isDark ? AppTheme.onSurfaceDark : AppTheme.onSurfaceLight;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: onSurface.withAlpha(40),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Settings & data',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: onSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Dark mode toggle
            _SettingsTile(
              icon: _darkMode ? Icons.dark_mode : Icons.light_mode,
              title: 'Dark Mode',
              isDark: isDark,
              trailing: Switch(
                value: _darkMode,
                onChanged: (v) {
                  setState(() => _darkMode = v);
                  widget.onToggleDarkMode(v);
                },
              ),
            ),

            _Divider(isDark: isDark),

            _SettingsTile(
              icon: Icons.restart_alt,
              title: 'Reset Personalization',
              isDark: isDark,
              onTap: () => _confirmResetPersonalization(context),
            ),

            _Divider(isDark: isDark),

            // Clear favorites
            _SettingsTile(
              icon: Icons.delete_outline,
              title: 'Clear Favorites',
              isDark: isDark,
              onTap: () => _confirmClearFavorites(context),
            ),

            _Divider(isDark: isDark),

            // About
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'About',
              isDark: isDark,
              onTap: () => _showAbout(context),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmClearFavorites(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Favorites'),
        content: const Text(
            'This will permanently delete all saved favorites. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await StorageService.clearFavorites();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Favorites cleared.')),
        );
      }
    }
  }

  Future<void> _confirmResetPersonalization(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Personalization'),
        content: const Text(
          'This will remove your saved likes and dislikes so quote matching starts fresh. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await StorageService.clearPersonalization();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Personalization reset.')),
        );
      }
    }
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Quoted',
      applicationVersion: '1.0.0',
      applicationLegalese:
          'Quoted pairs a curated offline quote library with simple '
          'mood-based matching. Quotes are drawn from historical public '
          'figures and are attributed to their known sources.\n\n'
          'Built with Flutter. Fonts: Lora, Inter (Google Fonts).',
      children: const [
        SizedBox(height: 16),
        Text(
        'Quoted delivers thoughtful quotes for the mood you are in, fully '
        'offline and with no account required.',
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.isDark,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppTheme.onSurfaceDark : AppTheme.onSurfaceLight;
    return ListTile(
      leading: Icon(icon, color: color.withAlpha(180), size: 22),
      title: Text(
        title,
        style: TextStyle(fontSize: 15, color: color),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: 56,
      endIndent: 20,
      height: 1,
      color: (isDark ? AppTheme.onSurfaceDark : AppTheme.onSurfaceLight)
          .withAlpha(20),
    );
  }
}
