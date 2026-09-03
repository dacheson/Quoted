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

/// Taps [finder] and lets a handler that awaits storage run to completion.
///
/// Use this for any tap whose handler awaits Hive.
///
/// The tap must be dispatched **inside** `tester.runAsync`. A `testWidgets`
/// body runs in a fake-async zone, and a future backed by real I/O created in
/// that zone never completes - the handler stays suspended and the test hangs
/// until the per-test timeout kills it, rather than failing with something you
/// can read. Inside `runAsync` the await runs on the real event loop instead.
///
/// The pumps have to come after, not inside: pumping is forbidden within
/// `runAsync`. The first flushes the handler's `setState`, the second advances
/// any transition it started, such as a snackbar.
///
/// Yielding on the real loop *after* an outside-the-zone tap does not work -
/// that drives a continuation, and the await itself is what is stuck.
Future<void> tapAndSettle(
  WidgetTester tester,
  Finder finder, {
  Duration settle = const Duration(milliseconds: 300),
}) async {
  await tester.runAsync(() async {
    await tester.tap(finder);
    await Future<void>.delayed(settle);
  });
  await tester.pump();
  await tester.pump(settle);
}
