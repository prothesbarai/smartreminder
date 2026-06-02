import 'package:flutter/material.dart';
import 'package:smartreminder/features/schedule_suggest/plan/plan_service.dart';

class PlanSelectorPopup {
  static void show(BuildContext context) {
    final currentPlan = PlanService.getPlan();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Your Plan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Free"),
              trailing: currentPlan == 'free' ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {PlanService.setPlan('free');Navigator.pop(context);},
            ),

            ListTile(
              title: const Text("Paid"),
              trailing: currentPlan == 'paid' ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {PlanService.setPlan('paid');Navigator.pop(context);},
            ),
          ],
        ),
      ),
    );
  }
}