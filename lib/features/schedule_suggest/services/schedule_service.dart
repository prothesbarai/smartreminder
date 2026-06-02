import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/schedule_hive_model.dart';

class ScheduleService {

  static List<ScheduleHiveModel> generate({required DateTime selectedDate, required TimeOfDay wakeUpTime, required int studyHours, required TimeOfDay sleepTime,}) {
    final List<ScheduleHiveModel> schedules = [];
    final uuid = Uuid();
    DateTime wake = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, wakeUpTime.hour, wakeUpTime.minute,);
    DateTime sleep = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, sleepTime.hour, sleepTime.minute,);
    if (sleep.isBefore(wake)) {sleep = sleep.add(const Duration(days: 1));}

    DateTime current = wake;
    schedules.add(ScheduleHiveModel(id: uuid.v4(), title: "Wake Up", dateTime: current, date: selectedDate,));

    current = current.add(const Duration(minutes: 30));

    for (int i = 1; i <= studyHours; i++) {
      if (current.add(const Duration(hours: 1)).isAfter(sleep)) break;
      schedules.add(ScheduleHiveModel(id: uuid.v4(), title: "Study $i", dateTime: current, date: selectedDate,));
      current = current.add(const Duration(hours: 1));
    }
    schedules.add(ScheduleHiveModel(id: uuid.v4(), title: "Sleep", dateTime: sleep, date: selectedDate,));
    return schedules;
  }
}