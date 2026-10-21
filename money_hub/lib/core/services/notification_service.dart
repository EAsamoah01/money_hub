import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../features/budget/domain/reminders.dart';

/// Thin wrapper around flutter_local_notifications for bill reminders.
/// Does nothing on platforms without local notifications (web, Windows).
class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'bill_reminders',
      'Bill reminders',
      channelDescription: 'Reminders before bills are due and free trials end',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
    macOS: DarwinNotificationDetails(),
  );

  Future<void> init() async {
    if (!supported || _ready) return;
    const darwin = DarwinInitializationSettings(
      // Ask only when the user turns reminders on, not at first launch.
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: darwin,
      macOS: darwin,
    ));
    _ready = true;
  }

  /// Shows the system "Allow notifications?" prompt (Android 13+, iOS).
  Future<bool> requestPermission() async {
    if (!supported) return false;
    await init();
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await android?.requestNotificationsPermission() ?? true;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      return await ios?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    }
    final mac = _plugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
    return await mac?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
  }

  /// Replaces every scheduled reminder with [reminders].
  Future<void> replaceAll(List<PlannedReminder> reminders) async {
    if (!supported) return;
    await init();
    await _plugin.cancelAll();
    for (final r in reminders) {
      // DateTime → the same instant expressed in UTC, so no time zone
      // database is needed and the reminder fires at the user's local time.
      final when = tz.TZDateTime.from(r.at, tz.UTC);
      try {
        await _plugin.zonedSchedule(
          r.id,
          r.title,
          r.body,
          when,
          _details,
          // Inexact = no special "alarms" permission; may arrive a few minutes late.
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (e) {
        debugPrint('Could not schedule reminder ${r.id}: $e');
      }
    }
  }

  Future<void> cancelAll() async {
    if (!supported) return;
    await init();
    await _plugin.cancelAll();
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

/// app_settings key; false until the user turns reminders on.
const kRemindersEnabledKey = 'reminders_enabled';

/// Loaded in main(); flipped from Settings / the Bills screen.
final remindersEnabledProvider = StateProvider<bool>((ref) => false);
