import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  late FlutterLocalNotificationsPlugin notification;

  NotificationService() {
    notification = FlutterLocalNotificationsPlugin();
    initNotification();
    initTimeZone();
  }
  initNotification() async {
    const androdInitSettings =
        AndroidInitializationSettings('notification_icon');
    const iosInitSettings = IOSInitializationSettings();
    const initializationSettings = InitializationSettings(
        android: androdInitSettings, iOS: iosInitSettings);
    await notification.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  initTimeZone() async {
    tz.initializeTimeZones();
    final locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    await notification.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  void showNotificationDaily(
      {int id = 0,
      String? title,
      String? body,
      required TimeOfDay scheduleTime}) async {
    notification.zonedSchedule(id, title, body, sceduleDaily(scheduleTime),
        await _notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  void cancelNotification(int id) {
    notification.cancel(id);
  }

  void cancelAllNotifications() {
    notification.cancelAll();
  }

  Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            enableVibration: true,
            enableLights: true,
            color: Colors.blue,
            playSound: true,
            importance: Importance.max,
            priority: Priority.max),
        iOS: IOSNotificationDetails());
  }

  tz.TZDateTime sceduleDaily(TimeOfDay sceduleTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, sceduleTime.hour, sceduleTime.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  onSelectNotification(String? payload) {}
}
