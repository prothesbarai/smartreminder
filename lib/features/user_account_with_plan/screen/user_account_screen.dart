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
        title: const Text("Insufficient Balance"),
        content: const Text("You need 50 coins to activate Paid plan.\nPlease add balance first."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"),),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // optional: auto add balance
              UserAccountService.addBalance(50);
              setState(() {});
            },
            child: const Text("Add Demo Balance"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = UserAccountService.getAccount();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // >>> USER ID
            Text("User ID: ${user.userId}", style: const TextStyle(fontSize: 16),),

            const SizedBox(height: 20),

            // >>> BALANCE CARD
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text("Balance"),
                subtitle: Text("${user.balance} Coins"),
                trailing: ElevatedButton(
                  onPressed: () {setState(() {UserAccountService.addBalance(10);});},
                  child: const Text("+ Add"),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // >>> PLAN CARD
            Card(
              child: ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: const Text("Current Plan"),
                subtitle: Text(user.plan.toUpperCase()),
                trailing: ElevatedButton(
                  onPressed: () {
                    final success = PlanService.trySwitchPlan(paidPlanCost: paidPlanCost,);
                    if (!success) {_showNoBalanceDialog();}
                    setState(() {});
                  },
                  child: const Text("Switch"),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // INFO BOX
            const Text("Account Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            const SizedBox(height: 10),
            Text("• Free users have limited daily usage\n • Paid users get higher limits\n • Balance can be used for future features",),
          ],
        ),
      ),
    );
  }
}