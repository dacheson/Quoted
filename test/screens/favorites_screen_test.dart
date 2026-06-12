import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quoted/screens/favorites_screen.dart';
import 'package:quoted/services/storage_service.dart';

import '../helpers/sample_quote.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

      expect(find.text('No favorites yet.'), findsOneWidget);
      expect(find.text('Tap the bookmark icon on any quote\nto save it here.'),
          findsOneWidget);
    });

    testWidgets('removes a saved favorite from the list and storage', (
      tester,
    ) async {
      final quote = sampleQuote(
        id: 'favorite-1',
        text: 'Stay present.',
        author: 'Marcus Aurelius',
      );
      await StorageService.saveFavorite(quote);

      await tester.pumpWidget(
        const MaterialApp(home: FavoritesScreen()),
      );
      await tester.pump();

      expect(find.text('Stay present.'), findsOneWidget);
      expect(StorageService.getFavorites(), [quote]);

      await tester.tap(find.byTooltip('Remove from favorites'));
      await tester.pumpAndSettle();

      expect(find.text('Stay present.'), findsNothing);
      expect(find.text('Removed from favorites.'), findsOneWidget);
      expect(StorageService.getFavorites(), isEmpty);
    });
  });
}
