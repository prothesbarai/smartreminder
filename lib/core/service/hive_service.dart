import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/reminder_generate/models/hive_model/reminder_hive_model.dart';

class HiveService {
  static Future<void> initHive() async{
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(ReminderHiveModelAdapter());

    await Future.wait([
      Hive.openBox<ReminderHiveModel>('reminder_box'),
      Hive.openBox("biometric_box"),
    ]);

  }
  /// >>>> Access All box ======================================================
  static Box<ReminderHiveModel> get remainderBox => Hive.box<ReminderHiveModel>('reminder_box');
  static Box get biometricBox => Hive.box('biometric_box');
  /// <<<< Access All box ======================================================
}