import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quoted/services/storage_service.dart';

import '../helpers/sample_quote.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StorageService', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('quoted_storage_test');
      await StorageService.init(path: tempDir.path);
    });

    tearDown(() async {
      await StorageService.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('persists favorites, likes, dislikes, and dark mode', () async {
      final favorite = sampleQuote(id: 'favorite');
      final liked = sampleQuote(id: 'liked');
      final disliked = sampleQuote(id: 'disliked');

      await StorageService.saveFavorite(favorite);
      await StorageService.saveLikedQuote(liked);
      await StorageService.saveDislikedQuote(disliked);
      await StorageService.setDarkMode(true);

      expect(StorageService.getFavorites(), [favorite]);
      expect(StorageService.getLikedQuotes(), [liked]);
      expect(StorageService.getDislikedQuotes(), [disliked]);
      expect(StorageService.getDarkMode(), isTrue);
    });

    test('reset personalization clears likes and dislikes only', () async {
      final favorite = sampleQuote(id: 'favorite');
      final liked = sampleQuote(id: 'liked');
      final disliked = sampleQuote(id: 'disliked');

      await StorageService.saveFavorite(favorite);
      await StorageService.saveLikedQuote(liked);
      await StorageService.saveDislikedQuote(disliked);

      await StorageService.clearPersonalization();

      expect(StorageService.getFavorites(), [favorite]);
      expect(StorageService.getLikedQuotes(), isEmpty);
      expect(StorageService.getDislikedQuotes(), isEmpty);
    });
  });
}
