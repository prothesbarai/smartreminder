import 'package:flutter/material.dart';
import 'package:smartreminder/features/schedule_suggest/plan/plan_service.dart';

class PlanSelectorPopup {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Your Plan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text("Free"), onTap: () {PlanService.setPlan('free');Navigator.pop(context);},),
            ListTile(title: const Text("Basic (2/day)"), onTap: () {PlanService.setPlan('paidBasic');Navigator.pop(context);},),
            ListTile(title: const Text("Pro (5/day)"), onTap: () {PlanService.setPlan('paidPro');Navigator.pop(context);},),
            ListTile(title: const Text("Premium (Unlimited)"), onTap: () {PlanService.setPlan('paidPremium');Navigator.pop(context);},),
          ],
        ),
      ),
    );
  }
}