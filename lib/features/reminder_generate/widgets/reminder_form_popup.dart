import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/premium_input_field.dart';
import '../providers/reminder_provider.dart';
import '../utils/reminder_type.dart';

class ReminderFormPopup {
  static Future<void> show(BuildContext context, {bool isEdit = false}) async {
    final provider = Provider.of<ReminderProvider>(context, listen: false);
    final titleController = TextEditingController(text: isEdit ? provider.editingReminder?.title ?? '' : '',);
    final afterDaysController = TextEditingController(text: isEdit ? provider.editingReminder?.afterDays?.toString() ?? '' : '',);
    ReminderType selectedType = provider.selectedType;
    TimeOfDay? selectedTime = provider.selectedTime;
    DateTime? selectedDate = provider.customDateTime;

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),),
              title: Text(isEdit ? "Update Reminder" : "Add Reminder"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // >>>> TITLE INPUT ========================================
                    PremiumInputField(controller: titleController, label: "Reminder Title", icon: Icons.title,),
                    const SizedBox(height: 10),
                    // >>>> TITLE INPUT ========================================

                    // >>>> TIME PICKER ========================================
                    GestureDetector(
                      onTap: () async{
                        final time = await showTimePicker(context: context, initialTime: selectedTime ?? TimeOfDay.now(),);
                        if (time != null) {
                          setState(() {selectedTime = time;});
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: const Color(0xFFF1F3F6), borderRadius: BorderRadius.circular(12),),
                        child: Text(selectedTime == null ? "Select Time" : selectedTime!.format(context),),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // <<<< TIME PICKER ========================================

                    // >>>> DROPDOWN ===========================================
                    DropdownButton<ReminderType>(
                      value: selectedType,
                      isExpanded: true,
                      onChanged: (value) {if (value != null) {setState(() {selectedType = value;});}},
                      items: [
                        DropdownMenuItem(value: ReminderType.today, child: Text("Today")),
                        DropdownMenuItem(value: ReminderType.afterDays, child: Text("After Days")),
                        DropdownMenuItem(value: ReminderType.nextWeek, child: Text("Next Week")),
                        DropdownMenuItem(value: ReminderType.custom, child: Text("Custom Date")),
                      ],
                    ),
                    // <<<< DROPDOWN ===========================================


                    // >>>> AFTER DAYS INPUT ===================================
                    if (selectedType == ReminderType.afterDays)...[
                      TextField(
                        controller: afterDaysController,
                        keyboardType: TextInputType.number,
                        onChanged: (v) {provider.setAfterDays(int.tryParse(v) ?? 1);},
                        decoration: const InputDecoration(labelText: "After how many days?",),
                      ),
                    ],
                    // <<<< AFTER DAYS INPUT ===================================


                    // >>>> CUSTOM DATE PICKER =================================
                    if (selectedType == ReminderType.custom)...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              DateTime? picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2100), initialDate: selectedDate ?? DateTime.now(),);
                              if (picked != null) {setState(() {selectedDate = picked;});}
                            },
                            child: const Text("Pick Date"),
                          ),
                          const SizedBox(height: 8),
                          if (selectedDate != null)...[
                            Text("Selected: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",),
                          ],
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),
                    // <<<< CUSTOM DATE PICKER =================================
                  ],
                ),
              ),

              actions: [

                // >>>> CANCEL BUTTON ==========================================
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF518BCF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14),),),
                  onPressed: () {Navigator.pop(context);},
                  child: Text("Cancel",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),),
                ),
                // <<<< CANCEL BUTTON ==========================================

                // >>>> ADD BUTTON =============================================
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14),),),
                  onPressed: () {
                    String? result;
                    provider.selectedType = selectedType;
                    provider.selectedTime = selectedTime;
                    provider.customDateTime = selectedDate;
                    if (selectedType == ReminderType.afterDays) {provider.afterDaysValue = int.tryParse(afterDaysController.text) ?? 1;}
                    if (isEdit) {
                      result = provider.updateReminder(title: titleController.text);
                    } else {
                      result = provider.addReminder(titleController.text);
                    }
                    Navigator.pop(context);
                    if (result != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)),);
                    } else {
                      provider.clearForm();
                    }
                  },
                  child: Text(isEdit ? "Update Reminder" : "Add Reminder",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),),
                ),
                // <<<< ADD BUTTON =============================================
              ],
            );
          },
        );
      },
    );
  }
}