import 'package:hive/hive.dart';
part 'reminder_hive_model.g.dart';

@HiveType(typeId: 0)
class ReminderHiveModel extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String time;

  @HiveField(3)
  final DateTime scheduledTime;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final int? afterDays;

  @HiveField(6)
  final DateTime? customDate;

  ReminderHiveModel({
    required this.id,
    required this.title,
    required this.time,
    required this.scheduledTime,
    required this.type,
    this.afterDays,
    this.customDate,
  });
}