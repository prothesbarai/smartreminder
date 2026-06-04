import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../analytics/ads_analytics.dart';
import '../config/ads_config.dart';
import '../config/ads_ids.dart';
import '../models/ads_state_notifier.dart';
import '../utils/ad_retry_helper.dart';
import 'interstitial_frequency_controller.dart';

class InterstitialHelper {
  InterstitialHelper._();

  static InterstitialAd? _interstitialAd;
  static bool _isLoading = false;
  static bool get isReady => _interstitialAd != null;

  static Future<void> load({bool withRetry = true}) async {
    if (_isLoading) return;
    if (!AdsConfig.interstitialEnabled) return;
    if (withRetry) {
      await AdRetryHelper.retryWithBackoff(adType: 'Interstitial', action: () => _loadOnce(),);
    } else {
      await _loadOnce();
    }
  }

  static Future<void> _loadOnce() async {
    _isLoading = true;
    final completer = Completer<void>();
    await InterstitialAd.load(
      adUnitId: AdsIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;
          AdsAnalytics.logLoaded('Interstitial');
          AdsAnalytics.trackPaidEvent(ad);
          AdsStateNotifier.update(interstitialLoaded: true); // loaded
          completer.complete();
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          AdsAnalytics.logFailed('Interstitial', error.message);
          AdsStateNotifier.update(interstitialLoaded: false); //  failed
          completer.completeError(error.message);
        },
      ),
    );
    return completer.future;
  }

  static Future<bool> show() async {
    if (_interstitialAd == null) return false;

    try {
      final ad = _interstitialAd!;
      _interstitialAd = null;
      AdsStateNotifier.update(interstitialLoaded: false); // ← show

      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) => AdsAnalytics.logShown('Interstitial'),
        onAdDismissedFullScreenContent: (ad) {
          AdsAnalytics.logDismissed('Interstitial');
          ad.dispose();
          load(); // >>> dismiss after new load — After load, the state will be true again
        },
        onAdFailedToShowFullScreenContent: (ad, error) {ad.dispose();load();},
      );
      ad.show();
      InterstitialFrequencyController.markShown();
      return true;
    } catch (e) {
      debugPrint('Interstitial Error => $e');
      return false;
    }
  }

  static Future<bool> showIfEligible({int frequency = 3, int cooldownSeconds = 60}) async {
    final canShow = InterstitialFrequencyController.canShow(frequency: frequency, cooldownSeconds: cooldownSeconds,);
    if (!canShow) return false;
    if (!isReady) return false;
    return show();
  }
}
