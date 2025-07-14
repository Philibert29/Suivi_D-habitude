import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const initializationSettings = InitializationSettings(
      macOS: DarwinInitializationSettings(),
      linux: LinuxInitializationSettings(defaultActionName: 'Ouvrir'),
      // Pas de support pour Windows actuellement
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleDailyNotification({
    required int hour,
    required int minute,
    int id = 0,
    String title = "Rappel d’habitude",
    String body = "Pense à cocher tes habitudes du jour !",
  }) async {
    // Ne rien faire sur Windows
    if (Platform.isWindows) {
      print('Notifications non supportées sur Windows pour le moment.');
      return;
    }

    const notificationDetails = NotificationDetails(
      macOS: DarwinNotificationDetails(),
      linux: LinuxNotificationDetails(),
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
