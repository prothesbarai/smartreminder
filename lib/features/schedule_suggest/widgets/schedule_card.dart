import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../plan/plan_service.dart';
import '../../reminder_generate/providers/reminder_provider.dart';
import '../models/schedule_hive_model.dart';
import '../services/schedule_reminder_bridge.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleHiveModel schedule;
  const ScheduleCard({super.key, required this.schedule,});

  String formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? "PM" : "AM";
    return "$day/$month/$year • $hour:$minute $period";
  }

  bool isPastSchedule(DateTime dateTime) {
    return dateTime.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final isPaid = PlanService.getPlan() == 'paid';

    final bool isPast = isPastSchedule(schedule.dateTime);
    final bool isAdded = ScheduleReminderBridge.isReminderAdded(schedule);

    BoxDecoration getDecoration() {
      if (isPast) {return BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(25),);}
      if (isAdded) {return BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(25),);}
      return BoxDecoration(gradient: LinearGradient(colors: [Colors.amber.shade300, Colors.orange.shade600],), borderRadius: BorderRadius.circular(25),);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // >>>> ICON
                const Icon(Icons.schedule, size: 28,),
                const SizedBox(width: 12),
                // >>> TITLE + BADGE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(schedule.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isPastSchedule(schedule.dateTime) ? Colors.red : Colors.black,),),
                      const SizedBox(height: 4),
                      Text(formatDateTime(schedule.dateTime), style: TextStyle(fontSize: 13, color: isPastSchedule(schedule.dateTime) ? Colors.red : Colors.black54,),),
                    ],
                  ),
                ),
                if (isPaid) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        // >>>> BLOCK IF PAST TIME
                        if (isPastSchedule(schedule.dateTime)) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Past schedule cannot be added to reminder"),),);
                          return;
                        }
                        final error = ScheduleReminderBridge.toggleReminder(schedule);
                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)),);
                        }
                        // >>> UI refresh
                        (context as Element).markNeedsBuild();
                        context.read<ReminderProvider>().loadReminders();
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: getDecoration(),
                        child: Text(isPast ? "Expired" : (isAdded ? "Cancel" : "Add Reminder"), style: const TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
          // >>>> TRIANGLE BADGE ===============================================
          Positioned(
            top: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5),),
              child: CustomPaint(
                size: Size(35, 35),
                painter: _TriangleBadgePainter(color: isPaid ? Colors.orange : Colors.grey,txt: isPaid ? "PAID" : "FREE", icon: isPaid ? Icons.workspace_premium : Icons.money_off,),
              ),
            ),
          ),
          // <<<< TRIANGLE BADGE ===============================================
        ],
      ),
    );
  }
}


/// >>> Design Rectangle Free / Paid Badges ====================================
class _TriangleBadgePainter extends CustomPainter {

  final Color color;
  final String txt;
  final IconData icon;
  _TriangleBadgePainter({required this.color, required this.txt, required this.icon});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    // >>> Top Left Triangle
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
    // >>> Featured Text
    final textSpan = TextSpan(text: txt, style: TextStyle(color: Colors.white, fontSize: 5, fontWeight: FontWeight.bold,),);
    final iconSpan = TextSpan(text: String.fromCharCode(icon.codePoint), style: TextStyle(fontSize: 8, fontFamily: icon.fontFamily, package: icon.fontPackage, color: Colors.white,),);
    final iconPainter = TextPainter(text: iconSpan, textDirection: TextDirection.ltr,);
    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr,);
    textPainter.layout();
    iconPainter.layout();
    const gapIcon = 5.0;
    const gapTxt = 1.5;

    double approxHypo = (size.width + size.height) / 1.4;
    double offset = (approxHypo / 2) - (textPainter.width / 2);
    double baseX = (approxHypo / 2) - (iconPainter.width / 2);
    // >>> Canvas Transform according to diagonal
    canvas.save();
    canvas.translate(0, size.height);
    canvas.rotate(-45 * 3.1416 / 180);
    // Text Center
    iconPainter.paint(canvas, Offset(baseX, -iconPainter.height - gapIcon / 0.5));
    textPainter.paint(canvas, Offset(offset, -textPainter.height - gapTxt / 0.5));
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
/// <<< Design Rectangle Free / Paid Badges ====================================
