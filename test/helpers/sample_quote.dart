import 'package:quoted/models/quote.dart';

Quote sampleQuote({
  String id = 'q1',
  String text = 'A quote',
  String author = 'Author',
  String category = 'stoicism',
  List<String>? themes,
  List<String>? moods,
  String era = 'Ancient',
  String context = 'Context',
  String source = 'Source',
}) {
  return Quote(
    id: id,
    text: text,
    author: author,
    category: category,
    themes: themes ?? const ['focus'],
    moods: moods ?? const ['calm'],
    era: era,
    context: context,
    source: source,
  );
}
