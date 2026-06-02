import 'package:flutter/material.dart';
import '../../../core/service/hive_service.dart';
import '../../reminder_generate/models/hive_model/reminder_hive_model.dart';
import '../../reminder_generate/providers/reminder_provider.dart';
import '../../reminder_generate/services/notification_service.dart';
import '../../reminder_generate/utils/reminder_type.dart';
import '../models/schedule_hive_model.dart';


class ScheduleReminderBridge {

  static bool isReminderAdded(ScheduleHiveModel schedule) {
    final box = HiveService.remainderBox;
    return box.values.any((e) => e.id == schedule.id);
  }

  static String? toggleReminder(ScheduleHiveModel schedule) {
    final box = HiveService.remainderBox;
    final existingKey = box.keys.firstWhere((k) => box.get(k)?.id == schedule.id, orElse: () => null,);

    // >>> IF EXISTS => REMOVE (CANCEL)
    if (existingKey != null) {
      box.delete(existingKey);
      return null;
    }

    // >>> RULE: Only today allowed
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduleDay = DateTime(schedule.date.year, schedule.date.month, schedule.date.day);
    if (scheduleDay != today) {
      return "Only today's schedule can be added to reminder";
    }

    // >>> CREATE REMINDER
    final reminder = ReminderHiveModel(id: schedule.id, title: schedule.title, time: TimeOfDay.fromDateTime(schedule.dateTime).format(navigatorKey.currentContext!), scheduledTime: schedule.dateTime, type: ReminderType.today.name);
    box.add(reminder);
    // >>> OPTIONAL: notification
    NotificationService.scheduleNotification(id: schedule.id.hashCode & 0x7fffffff, title: "Schedule Reminder", body: schedule.title, scheduledTime: schedule.dateTime,);
    return null;
  }
}