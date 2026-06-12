import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quoted/screens/settings_screen.dart';
import 'package:quoted/services/storage_service.dart';

import '../helpers/sample_quote.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

    testWidgets('clears saved favorites after confirmation', (tester) async {
      await StorageService.saveFavorite(sampleQuote(id: 'favorite'));

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
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      expect(StorageService.getFavorites(), isEmpty);
      expect(find.text('Favorites cleared.'), findsOneWidget);
    });

    testWidgets('resets personalization without clearing favorites', (
      tester,
    ) async {
      final favorite = sampleQuote(id: 'favorite');
      final liked = sampleQuote(id: 'liked');
      final disliked = sampleQuote(id: 'disliked');
      await StorageService.saveFavorite(favorite);
      await StorageService.saveLikedQuote(liked);
      await StorageService.saveDislikedQuote(disliked);

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
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      expect(StorageService.getFavorites(), [favorite]);
      expect(StorageService.getLikedQuotes(), isEmpty);
      expect(StorageService.getDislikedQuotes(), isEmpty);
      expect(find.text('Personalization reset.'), findsOneWidget);
    });
  });
}
