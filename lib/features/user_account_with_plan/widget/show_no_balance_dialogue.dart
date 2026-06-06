import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../plan/subscription_plan_model.dart';
import '../service/user_account_service.dart';

class ShowNoBalanceDialogue extends StatefulWidget {
  final SubscriptionPlanModel plan;
  final VoidCallback? onBalanceAdded;
  const ShowNoBalanceDialogue({super.key, required this.plan, this.onBalanceAdded,});

  @override
  State<ShowNoBalanceDialogue> createState() => _ShowNoBalanceDialogueState();
}

class _ShowNoBalanceDialogueState extends State<ShowNoBalanceDialogue> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: AppGradients.glass, border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 25, offset: const Offset(0, 12),)],),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // >>> ICON
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppGradients.blue,),
                child: const Icon(Icons.wallet, color: Colors.white, size: 32,),
              ),
              const SizedBox(height: 16),
              const Text("Insufficient Balance", style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 10),

              Text.rich(
                TextSpan(text: "You need ", style: const TextStyle(color: AppColors.textSecondary, fontSize: 14,),
                  children: [
                    TextSpan(text: "${widget.plan.price.toInt()} ", style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold, fontSize: 15,),),
                    const TextSpan(text: "coins for "),
                    TextSpan(text: widget.plan.name, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold,),),
                    const TextSpan(text: " plan"),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // >>> BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14),),),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 36,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(gradient: AppGradients.gold, borderRadius: BorderRadius.circular(14),),
                      child: ElevatedButton(
                        onPressed: () {
                          // >>> Custom or Direct Add Coin =================
                          UserAccountService.addBalance(widget.plan.price);
                          // <<< Custom or Direct Add Coin =================
                          widget.onBalanceAdded?.call();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14),),),
                        child: const Text("Add Coins", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,),),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


