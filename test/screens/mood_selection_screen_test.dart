import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quoted/screens/mood_selection_screen.dart';

import '../helpers/widget_test_support.dart';

void main() {
  useOfflineFonts();
  testWidgets('renders the mood picker entry points', (tester) async {
    // The mood grid is a GridView.builder: on the default 800x600 test
    // surface the last moods are never built, so give it a phone-sized
    // viewport tall enough to hold all ten.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: MoodSelectionScreen(
          darkMode: false,
          onToggleDarkMode: (_) {},
        ),
      ),
    );

    expect(find.text('Quoted'), findsOneWidget);
    expect(find.text('OFFLINE QUOTE COMPANION'), findsOneWidget);
    expect(
      find.text(
        'Pick a mood and Quoted will surface something thoughtful in seconds.',
      ),
      findsOneWidget,
    );
    expect(find.byTooltip('Favorites'), findsOneWidget);
    expect(find.byTooltip('Settings'), findsOneWidget);
    expect(find.text('Calm'), findsOneWidget);
    expect(find.text('Disciplined'), findsOneWidget);
  });
}
