import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quoted/screens/settings_screen.dart';
import 'package:quoted/services/storage_service.dart';

import '../helpers/widget_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  useOfflineFonts();

  group('SettingsScreen', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'quoted_settings_screen_test',
      );
      await StorageService.init(path: tempDir.path);
    });

    tearDown(() async {
      await StorageService.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    testWidgets('calls back when dark mode is toggled', (tester) async {
      bool? toggledValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsScreen(
              darkMode: false,
              onToggleDarkMode: (value) => toggledValue = value,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(toggledValue, isTrue);
    });

    testWidgets('asks before clearing favorites, and can be cancelled', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsScreen(
              darkMode: false,
              onToggleDarkMode: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Clear Favorites'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text(
          'This will permanently delete all saved favorites. Continue?',
        ),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Clear'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('asks before resetting personalization, and can be cancelled', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsScreen(
              darkMode: false,
              onToggleDarkMode: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Reset Personalization'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Reset'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
