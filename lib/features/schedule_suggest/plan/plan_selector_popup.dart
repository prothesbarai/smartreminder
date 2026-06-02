import 'package:flutter/material.dart';
import 'package:smartreminder/features/schedule_suggest/plan/plan_service.dart';

class PlanSelectorPopup {
  static Future<String?> show(BuildContext context) async {
    final currentPlan = PlanService.getPlan();

    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Your Plan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Free"),
              trailing: currentPlan == 'free' ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {PlanService.setPlan('free');Navigator.pop(context, 'free');},
            ),

            ListTile(
              title: const Text("Paid"),
              trailing: currentPlan == 'paid' ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {PlanService.setPlan('paid');Navigator.pop(context, 'paid');},
            ),
          ],
        ),
      ),
    );
  }
}