import 'package:flutter/material.dart';

class ReminderTimeHelper {

  /// >>> BASIC TIME (today or tomorrow auto fix) ==============================
  static DateTime convertToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    final scheduled = DateTime(now.year, now.month, now.day, time.hour, time.minute,);
    return scheduled;
  }
  /// <<< BASIC TIME (today or tomorrow auto fix) ==============================


  /// >>> AFTER X DAYS =========================================================
  static DateTime afterDays(TimeOfDay time, int days) {
    final now = DateTime.now();
    final baseDate = now.add(Duration(days: days));
    return DateTime(baseDate.year, baseDate.month, baseDate.day, time.hour, time.minute,);
  }
  /// <<< AFTER X DAYS =========================================================


  /// >>>> NEXT WEEK ===========================================================
  static DateTime nextWeek(TimeOfDay time) {
    final now = DateTime.now();
    final baseDate = now.add(const Duration(days: 7));
    return DateTime(baseDate.year, baseDate.month, baseDate.day, time.hour, time.minute,);
  }
  /// <<<< NEXT WEEK ===========================================================


  /// >>> CUSTOM DATE + TIME ===================================================
  static DateTime customDate(DateTime date, TimeOfDay time,) {
    final scheduled = DateTime(date.year, date.month, date.day, time.hour, time.minute,);
    return scheduled;
  }
  /// <<< CUSTOM DATE + TIME ===================================================
}