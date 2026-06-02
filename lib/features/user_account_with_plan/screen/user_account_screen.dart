import 'package:flutter/material.dart';
import '../plan/plan_service.dart';
import '../service/user_account_service.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  double paidPlanCost = 50.00;

  void _showNoBalanceDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Insufficient Balance"),
        content: const Text("You need 50 coins to activate Paid plan."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"),),
          ElevatedButton(
            onPressed: () {Navigator.pop(context);UserAccountService.addBalance(50);setState(() {});},
            child: const Text("Add Demo Balance"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = UserAccountService.getAccount();
    final isPaidActive = user.plan == 'paid' && user.paidStartDate != null && !PlanService.isSubscriptionExpired(user.paidStartDate!);

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
                    onPressed: () {UserAccountService.addBalance(10);setState(() {});},
                    child: const Text("+ Add"),
                  ),
                ),
              ),
              /// <<<< BALANCE CARD ============================================

              const SizedBox(height: 16),

              /// >>>> PLAN CARD ===============================================
              _glassCard(
                child: ListTile(
                  leading: Icon(Icons.workspace_premium, color: user.plan == 'paid' ? Colors.amber : Colors.grey,),
                  title: const Text("Current Plan", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Row(
                    children: [
                      Text(user.plan.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: user.plan == 'paid' ? Colors.green : Colors.black54,),),
                      const SizedBox(width: 8),
                      if (isPaidActive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20),),
                          child: const Text("ACTIVE", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold,),),
                        ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: isPaidActive ? Colors.grey : const Color(0xFF6A5AE0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),),
                    onPressed: isPaidActive ? null : () {
                      final success = PlanService.trySwitchPlan(paidPlanCost: paidPlanCost,);
                      if (!success) _showNoBalanceDialog();
                      setState(() {});
                    },
                    child: const Text("Upgrade"),
                  ),
                ),
              ),


              const SizedBox(height: 16),

              if (user.plan == 'paid' && user.paidStartDate != null)...[
                _glassCard(
                  child: ListTile(
                    leading: const Icon(Icons.timelapse, color: Colors.orange),
                    title: const Text("Subscription"),
                    subtitle: Text("Remaining Days: ${PlanService.getRemainingDays(user.paidStartDate!)}",),
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