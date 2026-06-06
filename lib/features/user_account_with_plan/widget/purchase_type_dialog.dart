import 'package:flutter/material.dart';


void showPurchaseTypeDialog(BuildContext context, {required VoidCallback onCoinsSelected, required VoidCallback onPremiumSelected,}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (_) => _PurchaseTypeDialog(onCoinsSelected: onCoinsSelected, onPremiumSelected: onPremiumSelected,),
  );
}

class _PurchaseTypeDialog extends StatelessWidget {
  final VoidCallback onCoinsSelected;
  final VoidCallback onPremiumSelected;

  const _PurchaseTypeDialog({required this.onCoinsSelected, required this.onPremiumSelected,});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withValues(alpha: 0.08)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40, spreadRadius: 4,),],),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // >>> Header ======================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [const Color(0xFF6A5AE0).withValues(alpha: 0.3), const Color(0xFFFFC107).withValues(alpha: 0.1),],), borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24),),),
              child: Column(
                children: [
                  // >>> Crown
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA000)], begin: Alignment.topLeft, end: Alignment.bottomRight,), shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFFFFC107).withValues(alpha: 0.4), blurRadius: 16, spreadRadius: 2,),],),
                    child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 30,),
                  ),
                  const SizedBox(height: 14),
                  const Text("Upgrade to Premium", style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 0.5,),),
                  const SizedBox(height: 6),
                  Text("Choose how you'd like to unlock\npremium features", textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 13, height: 1.5,),),
                ],
              ),
            ),
            // <<< Header ======================================================

            // >>> Options =====================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                children: [
                  // >>> Coins Option ==========================================
                  _OptionCard(
                    icon: Icons.monetization_on_rounded,
                    iconColor: const Color(0xFFFFC107),
                    gradientColors: const [Color(0xFFFFF3CD), Color(0xFFFFE082)],
                    title: "Pay with Coins",
                    subtitle: "Use your earned coins to\nunlock premium plans",
                    buttonLabel: "Use Coins",
                    buttonColor: const Color(0xFFFFA000),
                    onTap: () {Navigator.of(context).pop();onCoinsSelected();},
                  ),
                  // <<< Coins Option ==========================================

                  const SizedBox(height: 12),

                  // >>> Premium Subscription Option ===========================
                  _OptionCard(
                    icon: Icons.diamond_rounded,
                    iconColor: const Color(0xFF6A5AE0),
                    gradientColors: const [Color(0xFFEDE7FF), Color(0xFFD1C4E9)],
                    title: "Subscribe Premium",
                    subtitle: "Weekly, Monthly or Yearly\nsubscription plans",
                    buttonLabel: "Subscribe",
                    buttonColor: const Color(0xFF6A5AE0),
                    onTap: () {Navigator.of(context).pop();onPremiumSelected();},
                  ),
                  // <<< Premium Subscription Option ===========================

                ],
              ),
            ),
            // <<< Options =====================================================

            // >>> Cancel ======================================================
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Maybe Later", style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 13,),),),
            const SizedBox(height: 8),
            // <<< Cancel ======================================================

          ],
        ),
      ),
    );
  }
}

// >>> Option Card =============================================================
class _OptionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final List<Color> gradientColors;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final Color buttonColor;
  final VoidCallback onTap;

  const _OptionCard({required this.icon, required this.iconColor, required this.gradientColors, required this.title, required this.subtitle, required this.buttonLabel, required this.buttonColor, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.08)),),
      child: Row(
        children: [
          // >>> Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight,), borderRadius: BorderRadius.circular(14),),
            child: Icon(icon, color: iconColor, size: 26),
          ),

          const SizedBox(width: 14),

          // >>> Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700,),),
                const SizedBox(height: 3),
                Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 11, height: 1.4,),),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // >>> Button
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: buttonColor.withValues(alpha: 0.35), blurRadius: 10, spreadRadius: 1,),],),
              child: Text(buttonLabel, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.3,),),
            ),
          ),

        ],
      ),
    );
  }
}
// <<< Option Card =============================================================
