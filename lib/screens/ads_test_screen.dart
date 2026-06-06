import 'package:flutter/material.dart';
import 'package:smartreminder/screens/temp_page.dart';
import '../features/ads/ads_manager.dart';
import '../features/ads/banner/adaptive_banner_widget.dart';
import '../features/ads/banner/collapsible_banner_widget.dart';
import '../features/ads/interstitial/interstitial_helper.dart';
import '../features/ads/rewarded/rewarded_ads_helper.dart';
import '../features/ads/rewarded_interstitial/rewarded_interstitial_helper.dart';
import '../features/ads/models/ads_state.dart';
class AdsTestScreen extends StatefulWidget {
  const AdsTestScreen({super.key});

  @override
  State<AdsTestScreen> createState() => _AdsTestScreenState();
}

class _AdsTestScreenState extends State<AdsTestScreen> {

  void navigatePage(){Navigator.push(context, MaterialPageRoute(builder: (_) => const TempPage(),),);}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (AdsManager.isInitialized)...[
              Text("Ads Ready")
            ],
            Divider(),
            const SizedBox(height: 10,),
            Text("Full Banner ADS"),
            const SizedBox(height: 10,),
            const AdaptiveBannerWidget(),
            Divider(),
            const SizedBox(height: 10,),
            Text("Collapsible Banner"),
            const CollapsibleBannerWidget(),
            const SizedBox(height: 10,),
            Divider(),
            Divider(),
            Divider(),
            Divider(),
            const SizedBox(height: 10,),
            Text("Interstitial Ad"),
            ElevatedButton(
                onPressed: () async {
                  //await InterstitialHelper.showIfEligible(); // >>> Only For Production
                  await InterstitialHelper.show(); // >>> For Testing Purpose
                  if(!mounted) return;
                  navigatePage();
                },
                child: Text("Interstitial Ad")
            ),
            const SizedBox(height: 10,),
            Divider(),

            // >>> For Get Coin From Rewarded ads or RewardedInterstitial ads ==
            ValueListenableBuilder<AdsState>(
              valueListenable: AdsManager.stateNotifier,
              builder: (context, state, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // >>> Rewarded Ad =========================================
                    Text("Rewarded Ad"),
                    ElevatedButton(
                      onPressed: state.rewardedLoaded ? () async {
                        final reward = await RewardedAdsHelper.show(rewardAmount: 50);
                        if (reward.success) {debugPrint("Reward earned: ${reward.reward}");}
                      } : null,
                      child: Text(state.rewardedLoaded ? "Watch Ad (+50)" : "Ad Loading..."),
                    ),
                    // <<< Rewarded Ad =========================================
                    const Divider(),
                    const SizedBox(height: 20),

                    // >>> Rewarded Interstitial Ad ============================
                    Text("Rewarded Interstitial Ad"),
                    ElevatedButton(
                      onPressed: state.rewardedInterstitialLoaded ? () async {
                        final reward = await RewardedInterstitialHelper.show(rewardAmount: 100);
                        if (reward.success) {debugPrint("Reward earned: ${reward.reward}");}
                      } : null,
                      child: Text(state.rewardedInterstitialLoaded ? "Watch Ad (+100)" : "Ad Loading..."),
                    ),
                    // <<< Rewarded Interstitial Ad ============================

                  ],
                );
              },
            ),
            // <<< For Get Coin From Rewarded ads or RewardedInterstitial ads ==
          ],
        ),
      )
    );
  }
}
