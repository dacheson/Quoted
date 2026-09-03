import 'package:flutter_test/flutter_test.dart';
import 'package:quoted/models/mood.dart';
import 'package:quoted/models/session.dart';

import '../helpers/sample_quote.dart';

void main() {
  group('SessionState', () {
    test('withLike adds quote once and avoids duplicating seen ids', () {
      final quote = sampleQuote(id: 'liked');
      const session = SessionState(
        selectedMood: Mood.calm,
        seenQuoteIds: ['liked'],
      );

      final updated = session.withLike(quote);

      expect(updated.likedQuotes, [quote]);
      expect(updated.seenQuoteIds, ['liked']);
    });

    test('withDislike removes quote from likes and keeps seen ids unique', () {
      final quote = sampleQuote(id: 'rated');
      final session = SessionState(
        selectedMood: Mood.calm,
        likedQuotes: [quote],
        seenQuoteIds: const ['rated'],
      );

      final updated = session.withDislike(quote);

      expect(updated.likedQuotes, isEmpty);
      expect(updated.dislikedQuotes, [quote]);
      expect(updated.seenQuoteIds, ['rated']);
    });
  });
}
