import 'package:flutter/material.dart';
import '../models/schedule_model.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleModel schedule;
  const ScheduleCard({super.key, required this.schedule,});

  static String formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      child: ListTile(
        leading: const Icon(Icons.schedule),
        title: Text(schedule.title),
        subtitle: Text(formatTime(schedule.dateTime)),
      ),
    );
  }
}