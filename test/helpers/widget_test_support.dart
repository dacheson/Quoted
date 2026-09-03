import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

/// Call once from a widget test's `main()`.
///
/// The theme is built with google_fonts, which downloads font files at runtime.
/// Inside `tester.runAsync` real network calls actually fire, and they fail on
/// CI, so the test reports a font exception instead of whatever it was really
/// asserting. Turning fetching off makes google_fonts use its bundled fallback.
void useOfflineFonts() {
  GoogleFonts.config.allowRuntimeFetching = false;
}

/// Runs [action] on the real event loop, then waits for [until] to hold.
///
/// Use this for storage calls made **directly from the test body**.
///
/// Storage goes through Hive, which is real disk I/O. A future backed by real
/// I/O never completes inside a `testWidgets` body, because the binding runs it
/// in a fake-async zone: the test hangs indefinitely rather than failing.
Future<void> runRealAsync(
  WidgetTester tester,
  Future<void> Function() action, {
  bool Function()? until,
  Duration timeout = const Duration(seconds: 5),
}) async {
  await tester.runAsync(() async {
    await action();
    if (until == null) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return;
    }
    final deadline = DateTime.now().add(timeout);
    while (!until() && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
  });
}

/// Alternates real-event-loop yields with frame pumps until [done] holds.
///
/// Use this **after a tap** whose handler touches storage.
///
/// Such a handler suspends part-way through. The write itself lands straight
/// away, but the continuation after the `await` - typically the `setState` -
/// only resumes once the real event loop has run, and the rebuild only happens
/// on the following pump. One round of each is not enough: the future completes
/// on the first round and the continuation runs on the second. Handlers that
/// await `showDialog` first need more still, because dismissing the dialog
/// needs its own pumps and pumping is forbidden inside `runAsync`.
///
/// Alternating until the expected state appears avoids hard-coding a count.
Future<void> settleUntil(
  WidgetTester tester,
  bool Function() done, {
  int maxRounds = 20,
}) async {
  for (var round = 0; round < maxRounds; round++) {
    if (done()) return;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    // Deliberately not pumpAndSettle: it carries a ten-minute internal timeout,
    // so a single unsettled animation inside this loop would hang the suite
    // rather than fail it. Two bounded pumps advance any transition far enough.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }
}
