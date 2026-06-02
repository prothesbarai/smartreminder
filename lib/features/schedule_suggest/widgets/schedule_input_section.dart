import 'package:flutter/material.dart';

class ScheduleInputSection extends StatelessWidget {
  final String selectedDateText;
  final String wakeUpText;
  final String sleepText;
  final TextEditingController studyController;
  final VoidCallback onDateTap;
  final VoidCallback onWakeUpTap;
  final VoidCallback onSleepTap;
  final VoidCallback onGenerate;

  const ScheduleInputSection({super.key, required this.selectedDateText, required this.wakeUpText, required this.sleepText, required this.studyController, required this.onDateTap, required this.onWakeUpTap, required this.onSleepTap, required this.onGenerate,});


  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: selectedDateText),
          decoration: const InputDecoration(labelText: "Schedule Date", border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_month),),
          onTap: onDateTap,
        ),

        const SizedBox(height: 10),

        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: wakeUpText,),
          decoration: const InputDecoration(labelText: "Wake Up Time", border: OutlineInputBorder(), suffixIcon: Icon(Icons.access_time),),
          onTap: onWakeUpTap,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: studyController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Study Hours", border: OutlineInputBorder(),),
        ),

        const SizedBox(height: 10),

        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: sleepText,),
          decoration: const InputDecoration(labelText: "Sleep Time", border: OutlineInputBorder(), suffixIcon: Icon(Icons.access_time),),
          onTap: onSleepTap,
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: onGenerate, child: const Text("Generate Schedule",),),
        ),
      ],
    );
  }
}