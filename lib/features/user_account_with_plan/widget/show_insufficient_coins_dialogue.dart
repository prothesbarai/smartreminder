import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../plan/subscription_plan_model.dart';
import '../service/user_account_service.dart';


class ShowInsufficientCoinsDialogue extends StatefulWidget {
  final SubscriptionPlanModel plan;
  const ShowInsufficientCoinsDialogue({super.key, required this.plan,});

  @override
  State<ShowInsufficientCoinsDialogue> createState() => _ShowInsufficientCoinsDialogueState();
}

class _ShowInsufficientCoinsDialogueState extends State<ShowInsufficientCoinsDialogue> {
  @override
  Widget build(BuildContext context) {
    final user = UserAccountService.getAccount();
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

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14,),
                      children: [
                        const TextSpan(text: "Your Balance: "),
                        TextSpan(text: "${user.coinBalance} Coins", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w700, fontSize: 16,),),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14,),
                      children: [
                        const TextSpan(text: "Plan Cost: "),
                        TextSpan(text: "${widget.plan.price.toInt()} Coins", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 15,),),
                        const TextSpan(text: " • Need "),
                        TextSpan(text: "${(widget.plan.price.toInt() - user.coinBalance).clamp(0, 999999)} Coins", style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold, fontSize: 15,),),
                        const TextSpan(text: " for "),
                        TextSpan(text: widget.plan.name, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w700,),),
                        const TextSpan(text: " Plan"),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // >>> BUTTONS
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {Navigator.pop(context);},
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14),),),
                  child: const Text("OK"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


