import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardsAdsModule {
  static RewardedAd? _rewardedAd;

  static bool get isReady => _rewardedAd != null;

  static Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: "ca-app-pub-3940256099942544/5224354917",
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {_rewardedAd = ad;},
        onAdFailedToLoad: (error) {debugPrint(error.toString());},
      ),
    );
  }

  static Future<void> showRewardedAd({required int rewardAmount, required Function(int reward) onRewardEarned,}) async {
    if (_rewardedAd == null) {return;}
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {ad.dispose();loadRewardedAd();}, onAdFailedToShowFullScreenContent: (ad, error) {ad.dispose();loadRewardedAd();},);
    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {onRewardEarned(rewardAmount);},);
    _rewardedAd = null;
  }

}