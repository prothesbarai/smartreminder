import 'package:flutter/material.dart';
import '../screens/remainder_form_screen_popup.dart';


class ReminderFormPopup {
  static Future<void> show(BuildContext context, {bool isEdit = false}) {
    return showDialog(
      context: context,
      builder: (_) => RemainderFormScreenPopup(isEdit: isEdit),
    );
  }
}