# SwiftType — implementation starter (0.1.0)

This package starts the real Flutter companion app and native Android IME implementation.

## Source preservation
The original, unmodified `SwiftType UI.zip` is retained in `source_designs/SwiftType UI.zip`. The original design exports are the source of truth. The app's dark navy / electric blue / purple direction follows those exports.

## Implemented in this starter
- Flutter app shell with Home, Themes, Fonts, Stylish Text Studio and Settings.
- Keyboard playground with selectable Layout 1 / Layout 2 preference.
- Android `InputMethodService` registration.
- Native key rendering and text insertion through `InputConnection`.
- English QWERTY with shift state, two initial Amharic key grids, symbol page, delete, enter and space.
- Long-press variation popup for a first set of common Fidel families.
- Flutter-to-native method channel for saving selected Amharic layout and opening Android IME settings.

## Important status / limitations
This is the first implementation milestone, not a finished production keyboard.
- The supplied screenshots do not provide a complete authoritative Fidel mapping specification. The current native mapping is an editable starter and MUST be reviewed with a fluent Amharic typist before release.
- Layout 1 is an approximate first-pass grid based on the screenshot; its exact per-key sequence requires confirmation.
- Layout 2 has a starter set of base Fidel keys and long-press variations. Not all Ethiopic blocks, punctuation, numeral systems, dead keys or input conventions are implemented.
- Suggestions, autocorrect, personal dictionary, GIF/sticker provider, downloadable themes, actual font assets and privacy disclosures are not production-ready.
- Benaiah redistribution rights were not verified. Do not ship it until its license is confirmed.
- No APK is included because this environment does not have Flutter/Android SDK tooling installed. Build on a machine with Flutter stable, Android Studio, Android SDK and JDK 17.

## Build
1. Install Flutter stable, Android Studio, Android SDK and JDK 17.
2. From this folder run `flutter pub get`.
3. Run `flutter create . --platforms=android` only if Flutter reports missing generated platform scaffolding; preserve the custom Kotlin files and manifest while doing so.
4. Run `flutter run` on an Android device.
5. In SwiftType open Keyboard playground and tap "Enable SwiftType keyboard in Android settings".
6. Enable SwiftType Keyboard in Android settings, then select it from the system keyboard picker.

## Next engineering milestones
1. Verify each key in both supplied keyboard screenshots with the user and an Amharic language reviewer.
2. Complete the Fidel map and variation selection UX (including popup positioning and all character families).
3. Implement proper English/Amharic IME switching and keyboard subtype handling.
4. Add persisted preferences for sound, vibration, height, key size, font, theme and suggestions.
5. Add privacy policy and explicit input-data handling; keep typed content local by default.
6. Add font files only after license and coverage checks.
7. Test across Android versions, portrait/landscape, different screen densities and real receiving apps.
