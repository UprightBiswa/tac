import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tac_app/core/utils/toast.dart';

/// Push notifications behind an interface, so screens never depend on FCM directly.
///
/// The POC uses [DemoNotificationService]. For real pushes, add
/// `firebase_core` + `firebase_messaging`, put `google-services.json` in
/// `android/app/`, and implement an `FcmNotificationService` that registers
/// [deviceToken] with the NestJS Notifications module. See README.md.
abstract interface class NotificationService {
  Future<void> init();

  /// The token the backend uses to target this device. Null when not available.
  Future<String?> deviceToken();

  /// Shows a notification while the app is in the foreground.
  void showForeground({required String title, required String body});
}

class DemoNotificationService implements NotificationService {
  @override
  Future<void> init() async => debugPrint('NotificationService: demo mode, no FCM.');

  @override
  Future<String?> deviceToken() async => null;

  @override
  void showForeground({required String title, required String body}) =>
      showToast('🔔 $title: $body (demo notification)');
}

final notificationServiceProvider = Provider<NotificationService>((ref) => DemoNotificationService());
