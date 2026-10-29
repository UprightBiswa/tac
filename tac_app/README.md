# TAC — Flutter POC

Ireland-focused carpooling app. **Front-end POC: mock data only, no backend.**
Screens follow [`../docs/FLOW.md`](../docs/FLOW.md): onboarding 01–06, rider 07–15, driver D1–D3.

## Run

```bash
flutter pub get
flutter run --dart-define-from-file=env/dev.json      # or F5 in VS Code ("TAC (dev, mock data)")
flutter analyze && flutter test
```

Demo path: Get started → phone (any 7+ digits) → any 4-digit code → name → Turn on location →
Home → Where to? → Galway → Search → pick a ride → Book seat → Confirm → Start trip → End trip → Rate.
Search **Belmullet** for the empty state. Profile → **Restart demo** resets everything.

## Stack

| Concern | Choice | Why |
|---|---|---|
| State | `flutter_riverpod` 3 (manual providers, no codegen) | Less boilerplate than Bloc, compile-safe DI, repositories swap mock → API with one provider |
| Routing | `go_router` | One route table, redirect guard for onboarding, `StatefulShellRoute` for bottom tabs |
| HTTP | `dio` | One shared client (`dioProvider`) with auth + debug-only logging interceptors |
| Secure storage | `flutter_secure_storage` | Tokens in Android Keystore / iOS Keychain (unused until Auth exists) |
| Local prefs | `shared_preferences` (`WithCache`, allow-listed keys) | Onboarding flag + name only |

No UI kits, no codegen, no native splash. Fonts are system fonts (no network font fetch).

## Structure (feature-first)

```
lib/
  main.dart                    bootstrap: prefs, notification service, ProviderScope
  app/
    app.dart                   MaterialApp.router
    router/                    app_routes.dart (paths), app_router.dart (table + guard), app_shell.dart (bottom nav)
    theme/                     app_colors.dart (FLOW.md §2 tokens), app_theme.dart (Material 3)
  core/
    constants/                 app_sizes.dart (8-pt grid, radii, Gap), app_constants.dart (strings, fees, limits)
    env/env.dart               --dart-define values
    network/                   dio_client.dart, app_exception.dart (DioException → AppException)
    storage/                   prefs.dart, token_storage.dart
    notifications/             NotificationService interface + demo impl (FCM later)
    utils/ widgets/            toast, formatters; PrimaryButton, MapPreview, CountStepper, …
  features/<feature>/
    domain/                    plain models (+ fromJson for the future API)
    data/                      Repository interface + Mock + Api implementations
    application/               Riverpod Notifiers / providers
    presentation/              screens and widgets
```

Rules: widgets never call Dio or repositories directly; they go through providers. `ref.watch` in `build`,
`ref.read` in callbacks. Colours, sizes and routes come from `AppColors`, `AppSizes`/`Gap`, `AppRoutes`.

## Environment

`env/dev.json` is committed (no secrets). Copy `env/prod.example.json` → `env/prod.json` (git-ignored).
Values are compiled in via `--dart-define-from-file`, **not** bundled as a readable `.env` asset.
Anything in an app binary can be extracted, so real secrets stay on the NestJS backend.

| Key | Default | Meaning |
|---|---|---|
| `FLAVOR` | `dev` | `dev` / `staging` / `prod` |
| `API_BASE_URL` | `http://10.0.2.2:3000/api/v1` | NestJS base URL (prod must be HTTPS; enforced at startup) |
| `USE_MOCK_DATA` | `true` | `false` switches repositories to the Dio-backed `Api*Repository` |
| `ENABLE_HTTP_LOGS` | `false` | Dio logging, debug builds only, never logs headers |

## Security baseline

- Android: `allowBackup=false` + `data_extraction_rules.xml` (no cloud backup or device transfer of app data).
- Network security config: HTTPS only in release; debug allows cleartext to `10.0.2.2`/`localhost` only.
- Release build: R8 minify + resource shrinking. Ship with `flutter build appbundle --obfuscate --split-debug-info=build/symbols --dart-define-from-file=env/prod.json`.
- Tokens only in secure storage. 401 clears them (refresh flow is a TODO for the Auth module).
- Phone number is kept in memory only. No permissions requested yet (location and push are simulated).
- TODO before store release: upload keystore via `android/key.properties` (git-ignored), final app ID.

## Push notifications (FCM): later, not in POC

The architecture's Notifications module sends push via FCM, so the app will need it. To add it:
1. Create the Firebase project, add the Android app (final app ID), download `google-services.json` to `android/app/`.
2. `flutter pub add firebase_core firebase_messaging` and run `flutterfire configure`.
3. Implement `FcmNotificationService implements NotificationService` (permission request on Android 13+ with
   `POST_NOTIFICATIONS`, token → `POST /notifications/devices`, foreground and background handlers), then
   override `notificationServiceProvider` with it.

Screens already call `NotificationService`, so no UI changes are needed.

## Open items

App ID (`com.tacindustries.tac_app` is a placeholder), approved logo (text wordmark for now), fonts,
maps provider (map is an illustration), SMS provider, Google OAuth.
