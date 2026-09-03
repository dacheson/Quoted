import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'screens/mood_selection_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Quoted is offline-first: the fonts ship in assets/google_fonts, so never
  // reach out to fonts.gstatic.com at runtime.
  GoogleFonts.config.allowRuntimeFetching = false;
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
        // Quoted is a phone app, and on the web it is handed the full browser
        // width. Unconstrained, the mood grid renders two cards a thousand
        // pixels across holding one icon each. Cap the layout at a phone-ish
        // width and centre it so the desktop demo matches the app.
        builder: (context, child) => ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: child,
            ),
          ),
        ),
        home: MoodSelectionScreen(
          darkMode: _darkMode,
          onToggleDarkMode: _toggleDarkMode,
        ),
      ),
    );
  }
}
