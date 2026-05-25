import 'package:flutter/material.dart';
import '../models/schedule_model.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleModel schedule;
  const ScheduleCard({super.key, required this.schedule,});

  @override
  Widget build(BuildContext context) {

    return Card(
      child: ListTile(
        leading: const Icon(Icons.schedule),
        title: Text(schedule.title),
        subtitle: Text(schedule.time),
      ),
    );
  }
}