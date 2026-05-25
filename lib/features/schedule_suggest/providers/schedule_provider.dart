import 'package:flutter/cupertino.dart';
import '../models/schedule_model.dart';

class ScheduleProvider extends ChangeNotifier{

  List<ScheduleModel> schedules = [];

  void generateSchedule({required String wakeUpTime, required String studyHours, required String sleepTime,}) {
    schedules = [
      ScheduleModel(title: "Wake Up", time: wakeUpTime,),
      ScheduleModel(title: "Study Session", time: "$studyHours Hours",),
      ScheduleModel(title: "Sleep", time: sleepTime,),
    ];
    notifyListeners();
  }

}