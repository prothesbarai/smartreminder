import 'package:flutter/material.dart';
import 'package:smartreminder/screens/temp_page.dart';
import '../features/ads/ads_manager.dart';
import '../features/ads/banner/adaptive_banner_widget.dart';
import '../features/ads/banner/collapsible_banner_widget.dart';
import '../features/ads/interstitial/interstitial_helper.dart';
import '../features/ads/rewarded/rewarded_ads_helper.dart';
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

            const SizedBox(height: 10,),
            Text("Rewarded  Ad"),
            ElevatedButton(
              onPressed: () async {

                final reward =
                await RewardedAdsHelper.show(
                  rewardAmount: 50,
                );

                if(reward.success){

                  debugPrint("Prothes >>> ${reward.reward}");

                }
              },
              child: const Text("Watch Ad"),
            ),
            const SizedBox(height: 10,),
            Divider(),
          ],
        ),
      )
    );
  }
}
