import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../analytics/ads_analytics.dart';
import '../config/ads_config.dart';
import '../config/ads_ids.dart';
import 'reward_result.dart';

class RewardedAdsHelper {
  RewardedAdsHelper._();

  static RewardedAd? _rewardedAd;
  static bool _isLoading = false;
  static bool get isReady => _rewardedAd != null;

  static Future<void> load() async {
    if (_isLoading) return;
    if (!AdsConfig.rewardedEnabled) {return;}

    _isLoading = true;

    await RewardedAd.load(
      adUnitId: AdsIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {_rewardedAd = ad;_isLoading = false;AdsAnalytics.logLoaded("Rewarded",);AdsAnalytics.trackPaidEvent(ad,);},
        onAdFailedToLoad: (error) {_isLoading = false;AdsAnalytics.logFailed("Rewarded", error.message,);},
      ),
    );
  }

  static Future<RewardResult> show({required int rewardAmount, String rewardType = "coins",}) async {
    if (_rewardedAd == null) {return RewardResult.failed();}
    final completer = Completer<RewardResult>();
    bool earnedReward = false;
    final ad = _rewardedAd!;
    ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (ad) {AdsAnalytics.logShown("Rewarded",);},
          onAdDismissedFullScreenContent: (ad) {AdsAnalytics.logDismissed("Rewarded",);
            ad.dispose();
            load();
            if (!completer.isCompleted) {
              completer.complete(earnedReward ? RewardResult(success: true, reward: rewardAmount, rewardType: rewardType,) : RewardResult.failed(),);
            }
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            load();
            if (!completer.isCompleted) {completer.complete(RewardResult.failed(),);}
          },
    );
    ad.show(onUserEarnedReward: (AdWithoutView  ad, RewardItem reward,) {earnedReward = true;},);
    _rewardedAd = null;
    return completer.future;
  }
}