import 'package:flutter/material.dart';
import '../screens/schedule_form_screen_popup.dart';

class ScheduleFormPopup {
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => ScheduleFormScreenPopup(),
    );
  }
}
