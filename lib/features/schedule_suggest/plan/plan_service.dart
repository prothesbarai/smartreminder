import 'package:smartreminder/core/service/hive_service.dart';

class PlanService {
  static final box = HiveService.schedulePlanSettingsBox;
  static String getPlan() {
    return box.get('user_plan', defaultValue: 'free');
  }
  static void setPlan(String plan) {
    box.put('user_plan', plan);
  }
}