import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/premium_input_field.dart';
import '../../../core/widgets/sr_app_bar.dart';
import '../providers/reminder_provider.dart';
import '../utils/reminder_type.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController afterDaysController = TextEditingController();

  // >>> Pick Time Function ====================================================
  Future<void> pickTime(BuildContext context) async {
    final provider =
    Provider.of<ReminderProvider>(context, listen: false);
    final TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now(),);
    if (!context.mounted || time == null) return;
    provider.setTime(time);
  }
  // <<< Pick Time Function ====================================================


  @override
  void dispose() {
    titleController.dispose();
    afterDaysController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ReminderProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: const SrAppBar(),

      body: RefreshIndicator(
        onRefresh: () async {
          provider.loadReminders();
          if (provider.remindersHive.isEmpty) {titleController.clear();afterDaysController.clear();provider.clearForm();}
          await Future.delayed(const Duration(milliseconds: 500),);
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
        
              // >>>> ===================== LIST SECTION =======================
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.38, bottom: MediaQuery.of(context).viewInsets.bottom,),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 6),),],),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.all(12),
                      itemCount: provider.remindersHive.length,
                      itemBuilder: (context, index) {
                        final item = provider.remindersHive[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 6),),],),
                          child: ListTile(
                            leading: const Icon(Icons.alarm, color: Color(0xFF6C63FF),),
                            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600,),),
                            subtitle: Text(item.time),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {titleController.text = item.title;afterDaysController.text = item.afterDays?.toString() ?? '';provider.startEdit(item, index);},),
                                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {provider.deleteReminder(index);},),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // >>>> ===================== LIST SECTION =======================
        
        
              // >>>> ===================== INPUT CARD (STICKY) ================
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8),),],),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // >>>> TITLE INPUT ======================================
                        PremiumInputField(controller: titleController, label: "Reminder Title", icon: Icons.title,),
                        const SizedBox(height: 10),
                        // >>>> TIME PICKER ======================================
                        GestureDetector(
                          onTap: () => pickTime(context),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: const Color(0xFFF1F3F6), borderRadius: BorderRadius.circular(12),),
                            child: Text(provider.selectedTime == null ? "Select Time" : provider.selectedTime!.format(context),),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // >>>> DROPDOWN =========================================
                        DropdownButton<ReminderType>(
                          value: provider.selectedType,
                          isExpanded: true,
                          onChanged: (value) {if (value != null) {provider.setReminderType(value);}},
                          items: const [
                            DropdownMenuItem(value: ReminderType.today, child: Text("Today")),
                            DropdownMenuItem(value: ReminderType.afterDays, child: Text("After Days")),
                            DropdownMenuItem(value: ReminderType.nextWeek, child: Text("Next Week")),
                            DropdownMenuItem(value: ReminderType.custom, child: Text("Custom Date")),
                          ],
                        ),
        
                        // >>>> AFTER DAYS INPUT =================================
                        if (provider.selectedType == ReminderType.afterDays)...[
                          TextField(
                            controller: afterDaysController,
                            keyboardType: TextInputType.number,
                            onChanged: (v) => provider.setAfterDays(int.tryParse(v) ?? 1),
                            decoration: const InputDecoration(labelText: "After how many days?",),
                          ),
                        ],
        
        
                        // >>>> CUSTOM DATE PICKER ===============================
                        if (provider.selectedType == ReminderType.custom)...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  DateTime? picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2100), initialDate: provider.editingReminder?.customDate ?? provider.customDateTime ?? DateTime.now(),);
                                  if (picked != null) {provider.setCustomDate(picked);}
                                },
                                child: const Text("Pick Date"),
                              ),
                              const SizedBox(height: 8),
                              if (provider.selectedType == ReminderType.custom && (provider.customDateTime != null || provider.editingReminder?.customDate != null))...[
                                Text("Selected Date: ""${provider.customDateTime!.day}/""${provider.customDateTime!.month}/""${provider.customDateTime!.year}",),
                              ],
                            ],
                          ),
                        ],
                        const SizedBox(height: 10),
        
                        // >>>> ADD BUTTON =======================================
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14),),),
                            onPressed: () {
                              String? result;
                              if (provider.editingReminder != null) {
                                result = provider.updateReminder(title: titleController.text,);
                              } else {
                                result = provider.addReminder(titleController.text,);
                              }
                              if (result != null) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)),);
                              } else {
                                titleController.clear();
                                afterDaysController.clear();
                              }
                            },
                            child: Text(provider.editingReminder != null ? "Update Reminder" : "Add Reminder",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),),
                          ),
                        ),
        
        
        
        
                      ],
                    ),
                  ),
                ),
              ),
              // <<<< ===================== INPUT CARD (STICKY) ================
            ],
          ),
        ),
      ),
    );
  }
}