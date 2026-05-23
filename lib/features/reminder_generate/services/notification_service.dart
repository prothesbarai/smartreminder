import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class NotificationService {
   static final FlutterLocalNotificationsPlugin _notifications  = FlutterLocalNotificationsPlugin();
   static Future<void> init() async {
     tzdata.initializeTimeZones();
     // >>> Set local timezone (Bangladesh)
     tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
     const android = AndroidInitializationSettings('@mipmap/ic_launcher',);
     const ios = DarwinInitializationSettings();
     const settings = InitializationSettings(android: android, iOS: ios,);
     await _notifications.initialize(settings);
     final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
     await androidPlugin?.requestNotificationsPermission();
     await androidPlugin?.requestExactAlarmsPermission();
     const channel = AndroidNotificationChannel('reminder_channel', 'Reminders', importance: Importance.max);
     await androidPlugin?.createNotificationChannel(channel);
   }

  static Future<void> scheduleNotification({required int id, required String title, required String body, required DateTime scheduledTime,}) async {
    await _notifications.zonedSchedule(id, title, body, tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker' ,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }


}
