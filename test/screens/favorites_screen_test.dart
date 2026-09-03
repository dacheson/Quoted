import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quoted/screens/favorites_screen.dart';
import 'package:quoted/services/storage_service.dart';

import '../helpers/sample_quote.dart';
import '../helpers/widget_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  useOfflineFonts();

  group('FavoritesScreen', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'quoted_favorites_screen_test',
      );
      await StorageService.init(path: tempDir.path);
    });

    tearDown(() async {
      await StorageService.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    testWidgets('renders the empty state when no favorites are saved', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: FavoritesScreen()),
      );

      expect(find.text('Save quotes you want to revisit.'), findsOneWidget);
      expect(
        find.text('Tap the bookmark on any quote\nto keep it handy offline.'),
        findsOneWidget,
      );
    });

    testWidgets('removes a saved favorite from the list and storage', (
      tester,
    ) async {
      final quote = sampleQuote(
        id: 'favorite-1',
        text: 'Stay present.',
        author: 'Marcus Aurelius',
      );
      await runRealAsync(
        tester,
        () => StorageService.saveFavorite(quote),
        until: () => StorageService.getFavorites().isNotEmpty,
      );

      await tester.pumpWidget(
        const MaterialApp(home: FavoritesScreen()),
      );
      await tester.pump();

      expect(find.text('Stay present.'), findsOneWidget);
      expect(StorageService.getFavorites(), [quote]);

      await tapAndSettle(tester, find.byTooltip('Remove from favorites'));

      expect(StorageService.getFavorites(), isEmpty);
      expect(find.text('Stay present.'), findsNothing);
      expect(find.text('Save quotes you want to revisit.'), findsOneWidget);
      expect(find.text('Removed from favorites.'), findsOneWidget);
    });
  });
}
