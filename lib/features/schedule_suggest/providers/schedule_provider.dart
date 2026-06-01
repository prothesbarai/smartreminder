import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../services/schedule_service.dart';
class ScheduleProvider extends ChangeNotifier{

  List<ScheduleModel> schedules = [];

  void generateSchedule({ required TimeOfDay wakeUpTime, required int studyHours, required TimeOfDay sleepTime,}) {
    schedules = ScheduleService.generate(wakeUpTime: wakeUpTime, studyHours: studyHours, sleepTime: sleepTime,);
    notifyListeners();
  }

}