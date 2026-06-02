import 'package:flutter/material.dart';
import '../../../core/service/hive_service.dart';
import '../models/schedule_hive_model.dart';
import '../services/schedule_service.dart';

class ScheduleProvider extends ChangeNotifier {

  List<ScheduleHiveModel> schedules = [];


  ScheduleProvider(){
    loadSchedules();
  }


  // >>> LOAD + AUTO CLEANUP (7 days) ==========================================
  Future<void> loadSchedules() async {
    await _cleanupOldData();
    schedules = HiveService.scheduleBox.values.toList();
    schedules.sort((a, b) => a.dateTime.compareTo(b.dateTime),);
    notifyListeners();
  }
  // <<< LOAD + AUTO CLEANUP (7 days) ==========================================


  // >>>> INTERNAL CLEANUP FUNCTION ============================================
  Future<void> _cleanupOldData() async {
    final box = HiveService.scheduleBox;
    final limit = DateTime.now().subtract(const Duration(days: 7));
    final keysToDelete = <dynamic>[];
    for (var key in box.keys) {
      final item = box.get(key);
      if (item != null && item.dateTime.isBefore(limit)) {
        keysToDelete.add(key);
      }
    }
    for (var key in keysToDelete) {
      await box.delete(key);
    }
  }
  // <<<< INTERNAL CLEANUP FUNCTION ============================================

  // >>>> GENERATE + SAVE TO HIVE ==============================================
  Future<void> generateAndSaveSchedule({required DateTime selectedDate,required TimeOfDay wakeUpTime, required int studyHours, required TimeOfDay sleepTime,required BuildContext context, bool forceReplace = false,}) async {
    final box = HiveService.scheduleBox;

    // >>> Generate new schedule list
    final generated = ScheduleService.generate(selectedDate: selectedDate,wakeUpTime: wakeUpTime, studyHours: studyHours, sleepTime: sleepTime,);

    // >>> SAVE NEW SCHEDULE FOR ALL
    // >>> await box.clear();
    for (var item in generated) {
      await box.put(item.id, item);
    }
    schedules = box.values.toList();
    schedules.sort((a, b) => a.dateTime.compareTo(b.dateTime),);
    notifyListeners();
  }
  // <<<< GENERATE + SAVE TO HIVE ==============================================


  // >>>> DELETE SINGLE ITEM ===================================================
  Future<void> deleteSchedule(String id) async {
    await HiveService.scheduleBox.delete(id);
    schedules.removeWhere((e) => e.id == id);
    notifyListeners();
  }
  // <<<< DELETE SINGLE ITEM ===================================================


  // >>>>> REFRESH =============================================================
  Future<void> refresh() async {
    schedules = HiveService.scheduleBox.values.toList();
    schedules.sort((a, b) => a.dateTime.compareTo(b.dateTime),);
    notifyListeners();
  }
  // <<<<< REFRESH =============================================================


  // >>>>>> Date Wise Remove Schedule List =====================================
  Future<void> deleteSchedulesByDate(DateTime date) async {
    final box = HiveService.scheduleBox;
    final keys = box.keys.where((key) {
      final item = box.get(key);
      if (item == null) return false;
      return item.date.year == date.year && item.date.month == date.month && item.date.day == date.day;
    }).toList();
    for (final key in keys) {
      await box.delete(key);
    }
    await refresh();
  }
  // <<<<<< Date Wise Remove Schedule List =====================================


  // >>> CHECK DATE ALREADY EXISTS =============================================
  bool hasScheduleForDate(DateTime date) {
    return schedules.any((e) => e.date.year == date.year && e.date.month == date.month && e.date.day == date.day,);
  }
  // <<< CHECK DATE ALREADY EXISTS =============================================
}