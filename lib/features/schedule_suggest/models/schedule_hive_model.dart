import 'package:hive/hive.dart';
part 'schedule_hive_model.g.dart';

@HiveType(typeId: 1)
class ScheduleHiveModel extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final DateTime date;

  ScheduleHiveModel({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.date,
  });
}