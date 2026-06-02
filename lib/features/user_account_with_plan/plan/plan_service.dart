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
    // >>> update plan_settings box
    box.put('user_plan', plan);
    planNotifier.value = plan;

    // >>> ALSO update user account box ========================================
    final userBox = HiveService.userAccountBox;
    final user = userBox.get("main_user");
    if (user != null) {user.plan = plan;user.save();}
    // <<< ALSO update user account box ========================================

  }
  // <<< USER PLAN =============================================================


  // >>> DATE WISE GENERATION LIMIT ============================================
  /// Generate usage key by selected date
  static String getDateKey(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return "$y-$m-$d";
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
  // <<< DATE WISE GENERATION LIMIT ============================================


  // >>> Handles plan switching between FREE and PAID states ===================
  static bool trySwitchPlan({required double paidPlanCost,}) {
    final userBox = HiveService.userAccountBox;
    final user = userBox.get("main_user");
    if (user == null) return false;
    // >>> FREE → PAID
    if (user.plan == 'free') {
      if (user.balance >= paidPlanCost) {
        user.balance -= paidPlanCost;
        user.plan = 'paid';
        user.save();
        setPlan('paid');
        return true;
      } else {
        // not enough balance
        return false;
      }
    }
    // >>> PAID → FREE
    user.plan = 'free';
    user.save();
    setPlan('free');
    return true;
  }
  // <<< Handles plan switching between FREE and PAID states ===================

}