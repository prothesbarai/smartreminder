import 'package:flutter/cupertino.dart';
import 'package:smartreminder/core/service/hive_service.dart';
import 'package:smartreminder/features/user_account_with_plan/plan/subscription_plan_model.dart';

import '../models/user_account_hive_model.dart';

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
    if (user != null) {
      user.activePlanId = plan == 'free' ? null : user.activePlanId;
      user.save();
    }
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

  static bool buyPlan({required SubscriptionPlanModel plan}) {
    final userBox = HiveService.userAccountBox;
    final user = userBox.get("main_user");
    if (user == null) return false;
    if (user.coinBalance < plan.price) return false;
    // >>> balance cut
    user.coinBalance -= plan.price;
    // >>> activate selected plan
    user.activePlanId = plan.id;
    user.subscriptionStartDate = DateTime.now();
    user.subscriptionDays = plan.days;
    user.save();
    return true;
  }
  // <<< Handles plan switching between FREE and PAID states ===================


  // >>> Add subscription logic  ===============================================
  static const int subscriptionDays = 30;
  // >>> check expired
  static bool isSubscriptionExpired(DateTime startDate, int days) {
    final expiryDate = startDate.add(Duration(days: days));
    return DateTime.now().isAfter(expiryDate);
  }
  // >>> Remaining days
  static int getRemainingDays(DateTime startDate, int days) {
    final expiryDate = startDate.add(Duration(days: days));
    return expiryDate.difference(DateTime.now()).inDays;
  }
  // >>> Auto validate
  static void validateSubscription() {
    final userBox = HiveService.userAccountBox;
    final user = userBox.get("main_user");
    if (user == null) return;
    if (user.activePlanId == null) return;
    final expired = isSubscriptionExpired(user.subscriptionStartDate!, user.subscriptionDays!,);
    if (expired) {
      user.activePlanId = null;
      user.subscriptionStartDate = null;
      user.subscriptionDays = null;
      user.save();
    }
  }
  // >>> Plan Active Check
  static bool isPlanActive(UserAccountHiveModel user, String planId) {
    if (user.activePlanId != planId) return false;
    if (user.subscriptionStartDate == null || user.subscriptionDays == null) {return false;}
    return !isSubscriptionExpired(user.subscriptionStartDate!, user.subscriptionDays!,);
  }
  // <<< Add subscription logic  ===============================================
}