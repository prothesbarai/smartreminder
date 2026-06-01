import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../widgets/schedule_input_section.dart';

class ScheduleFormScreenPopup extends StatefulWidget {
  const ScheduleFormScreenPopup({super.key});

  @override
  State<ScheduleFormScreenPopup> createState() => _ScheduleFormScreenPopupState();
}

class _ScheduleFormScreenPopupState extends State<ScheduleFormScreenPopup> {

  final studyController = TextEditingController();
  TimeOfDay? wakeUpTime;
  TimeOfDay? sleepTime;

  // >>>> Time Formating Functions =============================================
  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
  // <<<< Time Formating Functions =============================================

  // >>> Pick WakeU Time =======================================================
  Future<void> pickWakeUpTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now(),);
    if (picked != null) {
      final now = TimeOfDay.now();
      // >>> past time block (same day assumption)
      final pickedMinutes = picked.hour * 60 + picked.minute;
      final nowMinutes = now.hour * 60 + now.minute;
      if (pickedMinutes < nowMinutes) {
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Past time cannot be selected.")),);
        return;
      }
      setState(() => wakeUpTime = picked);
    }
  }
  // <<< Pick WakeU Time =======================================================

  // >>>> Pick Sleep Time ======================================================
  Future<void> pickSleepTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now(),);
    if (picked != null) {
      final now = TimeOfDay.now();
      final pickedMinutes = picked.hour * 60 + picked.minute;
      final nowMinutes = now.hour * 60 + now.minute;
      if (pickedMinutes < nowMinutes) {
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Past time cannot be selected.")),);
        return;
      }

      setState(() => sleepTime = picked);
    }
  }
  // <<<< Pick Sleep Time ======================================================


  @override
  void dispose() {
    studyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScheduleProvider>(context);
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScheduleInputSection(
            wakeUpText: wakeUpTime == null ? '' : formatTime(wakeUpTime!),
            sleepText: sleepTime == null ? '' : formatTime(sleepTime!),
            studyController: studyController,
            onWakeUpTap: pickWakeUpTime,
            onSleepTap: pickSleepTime,
            onGenerate: () {
              if (wakeUpTime == null || sleepTime == null || studyController.text.isEmpty) return;
              final now = TimeOfDay.now();
              final wakeMin = wakeUpTime!.hour * 60 + wakeUpTime!.minute;
              final sleepMin = sleepTime!.hour * 60 + sleepTime!.minute;
              final nowMin = now.hour * 60 + now.minute;

              if (wakeMin < nowMin || sleepMin < nowMin) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You cannot make a schedule using old time.")),);
                return;
              }
              provider.generateSchedule(wakeUpTime: wakeUpTime!, studyHours: int.parse(studyController.text), sleepTime: sleepTime!,);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
