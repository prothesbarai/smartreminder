import 'package:flutter/material.dart';

class ScheduleInputSection extends StatelessWidget {

  final TextEditingController wakeUpController;
  final TextEditingController studyController;
  final TextEditingController sleepController;
  final VoidCallback onGenerate;

  const ScheduleInputSection({super.key, required this.wakeUpController, required this.studyController, required this.sleepController, required this.onGenerate,});

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [
        TextField(controller: wakeUpController, decoration: const InputDecoration(labelText: "Wake Up Time", border: OutlineInputBorder(),),),
        const SizedBox(height: 10),
        TextField(controller: studyController, decoration: const InputDecoration(labelText: "Study Hours", border: OutlineInputBorder(),),),
        const SizedBox(height: 10),
        TextField(controller: sleepController, decoration: const InputDecoration(labelText: "Sleep Time", border: OutlineInputBorder(),),),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: onGenerate, child: const Text("Generate Schedule"),),),
      ],
    );
  }
}