import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:quoted/models/mood.dart';
import 'package:quoted/models/session.dart';
import 'package:quoted/services/quote_service.dart';

import '../helpers/sample_quote.dart';

void main() {
  group('QuoteService.nextQuote', () {
    test('returns null when every quote has been seen', () {
      final quote = sampleQuote(id: 'seen');
      const session = SessionState(
        selectedMood: Mood.calm,
        seenQuoteIds: ['seen'],
      );

      final next = QuoteService.nextQuote([quote], session, random: Random(1));

      expect(next, isNull);
    });

    test('prefers quotes matching the mood and liked themes', () {
      final preferred = sampleQuote(
        id: 'preferred',
        themes: const ['focus'],
        moods: const ['calm'],
        author: 'Preferred Author',
      );
      final neutral = sampleQuote(
        id: 'neutral',
        themes: const ['growth'],
        moods: const ['joyful'],
        author: 'Neutral Author',
      );
      final discouraged = sampleQuote(
        id: 'discouraged',
        themes: const ['stress'],
        moods: const ['calm'],
        author: 'Discouraged Author',
      );
      final candidates = [
        preferred,
        neutral,
        discouraged,
        sampleQuote(
          id: 'other1',
          themes: const ['reflection'],
          moods: const ['joyful'],
          author: 'Other One',
        ),
        sampleQuote(
          id: 'other2',
          themes: const ['energy'],
          moods: const ['motivated'],
          author: 'Other Two',
        ),
      ];
      final session = SessionState(
        selectedMood: Mood.calm,
        likedQuotes: [sampleQuote(id: 'liked-seed', themes: const ['focus'])],
        dislikedQuotes: [
          sampleQuote(id: 'disliked-seed', themes: const ['stress']),
        ],
      );

      final next = QuoteService.nextQuote(
        candidates,
        session,
        random: Random(7),
      );

      expect(next?.id, preferred.id);
    });
  });
}
