import 'package:flutter/material.dart';
import 'package:smartreminder/features/user_account_with_plan/widget/show_no_balance_dialogue.dart';
import '../../../core/utils/app_colors.dart';
import '../plan/plan_service.dart';
import '../plan/subscription_plans.dart';

class BottomSheetPlanner extends StatefulWidget {
  final VoidCallback? onUpdate;
  const BottomSheetPlanner({super.key,this.onUpdate,});

  @override
  State<BottomSheetPlanner> createState() => _BottomSheetPlannerState();
}

class _BottomSheetPlannerState extends State<BottomSheetPlanner> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * .78,
        decoration: const BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.vertical(top: Radius.circular(28),),),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // >>> Drag handle
            Container(width: 55, height: 5, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(20),),),
            const SizedBox(height: 18),
            const Text("Choose Your Plan", style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold,),),
            const SizedBox(height: 6),
            const Text("Unlock premium features instantly", style: TextStyle(color: AppColors.textSecondary, fontSize: 13,),),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10,),
                itemCount: SubscriptionPlans.all.length,
                itemBuilder: (context, index) {
                  final plan = SubscriptionPlans.all[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: AppGradients.glass, border: Border.all(color: AppColors.border,), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 18, offset: const Offset(0, 10),),],),
                    child: Row(
                      children: [
                        // >>> ICON ============================================
                        Container(
                          height: 52,
                          width: 52,
                          decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppGradients.gold,),
                          child: const Icon(Icons.workspace_premium, color: Colors.white,),
                        ),
                        // <<< ICON ============================================

                        const SizedBox(width: 12),

                        // >>>> TEXT AREA ======================================
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // >>>>  TITLE + BADGE ===========================
                              Row(
                                children: [
                                  Expanded(child: Text(plan.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold,),),),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3,),
                                    decoration: BoxDecoration(color: AppColors.gold1.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20),),
                                    child: const Text("HOT", style: TextStyle(color: AppColors.gold1, fontSize: 10, fontWeight: FontWeight.bold,),),
                                  ),
                                ],
                              ),
                              // <<<<  TITLE + BADGE ===========================

                              const SizedBox(height: 6),
                              Text("${plan.days} Days Access", style: const TextStyle(color: AppColors.textSecondary, fontSize: 13,),),
                              const SizedBox(height: 4),

                              Row(
                                children: [
                                  const Icon(Icons.monetization_on, size: 16, color: AppColors.gold1,),
                                  const SizedBox(width: 4),
                                  Expanded(child: Text("${plan.price} Coins", overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600,),)),
                                ],
                              ),


                            ],
                          ),
                        ),
                        // <<<< TEXT AREA ======================================

                        const SizedBox(width: 10),

                        // >>> BUTTON (GRADIENT SYSTEM) ========================
                        SizedBox(
                          height: 38,
                          child: ElevatedButton(
                            onPressed: () {
                              final success = PlanService.buyPlan(plan: plan);
                              Navigator.pop(context);
                              if (!success) {
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.black.withValues(alpha: 0.7),
                                  builder: (_) => ShowNoBalanceDialogue(plan: plan, onBalanceAdded: () {setState(() {});},),
                                );
                              }else {
                                widget.onUpdate?.call();
                              }
                            },
                            style: ElevatedButton.styleFrom(elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 14,), backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                            child: Ink(
                              decoration: BoxDecoration(gradient: AppGradients.gold, borderRadius: BorderRadius.circular(30),),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 14,),
                                child: const Text("BUY", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1,),),
                              ),
                            ),
                          ),
                        ),
                        // <<< BUTTON (GRADIENT SYSTEM) ========================
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

