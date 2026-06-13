import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/quote.dart';
import '../models/mood.dart';
import '../models/session.dart';

/// Loads quotes from the bundled JSON asset and provides
/// session-aware ranked quote selection.
class QuoteService {
  static List<Quote>? _allQuotes;

  /// Load all quotes from the bundled asset (cached after first load).
  static Future<List<Quote>> loadQuotes() async {
    if (_allQuotes != null) return _allQuotes!;
    final jsonString =
        await rootBundle.loadString('assets/quotes.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    _allQuotes = jsonList
        .map((e) => Quote.fromJson(e as Map<String, dynamic>))
        .toList();
    return _allQuotes!;
  }

  /// Select the next quote to show given the current [session].
  ///
  /// Algorithm:
  ///   score = mood_weight * 4.0
  ///         + theme_match_score * 2.0
  ///         + disliked_theme_penalty * -3.0
  ///         + category_diversity_bonus * 1.5
  ///         + recency_penalty * -2.0
  ///         + random_noise * 0.2
  ///
  /// Returns null when all quotes have been seen.
  static Quote? nextQuote(
    List<Quote> allQuotes,
    SessionState session, {
    Random? random,
  }) {
    final unseen = allQuotes
        .where((q) => !session.seenQuoteIds.contains(q.id))
        .toList();

    if (unseen.isEmpty) return null;

    final moodName = session.selectedMood.name;

    // Build liked / disliked theme frequency maps
    final likedThemes = <String, int>{};
    for (final q in session.likedQuotes) {
      for (final t in q.themes) {
        likedThemes[t] = (likedThemes[t] ?? 0) + 1;
      }
    }
    final dislikedThemes = <String, int>{};
    for (final q in session.dislikedQuotes) {
      for (final t in q.themes) {
        dislikedThemes[t] = (dislikedThemes[t] ?? 0) + 1;
      }
    }

    // Recently seen categories (last 5 shown)
    final recentIds = session.seenQuoteIds.reversed.take(5).toSet();
    final recentCategories = allQuotes
        .where((q) => recentIds.contains(q.id))
        .map((q) => q.category)
        .toSet();
    final recentAuthors = allQuotes
        .where((q) => recentIds.contains(q.id))
        .map((q) => q.author)
        .toSet();

    final rng = random ?? Random();

    final scored = unseen.map((q) {
      double score = 0;

      // Mood match (primary)
      if (q.moods.contains(moodName)) score += 4.0;

      // Theme match with liked quotes
      double themeMatch = 0;
      for (final t in q.themes) {
        themeMatch += (likedThemes[t] ?? 0) * 1.0;
      }
      score += themeMatch * 2.0;

      // Theme penalty from disliked quotes
      double dislikedPenalty = 0;
      for (final t in q.themes) {
        dislikedPenalty += (dislikedThemes[t] ?? 0) * 1.0;
      }
      score -= dislikedPenalty * 3.0;

      // Category diversity bonus
      if (!recentCategories.contains(q.category)) score += 1.5;

      // Recency penalty (already handled by unseen filter, but penalise
      // quotes whose author appeared very recently)
      if (recentAuthors.contains(q.author)) score -= 2.0;

      // Random noise
      score += rng.nextDouble() * 0.2;

      return _ScoredQuote(q, score);
    }).toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    // Pick randomly from the top 20%
    final topCount = max(1, (scored.length * 0.2).ceil());
    final topQuotes = scored.take(topCount).map((s) => s.quote).toList();
    return topQuotes[rng.nextInt(topQuotes.length)];
  }
}

class _ScoredQuote {
  final Quote quote;
  final double score;
  const _ScoredQuote(this.quote, this.score);
}
