import 'quote.dart';
import 'mood.dart';

/// Tracks all state for the current app session.
class SessionState {
  final Mood selectedMood;
  final List<Quote> likedQuotes;
  final List<Quote> dislikedQuotes;
  final List<String> seenQuoteIds;

  const SessionState({
    required this.selectedMood,
    this.likedQuotes = const [],
    this.dislikedQuotes = const [],
    this.seenQuoteIds = const [],
  });

  SessionState copyWith({
    Mood? selectedMood,
    List<Quote>? likedQuotes,
    List<Quote>? dislikedQuotes,
    List<String>? seenQuoteIds,
  }) {
    return SessionState(
      selectedMood: selectedMood ?? this.selectedMood,
      likedQuotes: likedQuotes ?? this.likedQuotes,
      dislikedQuotes: dislikedQuotes ?? this.dislikedQuotes,
      seenQuoteIds: seenQuoteIds ?? this.seenQuoteIds,
    );
  }

  /// Return a new state with [quote] added to liked and seen.
  SessionState withLike(Quote quote) {
    return copyWith(
      likedQuotes: [...likedQuotes, quote],
      seenQuoteIds: [...seenQuoteIds, quote.id],
    );
  }

  /// Return a new state with [quote] added to disliked and seen.
  SessionState withDislike(Quote quote) {
    return copyWith(
      dislikedQuotes: [...dislikedQuotes, quote],
      seenQuoteIds: [...seenQuoteIds, quote.id],
    );
  }

  /// Return a new state with [quote] marked as seen only.
  SessionState withSeen(Quote quote) {
    if (seenQuoteIds.contains(quote.id)) return this;
    return copyWith(
      seenQuoteIds: [...seenQuoteIds, quote.id],
    );
  }
}
