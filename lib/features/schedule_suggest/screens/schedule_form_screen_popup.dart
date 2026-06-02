import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../plan/plan_helper.dart';
import '../../plan/plan_service.dart';
import '../../plan/user_plan.dart';
import '../providers/schedule_provider.dart';
import '../widgets/schedule_input_section.dart';

class ScheduleFormScreenPopup extends StatefulWidget {
  const ScheduleFormScreenPopup({super.key});

  @override
  State<ScheduleFormScreenPopup> createState() => _ScheduleFormScreenPopupState();
}

class _ScheduleFormScreenPopupState extends State<ScheduleFormScreenPopup> {

  final studyController = TextEditingController();
  TimeOfDay? wakeUpTime;
  TimeOfDay? sleepTime;
  DateTime? selectedDate;

  // >>>> Time And Date Formating Functions ====================================
  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
  // <<<< Time And Date Formating Functions ====================================

  // >>> Pick WakeUp Time ======================================================
  Future<void> pickWakeUpTime() async {
    // >>> DATE CHECK FIRST ====================================================
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select date first"),),);
      return;
    }
    // <<< DATE CHECK FIRST ====================================================
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now(),);
    if (picked != null) {
      // >>> Only validate for today
      if (selectedDate != null) {
        final today = DateTime.now();
        final isToday = selectedDate!.year == today.year && selectedDate!.month == today.month && selectedDate!.day == today.day;
        if (isToday) {
          final now = TimeOfDay.now();
          final pickedMinutes = picked.hour * 60 + picked.minute;
          final nowMinutes = now.hour * 60 + now.minute;
          if (pickedMinutes < nowMinutes) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Past time cannot be selected.",),),);
            return;
          }
        }
      }
      setState(() => wakeUpTime = picked);
    }
  }
  // <<< Pick WakeUp Time ======================================================

  // >>>> Pick Sleep Time ======================================================
  Future<void> pickSleepTime() async {
    // >>> DATE CHECK FIRST ====================================================
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select date first"),),);
      return;
    }
    // <<< DATE CHECK FIRST ====================================================
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now(),);
    if (picked != null) {
      // >>> Only validate for today
      if (selectedDate != null) {
        final today = DateTime.now();
        final isToday = selectedDate!.year == today.year && selectedDate!.month == today.month && selectedDate!.day == today.day;
        if (isToday) {
          final now = TimeOfDay.now();
          final pickedMinutes = picked.hour * 60 + picked.minute;
          final nowMinutes = now.hour * 60 + now.minute;
          if (pickedMinutes < nowMinutes) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Past time cannot be selected.",),),);
            return;
          }
        }
      }
      setState(() => sleepTime = picked);
    }
  }
  // <<<< Pick Sleep Time ======================================================

  // >>> Picked Date ===========================================================
  Future<void> pickDate() async {
    final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100),);
    if (picked != null) {
      setState(() {selectedDate = picked;});
    }
  }
  // <<< Picked Date ===========================================================


  @override
  void dispose() {
    studyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScheduleProvider>(context);
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScheduleInputSection(
            selectedDateText: selectedDate == null ? '' : formatDate(selectedDate!),
            wakeUpText: wakeUpTime == null ? '' : formatTime(wakeUpTime!),
            sleepText: sleepTime == null ? '' : formatTime(sleepTime!),
            studyController: studyController,
            onDateTap: pickDate,
            onWakeUpTap: pickWakeUpTime,
            onSleepTap: pickSleepTime,
            onGenerate: () {
              if (selectedDate == null || wakeUpTime == null || sleepTime == null || studyController.text.isEmpty) {return;}
              final plan = PlanService.getPlan();

              // >>> FREE PLAN DATE RESTRICTION ================================
              final isFree = plan == 'free';
              if (isFree) {
                final today = DateTime.now();
                final todayOnly = DateTime(today.year, today.month, today.day);
                final selectedOnly = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day,);
                if (selectedOnly != todayOnly) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Free plan allows only today's schedule. Upgrade to select other dates.",),),);
                  return;
                }
              }
              // <<< FREE PLAN DATE RESTRICTION ================================


              // >>> DATE WISE PLAN LIMIT CHECK ================================
              final userPlan = plan == 'free' ? UserPlan.free : UserPlan.paid;
              final limit = getDailyLimit(userPlan);
              if (!PlanService.canGenerateForDate(selectedDate!, limit,)) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Limit reached for this date ($limit)",),),);
                return;
              }
              // <<< DATE WISE PLAN LIMIT CHECK ================================


              // >>> SAME DATE ALREADY EXISTS CHECK ============================
              if (provider.hasScheduleForDate(selectedDate!)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Schedule already exists for this date.",),),);
                return;
              }
              // <<< SAME DATE ALREADY EXISTS CHECK ============================


              final today = DateTime.now();
              final todayOnly = DateTime(today.year, today.month, today.day,);
              final selectedOnly = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day,);

              // >>> Old date block
              if (selectedOnly.isBefore(todayOnly)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Old date schedule cannot be created."),),);
                return;
              }

              // >>> If today date is past wake-up time block
              if (selectedOnly == todayOnly) {
                final now = TimeOfDay.now();
                final wakeMinutes = wakeUpTime!.hour * 60 + wakeUpTime!.minute;
                final nowMinutes = now.hour * 60 + now.minute;
                if (wakeMinutes < nowMinutes) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("For today's schedule, wake up time cannot be in the past.",),),);
                  return;
                }
              }
              final hours = int.tryParse(studyController.text) ?? 0;

              if (hours <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter valid study hours."),),);
                return;
              }

              provider.generateAndSaveSchedule(selectedDate: selectedDate!, wakeUpTime: wakeUpTime!, studyHours: hours, sleepTime: sleepTime!, context: context,);
              // >>> SAVE GENERATION COUNT =====================================
              PlanService.increaseUsageForDate(selectedDate!,);
              // <<< SAVE GENERATION COUNT =====================================
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
