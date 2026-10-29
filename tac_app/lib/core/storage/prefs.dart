import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for non-sensitive local settings. Tokens never go here: see [TokenStorage].
abstract final class PrefKeys {
  static const onboarded = 'onboarded';
  static const firstName = 'first_name';
  static const lastName = 'last_name';
  static const area = 'area';

  static const all = {onboarded, firstName, lastName, area};
}

/// Created once in `main()` and injected with an override.
final sharedPrefsProvider = Provider<SharedPreferencesWithCache>(
  (ref) => throw UnimplementedError('sharedPrefsProvider must be overridden in main()'),
);
