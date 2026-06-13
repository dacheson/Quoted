import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/quote.dart';

/// Handles all persistent storage via Hive.
class StorageService {
  static const String _favoritesBox = 'favorites';
  static const String _likedQuotesBox = 'liked_quotes';
  static const String _dislikedQuotesBox = 'disliked_quotes';
  static const String _settingsBox = 'settings';
  static const String _darkModeKey = 'dark_mode';

  /// Initialise Hive (call once at app start).
  static Future<void> init({String? path}) async {
    if (path == null) {
      await Hive.initFlutter();
    } else {
      Hive.init(path);
    }

    await _openBoxIfNeeded<String>(_favoritesBox);
    await _openBoxIfNeeded<String>(_likedQuotesBox);
    await _openBoxIfNeeded<String>(_dislikedQuotesBox);
    await _openBoxIfNeeded<dynamic>(_settingsBox);
  }

  static Future<void> _openBoxIfNeeded<T>(String name) async {
    if (!Hive.isBoxOpen(name)) {
      await Hive.openBox<T>(name);
    }
  }

  // --------------- Favorites ---------------

  /// Return all persisted favorite quotes (decoded from stored JSON strings).
  static List<Quote> getFavorites() {
    return _getQuotesFromBox(_favoritesBox);
  }

  static List<Quote> _getQuotesFromBox(String boxName) {
    final box = Hive.box<String>(boxName);
    return box.values
        .map((v) => Quote.fromJson(json.decode(v) as Map<String, dynamic>))
        .toList();
  }

  /// Persist [quote] as a favorite.
  static Future<void> saveFavorite(Quote quote) async {
    final box = Hive.box<String>(_favoritesBox);
    await box.put(quote.id, json.encode(quote.toJson()));
  }

  /// Remove [quote] from persistent favorites.
  static Future<void> removeFavorite(String quoteId) async {
    final box = Hive.box<String>(_favoritesBox);
    await box.delete(quoteId);
  }

  /// True if [quoteId] is already saved.
  static bool isFavorite(String quoteId) {
    final box = Hive.box<String>(_favoritesBox);
    return box.containsKey(quoteId);
  }

  /// Delete all favorites.
  static Future<void> clearFavorites() async {
    await Hive.box<String>(_favoritesBox).clear();
  }

  // --------------- Personalization ---------------

  /// Return all persisted liked quotes.
  static List<Quote> getLikedQuotes() {
    return _getQuotesFromBox(_likedQuotesBox);
  }

  /// Return all persisted disliked quotes.
  static List<Quote> getDislikedQuotes() {
    return _getQuotesFromBox(_dislikedQuotesBox);
  }

  /// Persist [quote] as a liked quote and remove it from dislikes.
  static Future<void> saveLikedQuote(Quote quote) async {
    await Hive.box<String>(_likedQuotesBox).put(
      quote.id,
      json.encode(quote.toJson()),
    );
    await Hive.box<String>(_dislikedQuotesBox).delete(quote.id);
  }

  /// Persist [quote] as a disliked quote and remove it from likes.
  static Future<void> saveDislikedQuote(Quote quote) async {
    await Hive.box<String>(_dislikedQuotesBox).put(
      quote.id,
      json.encode(quote.toJson()),
    );
    await Hive.box<String>(_likedQuotesBox).delete(quote.id);
  }

  /// Remove a persisted liked quote.
  static Future<void> removeLikedQuote(String quoteId) async {
    await Hive.box<String>(_likedQuotesBox).delete(quoteId);
  }

  /// Remove a persisted disliked quote.
  static Future<void> removeDislikedQuote(String quoteId) async {
    await Hive.box<String>(_dislikedQuotesBox).delete(quoteId);
  }

  /// Delete all stored likes and dislikes.
  static Future<void> clearPersonalization() async {
    await Hive.box<String>(_likedQuotesBox).clear();
    await Hive.box<String>(_dislikedQuotesBox).clear();
  }

  // --------------- Settings ---------------

  /// Read the persisted dark-mode preference (default: false).
  static bool getDarkMode() {
    final box = Hive.box<dynamic>(_settingsBox);
    return box.get(_darkModeKey, defaultValue: false) as bool;
  }

  /// Persist the dark-mode preference.
  static Future<void> setDarkMode(bool value) async {
    await Hive.box<dynamic>(_settingsBox).put(_darkModeKey, value);
  }

  /// Close all Hive boxes.
  static Future<void> close() async {
    await Hive.close();
  }
}
