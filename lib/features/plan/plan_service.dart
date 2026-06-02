import 'package:flutter/cupertino.dart';
import 'package:smartreminder/core/service/hive_service.dart';

class PlanService {
  // >>> PLAN STATE ============================================================
  static final ValueNotifier<String> planNotifier = ValueNotifier<String>(getPlan());
  static final box = HiveService.planSettingsBox;
  // <<< PLAN STATE ============================================================


  // >>> USER PLAN =============================================================
  static String getPlan() {
    return box.get('user_plan', defaultValue: 'free');
  }

  static void setPlan(String plan) {
    box.put('user_plan', plan);
    planNotifier.value = plan;
  }
  // <<< USER PLAN =============================================================


  // >>> DATE WISE GENERATION LIMIT =============================================

  /// Generate usage key by selected date
  static String getDateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  /// Returns generation count of a specific date
  static int getUsageForDate(DateTime date) {
    return box.get("usage_${getDateKey(date)}", defaultValue: 0,);
  }

  /// Increase generation count for a specific date
  static void increaseUsageForDate(DateTime date) {
    final count = getUsageForDate(date);
    box.put("usage_${getDateKey(date)}", count + 1,);
  }

  /// Check if generation limit is available for a date
  static bool canGenerateForDate(DateTime date, int limit,) {
    return getUsageForDate(date) < limit;
  }

  // <<< DATE WISE GENERATION LIMIT =============================================
}