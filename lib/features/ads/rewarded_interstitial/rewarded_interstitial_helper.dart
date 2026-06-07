import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../analytics/ads_analytics.dart';
import '../config/ads_config.dart';
import '../config/ads_ids.dart';
import '../models/ads_state_notifier.dart';
import '../utils/ad_retry_helper.dart';
import '../rewarded/reward_result.dart';

class RewardedInterstitialHelper {
  RewardedInterstitialHelper._();

  static RewardedInterstitialAd? _rewardedInterstitialAd;
  static bool _isLoading = false;
  static bool get isReady => _rewardedInterstitialAd != null;

  static Future<void> load({bool withRetry = true}) async {
    if (_isLoading) return;
    if (!AdsConfig.rewardedInterstitialEnabled) return;
    if (withRetry) {await AdRetryHelper.retryWithBackoff(adType: 'RewardedInterstitial', action: () => _loadOnce(),);} else {
      await _loadOnce();
    }
  }

  static Future<void> _loadOnce() async {
    _isLoading = true;
    final completer = Completer<void>();
    await RewardedInterstitialAd.load(
      adUnitId: AdsIds.rewardedInterstitial,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedInterstitialAd = ad;
          _isLoading = false;
          AdsAnalytics.logLoaded('RewardedInterstitial');
          AdsStateNotifier.update(rewardedInterstitialLoaded: true); // loaded
          completer.complete();
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          AdsAnalytics.logFailed('RewardedInterstitial', error.message);
          AdsStateNotifier.update(rewardedInterstitialLoaded: false); // failed
          completer.completeError(error.message);
        },
      ),
    );

    return completer.future;
  }

  static Future<RewardResult> show({required double rewardAmount, String rewardType = 'coins'}) async {
    if (_rewardedInterstitialAd == null) return RewardResult.failed();
    final completer = Completer<RewardResult>();
    bool earnedReward = false;
    final ad = _rewardedInterstitialAd!;
    _rewardedInterstitialAd = null;
    AdsStateNotifier.update(rewardedInterstitialLoaded: false); // show

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        load();
        if (!completer.isCompleted) {completer.complete(earnedReward ? RewardResult(success: true, reward: rewardAmount, rewardType: rewardType) : RewardResult.failed(),);}
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        load();
        if (!completer.isCompleted) completer.complete(RewardResult.failed());
      },
    );

    ad.show(onUserEarnedReward: (_, __) => earnedReward = true);
    return completer.future;
  }
}
