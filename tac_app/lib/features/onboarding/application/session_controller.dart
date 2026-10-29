import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tac_app/core/storage/prefs.dart';

class Session {
  const Session({this.firstName = '', this.lastName = '', this.phone = '', this.area = '', this.onboarded = false});

  final String firstName;
  final String lastName;

  /// Kept in memory only: a real number would come from the Auth module.
  final String phone;
  final String area;
  final bool onboarded;

  String get greetingName => firstName.isEmpty ? 'there' : firstName;

  String get fullName => '$firstName $lastName'.trim();

  String get initials => [firstName, lastName].where((p) => p.isNotEmpty).map((p) => p[0].toUpperCase()).join();

  Session copyWith({String? firstName, String? lastName, String? phone, String? area, bool? onboarded}) => Session(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    phone: phone ?? this.phone,
    area: area ?? this.area,
    onboarded: onboarded ?? this.onboarded,
  );
}

/// The signed-up user (screens 03–06). Profile basics persist; the phone does not.
class SessionController extends Notifier<Session> {
  SharedPreferencesWithCache get _prefs => ref.read(sharedPrefsProvider);

  @override
  Session build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return Session(
      firstName: prefs.getString(PrefKeys.firstName) ?? '',
      lastName: prefs.getString(PrefKeys.lastName) ?? '',
      area: prefs.getString(PrefKeys.area) ?? '',
      onboarded: prefs.getBool(PrefKeys.onboarded) ?? false,
    );
  }

  void setPhone(String phone) => state = state.copyWith(phone: phone);

  void setName(String firstName, String lastName) =>
      state = state.copyWith(firstName: firstName.trim(), lastName: lastName.trim());

  Future<void> completeOnboarding({required String area}) async {
    await _prefs.setString(PrefKeys.firstName, state.firstName);
    await _prefs.setString(PrefKeys.lastName, state.lastName);
    await _prefs.setString(PrefKeys.area, area);
    await _prefs.setBool(PrefKeys.onboarded, true);
    state = state.copyWith(area: area, onboarded: true);
  }

  Future<void> reset() async {
    await _prefs.clear();
    state = const Session();
  }
}

final sessionProvider = NotifierProvider<SessionController, Session>(SessionController.new);
