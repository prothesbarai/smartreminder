import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../utils/date_helper.dart';
import '../widgets/schedule_card.dart';

class ScheduleListScreen extends StatefulWidget {
   const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScheduleProvider>(context);

    if (provider.schedules.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Icon(Icons.schedule, size: 80),
        ),
      );
    }

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.schedules.length,
        itemBuilder: (context, index) {
          final item = provider.schedules[index];
          final currentDate = DateTime(item.date.year, item.date.month, item.date.day,);
          bool showHeader = false;

          if (index == 0) {
            showHeader = true;
          } else {
            final previous = provider.schedules[index - 1];
            final previousDate = DateTime(previous.date.year, previous.date.month, previous.date.day,);
            showHeader = currentDate != previousDate;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showHeader)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12,),
                  child: Center(child: Text(getDateTitle(item.date), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),),
                ),
              ScheduleCard(schedule: item),
            ],
          );
        },
      ),
    );
  }
}