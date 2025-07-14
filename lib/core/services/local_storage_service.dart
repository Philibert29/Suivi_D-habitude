import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


class LocalStorageService {
  static const _hourKey = 'notification_hour';
  static const _minuteKey = 'notification_minute';

  /// Sauvegarde l'heure et la minute
  static Future<void> saveNotificationTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hourKey, hour);
    await prefs.setInt(_minuteKey, minute);
  }

  /// Récupère l'heure et la minute
  static Future<TimeOfDay?> getNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt(_hourKey);
    final minute = prefs.getInt(_minuteKey);

    if (hour != null && minute != null) {
      return TimeOfDay(hour: hour, minute: minute);
    }
    return null;
  }

  /// Réinitialise (optionnel)
  static Future<void> clearNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hourKey);
    await prefs.remove(_minuteKey);
  }
}
