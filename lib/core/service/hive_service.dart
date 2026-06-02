import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/reminder_generate/models/hive_model/reminder_hive_model.dart';
import '../../features/schedule_suggest/models/schedule_hive_model.dart';

class HiveService {
  static Future<void> initHive() async{
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(ReminderHiveModelAdapter());
    Hive.registerAdapter(ScheduleHiveModelAdapter());

    await Future.wait([
      Hive.openBox<ReminderHiveModel>('reminder_box'),
      Hive.openBox<ScheduleHiveModel>('schedule_box'),
      Hive.openBox("schedule_plan_settings"),
      Hive.openBox("biometric_and_pin_auto_lock_box"),
    ]);

  }
  /// >>>> Access All box ======================================================
  static Box<ReminderHiveModel> get remainderBox => Hive.box<ReminderHiveModel>('reminder_box');
  static Box<ScheduleHiveModel> get scheduleBox => Hive.box<ScheduleHiveModel>('schedule_box');
  static Box get schedulePlanSettingsBox => Hive.box('schedule_plan_settings');
  static Box get biometricPinAutoLockBox => Hive.box('biometric_and_pin_auto_lock_box');
  /// <<<< Access All box ======================================================
}