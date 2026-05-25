import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';
import '../widgets/reminder_form_popup.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ReminderProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF6F7FB),

      body: RefreshIndicator(
        onRefresh: () async {
          provider.loadReminders();
          if (provider.remindersHive.isEmpty) {provider.clearForm();}
          await Future.delayed(const Duration(milliseconds: 500),);
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Container(
            child: provider.remindersHive.isEmpty ?
            Center(
              child: Column(
                children: const [
                  SizedBox(height: 50),
                  Center(child: Column(children: [Icon(Icons.notifications_none_rounded, size: 50, color: Colors.grey,), SizedBox(height: 10), Text("No reminders yet"),],),),
                ],
              ),
            ):
            ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(12),
              itemCount: provider.remindersHive.length,
              itemBuilder: (context, index) {
                final item = provider.remindersHive[index];
                final bool isCompleted = DateTime.now().isAfter(item.scheduledTime);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 6),),],),
                  child: ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -3),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2,),
                    minLeadingWidth: 10,
                    leading: const Center(widthFactor: 1, child: Icon(Icons.alarm, color: Color(0xFF6C63FF), size: 22,),),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14,),),
                        const SizedBox(height: 4),
                        Text(item.time, style: TextStyle(fontSize: 12, color: Colors.grey.shade600,),),

                        const SizedBox(height: 6),

                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4,),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF00B894), Color(0xFF00CEC9),],),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [BoxShadow(color: const Color(0xFF00B894).withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 4),),],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, color: Colors.white, size: 12,),
                                SizedBox(width: 4),
                                Text("Completed", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.3,),),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4,),
                            decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(30),),
                            child: const Text("Pending", style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.w700,),),
                          ),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.edit, color: Colors.blue, size: 20,),
                          onPressed: () {
                            /*titleController.text = item.title;
                                    afterDaysController.text = item.afterDays?.toString() ?? '';*/
                            provider.startEdit(item, index);
                            ReminderFormPopup.show(context, isEdit: true);
                          },
                        ),

                        SizedBox(width: 12),

                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20,),
                          onPressed: () {provider.deleteReminder(index);},
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}