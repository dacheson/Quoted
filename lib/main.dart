import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'screens/mood_selection_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const QuotedApp());
}

/// Root application widget.
class QuotedApp extends StatefulWidget {
  const QuotedApp({super.key});

  @override
  State<QuotedApp> createState() => _QuotedAppState();
}

class _QuotedAppState extends State<QuotedApp> {
  late bool _darkMode;

  @override
  void initState() {
    super.initState();
    _darkMode = StorageService.getDarkMode();
  }

  void _toggleDarkMode(bool value) {
    setState(() => _darkMode = value);
    StorageService.setDarkMode(value);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<void Function(bool)>.value(
      value: _toggleDarkMode,
      child: MaterialApp(
        title: 'Quoted',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
        home: MoodSelectionScreen(
          darkMode: _darkMode,
          onToggleDarkMode: _toggleDarkMode,
        ),
      ),
    );
  }
}
