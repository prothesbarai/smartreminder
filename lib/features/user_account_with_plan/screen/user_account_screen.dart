import 'package:flutter/material.dart';
import '../models/user_account_hive_model.dart';
import '../plan/plan_service.dart';
import '../service/user_account_service.dart';
import '../widget/bottom_sheet_planner.dart';
import '../widget/premium_screen.dart';
import '../widget/upgrade_plan_type_dialog.dart';
import '../widget/add_coins_type_dialog.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {

  // >>> Bottom Sheet Subscription Plan List ===================================
  void showBottomSheetPlanner(BuildContext context, {VoidCallback? onUpdate,}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BottomSheetPlanner(onUpdate: onUpdate,),
    );
  }
  // <<< Bottom Sheet Subscription Plan List ===================================

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child:ValueListenableBuilder<UserAccountHiveModel>(
          valueListenable: UserAccountService.notifier,
          builder: (context, user, _) {
            final activePlanId = user.activePlanId;
            final isPlanActive = activePlanId != null && PlanService.isPlanActive(user, activePlanId);
            return SingleChildScrollView(
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
                      subtitle: Text("${user.coinBalance} Coins"),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A5AE0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),),
                        onPressed: () {
                          showAddCoinsTypeDialog(context, onUpdate: () => setState(() {}),);
                        },
                        child: const Text("+ Add Coins"),
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
                        onPressed: isPlanActive ? null : () {
                          showUpgradePlanTypeDialog(
                            context,
                            onCoinsSelected: () => showBottomSheetPlanner(context, onUpdate: () => setState(() {})),
                            onPremiumSelected: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: false,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const PremiumScreen(),
                            ),
                          );
                        },
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
            );
          },
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