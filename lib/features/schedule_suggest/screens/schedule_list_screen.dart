import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../plan/plan_helper.dart';
import '../../plan/plan_service.dart';
import '../../plan/user_plan.dart';
import '../providers/schedule_provider.dart';
import '../utils/date_helper.dart';
import '../widgets/schedule_card.dart';

class ScheduleListScreen extends StatefulWidget {
   const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScheduleProvider>(context);

    if (provider.schedules.isEmpty) {
      return const Scaffold(body: Center(child: Column(mainAxisAlignment : MainAxisAlignment.center,children: [Icon(Icons.schedule, size: 70, color: Colors.grey,), SizedBox(height: 10), Text("No schedule yet",style: TextStyle(color: Colors.grey),),],),));
    }

    return ValueListenableBuilder(
      valueListenable: PlanService.planNotifier,
      builder: (context, plan, _) {
        final userPlan = plan == 'free' ? UserPlan.free : UserPlan.paid;
        final limit = getDailyLimit(userPlan);
        final isFree = plan == 'free';
        return Scaffold(
          body: Column(
            children: [
              // >>> PREMIUM HEADER UI =========================================
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(gradient: LinearGradient(colors: isFree ? [Colors.grey.shade800, Colors.grey.shade600] : [Colors.indigo, Colors.purple],), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 6),)],),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // >>> LEFT SIDE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isFree ? "FREE PLAN" : "PREMIUM PLAN", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1,),),
                        const SizedBox(height: 6),
                        Text("Daily Limit: $limit", style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14,),),
                      ],
                    ),
                    // >>>> RIGHT BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6,),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30),),
                      child: Text(isFree ? "BASIC" : "PRO", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
                    ),
                  ],
                ),
              ),
              // <<< PREMIUM HEADER UI =========================================

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.schedules.length,
                  itemBuilder: (context, index) {
                    final item = provider.schedules[index];
                    final currentDate = DateTime(item.date.year, item.date.month, item.date.day,);
                    bool showHeader = false;

                    if (index == 0) {
                      showHeader = true;
                    } else {
                      final previous = provider.schedules[index - 1];
                      final previousDate = DateTime(previous.date.year, previous.date.month, previous.date.day,);
                      showHeader = currentDate != previousDate;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showHeader)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12,),
                            child: Center(child: Text(getDateTitle(item.date), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),),
                          ),
                        ScheduleCard(schedule: item),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );


  }
}