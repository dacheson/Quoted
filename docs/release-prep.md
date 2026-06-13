# Quoted release prep

## Android release signing

1. Copy `/home/runner/work/Quoted/Quoted/dacheson/Quoted/android/key.properties.example` to `/home/runner/work/Quoted/Quoted/dacheson/Quoted/android/key.properties`.
2. Replace the placeholder values with the real upload keystore path, alias, and passwords.
3. Keep the keystore file and `key.properties` out of version control.

You can also provide the same values through environment variables:

- `QUOTED_UPLOAD_STORE_FILE`
- `QUOTED_UPLOAD_STORE_PASSWORD`
- `QUOTED_UPLOAD_KEY_ALIAS`
- `QUOTED_UPLOAD_KEY_PASSWORD`

## iOS archive and release notes

The project is already set to archive the `Runner` scheme with the `Release` configuration and automatic signing. Manual verification is still required on macOS with Xcode before shipping:

- Confirm the team, bundle identifier, and provisioning profile are correct for `com.dacheson.quoted`
- Run a clean Product > Archive build
- Validate the generated archive in Organizer before export or TestFlight upload

## Store copy

### App Store

- **Name:** Quoted
- **Subtitle:** Quotes for your current mood
- **Promotional text:** Offline quote support for reflective, difficult, and energizing moments — no account, no feed, and no distractions.
- **Description:** Quoted is an offline-first quote companion built for the mood you are in. Choose how you feel, browse a curated quote that matches the moment, and save the lines you want to revisit later. Likes and dislikes quietly personalize future picks, while favorites and dark mode stay on your device. No account is required and no backend is needed.

### Google Play

- **Short description:** Offline quotes tailored to the mood you are in.
- **Full description:** Quoted helps you find a thoughtful quote for the moment you are in. Choose a mood, read a curated quote with context, and save favorites for later. The app works fully offline, keeps personalization on-device, and does not require an account.

Use Quoted to:

- browse quotes matched to ten core moods
- like or dislike quotes to tune future suggestions
- save favorites for quick return visits
- switch between light and dark mode
- keep everything local on your device

## Privacy disclosures

- No account creation
- No analytics or tracking SDKs
- No user data sent to a backend service
- Favorites, likes, dislikes, and dark-mode preference are stored locally on-device
- Quote content is bundled with the app and loaded from local assets

Re-check the App Store privacy form and Google Play Data safety form before submission in case the app changes later.

## Release notes draft

- Added branded launcher icons and launch screens for Android and iOS
- Polished the core app copy and spacing across the main flows
- Improved release readiness with documented signing and store-listing preparation
- Continued to keep quote personalization, favorites, and theme settings fully offline

## Screenshot shot list

Manual capture is still required. Recommended release screenshots:

1. Mood picker on light theme
2. Mood picker on dark theme
3. Quote detail with context expanded
4. Favorites list with saved quotes
5. Settings sheet showing offline controls and dark mode
