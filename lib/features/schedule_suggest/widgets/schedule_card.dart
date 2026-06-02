import 'package:flutter/material.dart';
import '../models/schedule_hive_model.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleHiveModel schedule;
  const ScheduleCard({super.key, required this.schedule,});

  String formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? "PM" : "AM";
    return "$day/$month/$year • $hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      child: ListTile(
        leading: const Icon(Icons.schedule),
        title: Text(schedule.title),
        subtitle: Text(formatDateTime(schedule.dateTime)),
      ),
    );
  }
}