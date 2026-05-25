import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../widgets/schedule_card.dart';
import '../widgets/schedule_input_section.dart';

class ScheduleScreen extends StatefulWidget {
   const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {

  final wakeUpController = TextEditingController();
  final studyController = TextEditingController();
  final sleepController = TextEditingController();


  @override
  void dispose() {
    wakeUpController.dispose();
    studyController.dispose();
    sleepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScheduleProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ScheduleInputSection(
              wakeUpController: wakeUpController,
              studyController: studyController,
              sleepController: sleepController,
              onGenerate: () {
                provider.generateSchedule(
                  wakeUpTime: wakeUpController.text,
                  studyHours: studyController.text,
                  sleepTime: sleepController.text,
                );
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: provider.schedules.length,
                itemBuilder: (context, index) {
                  final schedule = provider.schedules[index];
                  return ScheduleCard(schedule: schedule,);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}