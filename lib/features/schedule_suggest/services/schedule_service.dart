import 'package:flutter/material.dart';
import '../models/schedule_model.dart';

class ScheduleService {

  static List<ScheduleModel> generate({required TimeOfDay wakeUpTime, required int studyHours, required TimeOfDay sleepTime,}) {
    final List<ScheduleModel> schedules = [];

    DateTime current = DateTime(2025, 1, 1, wakeUpTime.hour,wakeUpTime.minute,);
    schedules.add(ScheduleModel(title: "Wake Up", dateTime: current,),);
    current = current.add(const Duration(minutes: 30),);
    schedules.add(ScheduleModel(title: "Breakfast", dateTime: current,),);
    current = current.add(const Duration(minutes: 30),);

    for (int i = 1; i <= studyHours; i++) {
      schedules.add(ScheduleModel(title: "Study Session $i", dateTime: current,),);
      current = current.add(const Duration(hours: 1),);
      schedules.add(ScheduleModel(title: "Break", dateTime: current,),);
      current = current.add(const Duration(minutes: 15),);
    }
    final sleepDateTime = DateTime(2025, 1, 1, sleepTime.hour, sleepTime.minute,);
    schedules.add(ScheduleModel(title: "Sleep", dateTime: sleepDateTime,),);
    return schedules;
  }

}