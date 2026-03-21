import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/prayer_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    _initialized = true;
  }

  static Future<void> schedulePrayerNotifications(
    List<PrayerTime> prayers,
    int minutesBefore,
    bool enabled,
  ) async {
    if (!enabled) {
      await cancelAll();
      return;
    }

    await cancelAll();

    for (int i = 0; i < prayers.length; i++) {
      final prayer = prayers[i];
      if (!prayer.notificationEnabled) continue;

      final notifyTime = prayer.time.subtract(Duration(minutes: minutesBefore));
      if (notifyTime.isBefore(DateTime.now())) continue;

      final tzTime = tz.TZDateTime.from(notifyTime, tz.local);

      await _notifications.zonedSchedule(
        i,
        'حان وقت ${prayer.nameArabic}',
        minutesBefore > 0
            ? 'تبقى $minutesBefore دقيقة على أذان ${prayer.nameArabic}'
            : 'حان وقت ${prayer.nameArabic} الآن',
        tzTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_times',
            'مواقيت الصلاة',
            channelDescription: 'إشعارات مواقيت الصلاة',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  static Future<bool> requestPermissions() async {
    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return result ?? false;
  }
}
