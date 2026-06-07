import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/utils/app_colors.dart';
import '../../ads/ads_manager.dart';
import '../../ads/config/ads_config.dart';
import '../../ads/models/ads_state.dart';
import '../../ads/rewarded/rewarded_ads_helper.dart';
import '../service/user_account_service.dart';
import 'bottom_sheet_planner.dart';

void showAddCoinsTypeDialog(BuildContext context, {VoidCallback? onUpdate,}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    builder: (_) => _AddCoinsTypeDialog(onUpdate: onUpdate),
  );
}

class _AddCoinsTypeDialog extends StatelessWidget {
  final VoidCallback? onUpdate;
  const _AddCoinsTypeDialog({this.onUpdate});

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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40, spreadRadius: 4),],),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // >>> Header ======================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.gold1.withValues(alpha: 0.2), AppColors.gold2.withValues(alpha: 0.08),],), borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),),
              child: Column(
                children: [
                  // >>> Coin icon
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(gradient: AppGradients.gold, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.gold1.withValues(alpha: 0.4), blurRadius: 16, spreadRadius: 2)],),
                    child: const Icon(Icons.monetization_on_rounded, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 14),
                  const Text("Add Coins", style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 0.5),),
                  const SizedBox(height: 6),
                  // Current balance
                  ValueListenableBuilder<AdsState>(
                    valueListenable: AdsManager.stateNotifier,
                    builder: (context, _, __) {
                      final user = UserAccountService.getAccount();
                      return Text("Current Balance: ${user.coinBalance} Coins", style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.7), fontSize: 13),);
                    },
                  ),
                ],
              ),
            ),
            // <<< Header ======================================================

            // >>> Options =====================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: ValueListenableBuilder<AdsState>(
                valueListenable: AdsManager.stateNotifier,
                builder: (context, state, _) {
                  return Column(
                    children: [

                      // >>> Buy Plans Option ==================================
                      _OptionCard(
                        icon: const FaIcon(FontAwesomeIcons.coins, color: Colors.white, size: 26,),
                        iconGradient: AppGradients.gold,
                        iconGlowColor: AppColors.gold1,
                        title: "Buy Coins",
                        subtitle: "Purchase coins",
                        buttonLabel: "Buy Now",
                        buttonGradient: AppGradients.gold,
                        buttonGlowColor: AppColors.gold1,
                        isEnabled: true,
                        onTap: (){

                        },
                      ),
                      // <<< Buy Plans Option ==================================

                      const SizedBox(height: 12),

                      // >>> Watch Rewarded Ad Option ==========================
                      _OptionCard(
                        icon: const FaIcon(FontAwesomeIcons.video, color: Colors.white, size: 26,),
                        iconGradient: AppGradients.gold,
                        iconGlowColor: AppColors.gold1,
                        title: "Watch Ad",
                        subtitle: "Earn coins free",
                        buttonLabel: state.rewardedLoaded ? "Watch Ads" : "Loading...",
                        buttonGradient: AppGradients.gold,
                        buttonGlowColor: AppColors.gold1,
                        isEnabled: state.rewardedLoaded,
                        onTap: state.rewardedLoaded ? () async {
                          Navigator.of(context).pop();
                          final random = Random();
                          final multiplier = AdsConfig.rewardMultipliers[random.nextInt(AdsConfig.rewardMultipliers.length)];
                          final rewardCoins = (AdsConfig.baseReward * multiplier);

                          final reward = await RewardedAdsHelper.show(rewardAmount: rewardCoins);
                          if (reward.success) {
                            UserAccountService.addBalance(reward.reward.toDouble());
                            onUpdate?.call();
                          }
                        }: null,
                      ),
                      // <<< Watch Rewarded Ad Option ==========================

                    ],
                  );
                },
              ),
            ),
            // <<< Options =====================================================

            // >>> Cancel ======================================================
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Maybe Later", style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.35), fontSize: 13),),
            ),
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
  final Widget icon;
  final LinearGradient iconGradient;
  final Color iconGlowColor;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final LinearGradient buttonGradient;
  final Color buttonGlowColor;
  final bool isEnabled;
  final VoidCallback? onTap;

  const _OptionCard({required this.icon, required this.iconGradient, required this.iconGlowColor, required this.title, required this.subtitle, required this.buttonLabel, required this.buttonGradient, required this.buttonGlowColor, required this.isEnabled, this.onTap,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border),),
      child: Row(
        children: [
          // >>> Icon
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(gradient: iconGradient, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: iconGlowColor.withValues(alpha: 0.3), blurRadius: 10, spreadRadius: 1)],),
            child: Center(child: icon,),
          ),

          const SizedBox(width: 14),

          // >>> Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(subtitle, style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5), fontSize: 11, height: 1.4)),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // >>> Button
          GestureDetector(
            onTap: onTap,
            child: AnimatedOpacity(
              opacity: isEnabled ? 1.0 : 0.45,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(gradient: isEnabled ? buttonGradient : const LinearGradient(colors: [Colors.grey, Colors.grey]), borderRadius: BorderRadius.circular(20), boxShadow: isEnabled ? [BoxShadow(color: buttonGlowColor.withValues(alpha: 0.35), blurRadius: 10, spreadRadius: 1)] : [],),
                child: Text(buttonLabel, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.3),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// <<< Option Card =============================================================