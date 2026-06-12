import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quoted/screens/mood_selection_screen.dart';

void main() {
  testWidgets('renders the mood picker entry points', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MoodSelectionScreen(
          darkMode: false,
          onToggleDarkMode: (_) {},
        ),
      ),
    );

    expect(find.text('Quoted'), findsOneWidget);
    expect(find.text('Select a mood to receive a quote.'), findsOneWidget);
    expect(find.byTooltip('Favorites'), findsOneWidget);
    expect(find.byTooltip('Settings'), findsOneWidget);
    expect(find.text('Calm'), findsOneWidget);
    expect(find.text('Disciplined'), findsOneWidget);
  });
}
