import 'package:flutter/material.dart';
import '../../../core/service/hive_service.dart';
import '../models/hive_model/reminder_hive_model.dart';
import '../services/notification_service.dart';
import '../utils/reminder_time_helper.dart';
import '../utils/reminder_type.dart';
import 'package:uuid/uuid.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ReminderProvider extends ChangeNotifier{
  List<ReminderHiveModel> remindersHive = [];
  ReminderHiveModel? editingReminder;
  TimeOfDay? selectedTime;
  ReminderType selectedType = ReminderType.today;
  DateTime? customDateTime;
  int afterDaysValue = 1;
  int? editingIndex;


  ReminderProvider() {
    // >>> First delete the expired reminder ===================================
    removeExpiredReminders();
    // <<< First delete the expired reminder ===================================
    loadReminders();
  }


  /// >>>> User Select Enum Based On Remainder =================================
  void setReminderType(ReminderType type) {
    selectedType = type;
    notifyListeners();
  }

  void setAfterDays(int days) {
    afterDaysValue = days;
    notifyListeners();
  }

  void setCustomDate(DateTime date) {
    customDateTime = date;
    notifyListeners();
  }

  DateTime getScheduledTime() {
    switch (selectedType) {
      case ReminderType.today:
        return ReminderTimeHelper.convertToDateTime(selectedTime!);
      case ReminderType.afterDays:
        return ReminderTimeHelper.afterDays(selectedTime!, afterDaysValue);
      case ReminderType.nextWeek:
        return ReminderTimeHelper.nextWeek(selectedTime!);
      case ReminderType.custom:
        if (customDateTime == null) {
          throw Exception("Custom date not selected");
        }
        return ReminderTimeHelper.customDate(customDateTime!, selectedTime!);
    }
  }
  /// <<<< User Select Enum Based On Remainder =================================


  // >>> LOAD REMINDERS ========================================================
  void loadReminders() {
    // >>> First delete the expired reminder ===================================
    removeExpiredReminders();
    // <<< First delete the expired reminder ===================================
    remindersHive = HiveService.remainderBox.values.toList();
    notifyListeners();
  }
  // <<< LOAD REMINDERS ========================================================


  // >>> SET TIME ==============================================================
  void setTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }
  // <<< SET TIME ==============================================================


  // >>> ADD REMINDER ==========================================================
  String? addReminder(String title) {
    if (title.trim().isEmpty) {return "Please enter a title";}
    if (selectedTime == null) {return "Please select a time";}
    DateTime scheduledDate = getScheduledTime();
    // >>> SAFETY CHECK
    if (scheduledDate.isBefore(DateTime.now())) {return "Selected time already passed";}
    final reminder = ReminderHiveModel(id: const Uuid().v4(), title: title, time: selectedTime!.format(navigatorKey.currentContext!), scheduledTime: scheduledDate, type: selectedType.name, afterDays: selectedType == ReminderType.afterDays ? afterDaysValue : null, customDate: selectedType == ReminderType.custom ? customDateTime : null,);
    // >>>  SAVE TO HIVE
    HiveService.remainderBox.add(reminder);
    // >>> UPDATE LOCAL LIST
    remindersHive = HiveService.remainderBox.values.toList();
    NotificationService.scheduleNotification(id: remindersHive.length, title: "Reminder", body: title, scheduledTime: scheduledDate,);
    clearForm();
    return null;
  }
  // <<< ADD REMINDER ==========================================================


  // >>> UPDATE REMINDER =======================================================
  void startEdit(ReminderHiveModel item, int index) {
    editingIndex = index;
    editingReminder = item;
    selectedTime = TimeOfDay.fromDateTime(item.scheduledTime);
    selectedType = ReminderType.values.byName(item.type);
    afterDaysValue = item.afterDays ?? 1;
    customDateTime = item.customDate;
    notifyListeners();
  }
  String? updateReminder({required String title,}) {
    final scheduledDate = getScheduledTime();
    // >>> SAFETY CHECK
    if (scheduledDate.isBefore(DateTime.now())) {return "Selected time already passed";}
    if (title.trim().isEmpty) {return "Please enter a title";}
    if (selectedTime == null) {return "Please select a time";}
    if (editingReminder == null) {return "No reminder selected";}
    final box = HiveService.remainderBox;
    final updatedReminder = ReminderHiveModel(id: editingReminder!.id, title: title, time: selectedTime!.format(navigatorKey.currentContext!,), scheduledTime: getScheduledTime(), type: selectedType.name, afterDays: selectedType == ReminderType.afterDays ? afterDaysValue : null, customDate: selectedType == ReminderType.custom ? customDateTime : null,);
    final index = box.values.toList().indexWhere((e) => e.id == editingReminder!.id,);
    if (index == -1) {return "Reminder not found";}
    final oldItem = box.getAt(index);
    if (oldItem == null) {return "Reminder missing";}
    box.put(oldItem.key, updatedReminder);
    remindersHive = box.values.toList();
    clearForm();
    return null;
  }
  // <<< UPDATE REMINDER =======================================================


  // >>> DELETE REMINDER =======================================================
  void deleteReminder(int index) {
    final box = HiveService.remainderBox;
    if (index < 0 || index >= box.length) return;
    final item = box.getAt(index);
    if (item == null) return;
    // >>> key-based delete
    box.delete(item.key);
    remindersHive = box.values.toList();
    notifyListeners();
  }
  // <<< DELETE REMINDER =======================================================


  // >>> Common Clear Form Method ==============================================
  void clearForm() {
    selectedTime = null;
    selectedType = ReminderType.today;
    customDateTime = null;
    afterDaysValue = 1;
    editingIndex = null;
    editingReminder = null;
    notifyListeners();
  }
  // <<< Common Clear Form Method ==============================================



  // >>> AUTO DELETE COMPLETED REMINDERS AFTER 48 HOURS ========================
  void removeExpiredReminders() {
    final box = HiveService.remainderBox;
    final now = DateTime.now();
    final keysToDelete = [];
    for (final item in box.values) {
      // >>> 48 hours after reminder completion
      final deleteAfter = item.scheduledTime.add(const Duration(hours: 48),);
      // >>> If 48 hours have passed
      if (now.isAfter(deleteAfter)) {
        keysToDelete.add(item.key);
      }
    }
    // >>> Delete from Hive
    for (final key in keysToDelete) {
      box.delete(key);
    }
    remindersHive = box.values.toList();
    notifyListeners();
  }
  // <<< AUTO DELETE COMPLETED REMINDERS AFTER 48 HOURS ========================

}