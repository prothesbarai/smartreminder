import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../analytics/ads_analytics.dart';
import '../config/ads_config.dart';
import '../config/ads_ids.dart';
import 'interstitial_frequency_controller.dart';

class InterstitialHelper {
  InterstitialHelper._();

  static InterstitialAd? _interstitialAd;
  static bool _isLoading = false;
  static bool get isReady => _interstitialAd != null;

  static Future<void> load() async {
    if (_isLoading) return;
    if (!AdsConfig.interstitialEnabled) {return;}

    _isLoading = true;

    await InterstitialAd.load(
      adUnitId: AdsIds.interstitial,
      request: const AdRequest(),
      adLoadCallback:
      InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;
          AdsAnalytics.logLoaded("Interstitial",);
          AdsAnalytics.trackPaidEvent(ad,);
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          AdsAnalytics.logFailed("Interstitial", error.message,);
        },
      ),
    );
  }

  static Future<bool> show() async {
    if (_interstitialAd == null) {return false;}

    try {
      final ad = _interstitialAd!;

      ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {AdsAnalytics.logShown("Interstitial",);},
            onAdDismissedFullScreenContent: (ad) {AdsAnalytics.logDismissed("Interstitial",);ad.dispose();load();},
            onAdFailedToShowFullScreenContent: (ad, error) {ad.dispose();load();},
      );
      ad.show();
      _interstitialAd = null;
      InterstitialFrequencyController.markShown();
      return true;
    } catch (e) {
      debugPrint('Interstitial Error => $e',);
      return false;
    }
  }

  /// Show only if allowed
  static Future<bool> showIfEligible({int frequency = 3, int cooldownSeconds = 60,}) async {
    final canShow = InterstitialFrequencyController.canShow(frequency: frequency, cooldownSeconds: cooldownSeconds,);
    if (!canShow) {return false;}
    if (!isReady) {return false;}
    return show();
  }
}