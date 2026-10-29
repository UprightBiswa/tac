/// Build-time configuration, injected with `--dart-define-from-file=env/<flavor>.json`.
///
/// Values are compiled in, not shipped as a readable asset (unlike a bundled
/// `.env`). Still, anything in a mobile binary can be extracted, so never put
/// real secrets here: secrets belong on the NestJS backend.
abstract final class Env {
  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  /// 10.0.2.2 is the host machine as seen from the Android emulator.
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:3000/api/v1');

  /// POC default: serve mock data and never touch the network.
  static const useMockData = bool.fromEnvironment('USE_MOCK_DATA', defaultValue: true);

  /// HTTP logs are only ever printed in debug builds, and only when enabled.
  static const enableHttpLogs = bool.fromEnvironment('ENABLE_HTTP_LOGS');

  static bool get isProd => flavor == 'prod';
}
