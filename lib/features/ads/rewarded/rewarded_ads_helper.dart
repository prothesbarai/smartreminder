import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../analytics/ads_analytics.dart';
import '../config/ads_config.dart';
import '../config/ads_ids.dart';
import '../models/ads_state_notifier.dart';
import '../utils/ad_retry_helper.dart';
import 'reward_result.dart';

class RewardedAdsHelper {
  RewardedAdsHelper._();

  static RewardedAd? _rewardedAd;
  static bool _isLoading = false;
  static bool get isReady => _rewardedAd != null;

  static Future<void> load({bool withRetry = true}) async {
    if (_isLoading) return;
    if (!AdsConfig.rewardedEnabled) return;
    if (withRetry) {await AdRetryHelper.retryWithBackoff(adType: 'Rewarded', action: () => _loadOnce(),);} else {
      await _loadOnce();
    }
  }

  static Future<void> _loadOnce() async {
    _isLoading = true;
    final completer = Completer<void>();
    await RewardedAd.load(
      adUnitId: AdsIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
          AdsAnalytics.logLoaded('Rewarded');
          AdsAnalytics.trackPaidEvent(ad);
          AdsStateNotifier.update(rewardedLoaded: true); //  loaded
          completer.complete();
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          AdsAnalytics.logFailed('Rewarded', error.message);
          AdsStateNotifier.update(rewardedLoaded: false); //  failed
          completer.completeError(error.message);
        },
      ),
    );
    return completer.future;
  }

  static Future<RewardResult> show({required int rewardAmount, String rewardType = 'coins'}) async {
    if (_rewardedAd == null) return RewardResult.failed();

    final completer = Completer<RewardResult>();
    bool earnedReward = false;
    final ad = _rewardedAd!;
    _rewardedAd = null;
    AdsStateNotifier.update(rewardedLoaded: false); // show

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => AdsAnalytics.logShown('Rewarded'),
      onAdDismissedFullScreenContent: (ad) {
        AdsAnalytics.logDismissed('Rewarded');
        ad.dispose();
        load(); // >>> dismiss after new load — After load, the state will be true again
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
