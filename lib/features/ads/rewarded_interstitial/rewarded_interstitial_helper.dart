import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../analytics/ads_analytics.dart';
import '../config/ads_config.dart';
import '../config/ads_ids.dart';
import '../rewarded/reward_result.dart';

class RewardedInterstitialHelper {
  RewardedInterstitialHelper._();

  static RewardedInterstitialAd? _rewardedInterstitialAd;
  static bool _isLoading = false;
  static bool get isReady => _rewardedInterstitialAd != null;

  static Future<void> load() async {
    if (_isLoading) return;
    if (!AdsConfig.rewardedInterstitialEnabled) {return;}
    _isLoading = true;

    await RewardedInterstitialAd.load(
      adUnitId: AdsIds.rewardedInterstitial,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {_rewardedInterstitialAd = ad;_isLoading = false;AdsAnalytics.logLoaded("RewardedInterstitial",);},
        onAdFailedToLoad: (error) {_isLoading = false;AdsAnalytics.logFailed("RewardedInterstitial", error.message,);},
      ),
    );
  }

  static Future<RewardResult> show({required int rewardAmount, String rewardType = "coins",}) async {
    if (_rewardedInterstitialAd == null) {return RewardResult.failed();}
    final completer = Completer<RewardResult>();
    bool earnedReward = false;
    final ad = _rewardedInterstitialAd!;
    ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {ad.dispose(); load();
            if (!completer.isCompleted) {
              completer.complete(earnedReward ? RewardResult(success: true, reward: rewardAmount, rewardType: rewardType,) : RewardResult.failed(),);
            }
          },
          onAdFailedToShowFullScreenContent: (ad, error) {ad.dispose();
            load();
            if (!completer.isCompleted) {completer.complete(RewardResult.failed(),);}
          },
        );
    ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward,) {earnedReward = true;},);
    _rewardedInterstitialAd = null;
    return completer.future;
  }
}