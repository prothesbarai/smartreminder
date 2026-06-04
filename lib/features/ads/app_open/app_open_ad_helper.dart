import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../analytics/ads_analytics.dart';
import '../config/ads_config.dart';
import '../config/ads_ids.dart';
import '../utils/ad_retry_helper.dart';

class AppOpenAdHelper {
  AppOpenAdHelper._();

  static AppOpenAd? _appOpenAd;
  static bool _isLoading = false;
  static bool _isShowing = false;
  static DateTime? _lastShownTime;
  static bool get isReady => _appOpenAd != null;

  static Future<void> load({bool withRetry = true}) async {
    if (_isLoading) return;
    if (!AdsConfig.appOpenEnabled) return;
    if (withRetry) {
      await AdRetryHelper.retryWithBackoff(adType: 'AppOpen', action: () => _loadOnce(),);
    } else {
      await _loadOnce();
    }
  }

  static Future<void> _loadOnce() async {
    _isLoading = true;
    final completer = Completer<void>();
    await AppOpenAd.load(
      adUnitId: AdsIds.appOpen,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isLoading = false;
          AdsAnalytics.logLoaded('App Open');
          AdsAnalytics.trackPaidEvent(ad);
          completer.complete();
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          AdsAnalytics.logFailed('App Open', error.message);
          completer.completeError(error.message);
        },
      ),
    );
    return completer.future;
  }

  static bool canShow({int cooldownSeconds = 300}) {
    if (_isShowing) return false;
    if (_appOpenAd == null) return false;
    if (_lastShownTime == null) return true;
    return DateTime.now().difference(_lastShownTime!).inSeconds >= cooldownSeconds;
  }

  static Future<bool> show({int cooldownSeconds = 300}) async {
    if (!canShow(cooldownSeconds: cooldownSeconds)) return false;
    try {
      _isShowing = true;
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) => AdsAnalytics.logShown('App Open'),
        onAdDismissedFullScreenContent: (ad) {
          AdsAnalytics.logDismissed('App Open');
          ad.dispose();
          _isShowing = false;
          _appOpenAd = null;
          _lastShownTime = DateTime.now();
          load();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _isShowing = false;
          _appOpenAd = null;
          load();
        },
      );
      _appOpenAd!.show();
      return true;
    } catch (e) {
      debugPrint('AppOpen Error => $e');
      return false;
    }
  }
}
