import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../plan/plan_service.dart';
import '../plan/subscription_plan_model.dart';
import '../plan/subscription_plans.dart';
import '../service/user_account_service.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  double paidPlanCost = 50.00;

  // >>> Plan Text Color Helper ================================================
  Color getPlanColor(String planId) {
    switch (planId) {
      case "basic":
        return Colors.blue;
      case "standard":
        return Colors.green;
      case "premium":
        return Colors.orange;
      case "gold":
        return Colors.amber;
      case "diamond":
        return Colors.cyan;
      default:
        return Colors.deepPurple;
    }
  }
  // <<< Plan Text Color Helper ================================================

  // >>>> Show Popup When Buy & insufficient Balance ===========================
  void _showNoBalanceDialog(SubscriptionPlanModel plan) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) {
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
                        TextSpan(text: "${plan.price.toInt()} ", style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold, fontSize: 15,),),
                        const TextSpan(text: "coins for "),
                        TextSpan(text: plan.name, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold,),),
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
                              Navigator.pop(context);
                              // >>> Custom or Direct Add Coin =================
                              UserAccountService.addBalance(plan.price);
                              // <<< Custom or Direct Add Coin =================
                              setState(() {});
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
      },
    );
  }
  // <<<< Show Popup When Buy & insufficient Balance ===========================

  // >>> Bottom Sheet Subscription Plan List ===================================
  void _showPlanSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
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
                            // >>> ICON
                            Container(
                              height: 52,
                              width: 52,
                              decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppGradients.gold,),
                              child: const Icon(Icons.workspace_premium, color: Colors.white,),
                            ),
                            const SizedBox(width: 12),
                            // >>>> TEXT AREA
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // >>>>  TITLE + BADGE
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

                            const SizedBox(width: 10),

                            // BUTTON (GRADIENT SYSTEM)
                            SizedBox(
                              height: 38,
                              child: ElevatedButton(
                                onPressed: () {
                                  final success =
                                  PlanService.buyPlan(plan: plan);

                                  Navigator.pop(context);

                                  if (!success) {
                                    _showNoBalanceDialog(plan);
                                  }

                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: AppGradients.gold,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: const Text(
                                      "BUY",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
      },
    );
  }
  // <<< Bottom Sheet Subscription Plan List ===================================

  @override
  Widget build(BuildContext context) {
    final user = UserAccountService.getAccount();
    final activePlanId = user.activePlanId;
    final isPlanActive = activePlanId != null && PlanService.isPlanActive(user, activePlanId);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// >>> HEADER ===================================================
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xFF6A5AE0), Color(0xFF8F7CFF)], begin: Alignment.topLeft, end: Alignment.bottomRight,),),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 26, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.deepPurple),),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("User ID: ${user.userId}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600,),),
                          const SizedBox(height: 4),
                          Text("Manage your account", style: TextStyle(color: Colors.white.withValues(alpha: 0.8),),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /// <<< HEADER ===================================================

              const SizedBox(height: 20),

              /// >>>> BALANCE CARD ============================================
              _glassCard(
                child: ListTile(
                  leading: const Icon(Icons.account_balance_wallet, color: Colors.deepPurple),
                  title: const Text("Balance", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text("${user.balance} Coins"),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A5AE0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),),
                    onPressed: () {
                      // >>> Custom or Direct Add Coin =========================
                      UserAccountService.addBalance(10);
                      // <<< Custom or Direct Add Coin =========================
                      setState(() {});
                    },
                    child: const Text("+ Add"),
                  ),
                ),
              ),
              /// <<<< BALANCE CARD ============================================

              const SizedBox(height: 16),

              /// >>>> PLAN CARD ===============================================
              _glassCard(
                child: ListTile(
                  leading: Icon(Icons.workspace_premium, color: activePlanId != null ? Colors.amber : Colors.grey,),
                  title: const Text("Current Plan", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Row(
                    children: [
                      Expanded(child: Text(activePlanId?.toUpperCase() ?? "FREE", overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isPlanActive ? Colors.green : Colors.black54,),),),
                      if (isPlanActive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2,),
                          decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20),),
                          child: const Text("ACTIVE", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold,),),
                        ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: isPlanActive ? Colors.grey : const Color(0xFF6A5AE0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),),
                    onPressed: isPlanActive ? null : _showPlanSelector,
                    child: const Text("Upgrade"),
                  ),
                ),
              ),


              const SizedBox(height: 16),

              if (activePlanId != null && user.subscriptionStartDate != null && user.subscriptionDays != null)...[
                _glassCard(
                  child: ListTile(
                    leading: const Icon(Icons.timelapse, color: Colors.orange),
                    title: const Text("Subscription"),
                    subtitle: Text("Remaining Days: ${PlanService.getRemainingDays(user.subscriptionStartDate!, user.subscriptionDays!,)}",),
                  ),
                ),
              ],
              /// <<<< PLAN CARD ===============================================

              const SizedBox(height: 24),

              /// >>> INFO SECTION =============================================
              const Text("Account Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 10),
              _glassCard(
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("• Free users have limited daily usage\n• Paid users get premium access\n• Balance will be used for future features", style: TextStyle(height: 1.5),),
                ),
              ),
              /// <<< INFO SECTION =============================================
            ],
          ),
        ),
      ),
    );
  }

  /// >>>> Reusable PREMIUM CARD ===============================================
  Widget _glassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10),)],),
      child: child,
    );
  }
  /// <<<< Reusable PREMIUM CARD ===============================================
}