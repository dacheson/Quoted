/// Represents a single quote with all metadata.
class Quote {
  final String id;
  final String text;
  final String author;
  final String category;
  final List<String> themes;
  final List<String> moods;
  final String era;
  final String context;
  final String source;

  const Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
    required this.themes,
    required this.moods,
    required this.era,
    required this.context,
    required this.source,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as String,
      text: json['text'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      themes: List<String>.from(json['themes'] as List),
      moods: List<String>.from(json['moods'] as List),
      era: json['era'] as String,
      context: json['context'] as String,
      source: json['source'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'category': category,
      'themes': themes,
      'moods': moods,
      'era': era,
      'context': context,
      'source': source,
    };
  }

  @override
  bool operator ==(Object other) => other is Quote && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
