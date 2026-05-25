import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/premium_input_field.dart';
import '../providers/reminder_provider.dart';
import '../utils/reminder_type.dart';

class RemainderFormScreenPopup extends StatefulWidget {
  final bool isEdit;

  const RemainderFormScreenPopup({super.key, this.isEdit = false});

  @override
  State<RemainderFormScreenPopup> createState() => _RemainderFormScreenPopupState();
}

class _RemainderFormScreenPopupState extends State<RemainderFormScreenPopup> {

  late TextEditingController titleController;
  late TextEditingController afterDaysController;

  late ReminderType selectedType;
  TimeOfDay? selectedTime;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ReminderProvider>(context, listen: false);
    titleController = TextEditingController(text: widget.isEdit ? provider.editingReminder?.title ?? '' : '',);
    afterDaysController = TextEditingController(text: widget.isEdit ? provider.editingReminder?.afterDays?.toString() ?? '' : '',);
    selectedType = provider.selectedType;
    selectedTime = provider.selectedTime;
    selectedDate = provider.customDateTime;
  }

  @override
  void dispose() {
    titleController.dispose();
    afterDaysController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReminderProvider>(context, listen: false);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),),
      title: Text(widget.isEdit ? "Update Reminder" : "Add Reminder"),

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
            if (widget.isEdit) {
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
          child: Text(widget.isEdit ? "Update Reminder" : "Add Reminder",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),),
        ),
        // <<<< ADD BUTTON =============================================
      ],
    );
  }
}
