import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/quote.dart';

/// Handles all persistent storage via Hive.
class StorageService {
  static const String _favoritesBox = 'favorites';
  static const String _settingsBox = 'settings';
  static const String _darkModeKey = 'dark_mode';

  /// Initialise Hive (call once at app start).
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_favoritesBox);
    await Hive.openBox<dynamic>(_settingsBox);
  }

  // --------------- Favorites ---------------

  /// Return all persisted favorite quotes (decoded from stored JSON strings).
  static List<Quote> getFavorites() {
    final box = Hive.box<String>(_favoritesBox);
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
}
