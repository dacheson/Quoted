# Quoted

A wise word for whatever mood you are in.

An offline-first Flutter app that delivers contextual quotes based on your mood. Like or dislike quotes to personalize your experience. Fully offline, no backend required.

## Status

✅ MVP-ready foundation on `copilot/check-next-steps`

## Run locally

1. Install Flutter 3.10 or newer.
2. Run `flutter pub get`.
3. Launch the app with `flutter run`.

## Validation

- `flutter analyze`
- `flutter test`

> Manual follow-up: this sandbox does not include the Flutter SDK, so device smoke tests and local Flutter validation still need to be run in a Flutter-enabled environment.

## Included in the MVP

- [x] Mood-based quote selection
- [x] Offline favorites and dark mode
- [x] Persisted likes/dislikes for personalization across app restarts
- [x] Local quote dataset with contextual source details
- [x] Basic automated coverage for ranking, persistence, and core UI

## Ship-ready checklist

### Product and UX

- [x] Ship the core quote flow for all moods
- [x] Persist favorites, likes/dislikes, and dark mode locally
- [x] Cover exhausted and empty states in the main user flows
- [x] Add final app icon, launch branding, and a polish pass for spacing/copy
- [ ] Smoke-test every mood flow on physical iOS and Android devices *(manual: requires device access)*

### Quality

- [x] Document the local setup and validation commands
- [x] Cover ranking, persistence, session-state, and mood-selection behavior with tests
- [x] Add widget coverage for favorites and settings flows
- [ ] Run `flutter analyze` successfully in a Flutter-enabled environment *(manual: Flutter SDK unavailable in this sandbox)*
- [ ] Run `flutter test` successfully in a Flutter-enabled environment *(manual: Flutter SDK unavailable in this sandbox)*
- [x] Add CI automation for `flutter analyze` and `flutter test`

### Release ops

- [x] Replace the Android debug signing config with a real release signing setup
- [ ] Verify iOS archive/release configuration *(manual: requires Xcode archive validation on macOS)*
- [x] Prepare store copy, privacy disclosures, and release notes in `/docs/release-prep.md`
- [ ] Capture final store screenshots from release builds *(manual: requires emulator/device capture)*
- [ ] Produce and review a beta build for each platform *(manual: requires release tooling and installable builds)*
