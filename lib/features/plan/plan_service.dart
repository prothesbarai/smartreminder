import 'package:flutter/cupertino.dart';
import 'package:smartreminder/core/service/hive_service.dart';

class PlanService {
  static final ValueNotifier<String> planNotifier = ValueNotifier<String>(getPlan());
  static final box = HiveService.schedulePlanSettingsBox;
  static String getPlan() {
    return box.get('user_plan', defaultValue: 'free');
  }

  static void setPlan(String plan) {
    box.put('user_plan', plan);
    planNotifier.value = plan;
  }
}