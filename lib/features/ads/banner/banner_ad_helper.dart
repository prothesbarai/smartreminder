import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../analytics/ads_analytics.dart';
import '../config/ads_ids.dart';

class BannerAdHelper {
  BannerAdHelper._();

  static Future<BannerAd?> createAdaptiveBanner(
      BuildContext context, {int maxRetries = 3, int initialDelaySeconds = 2,}) async {
    final width = MediaQuery.of(context).size.width.toInt();
    final adSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (adSize == null) return null;
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      final result = await _tryLoadBanner(adSize);
      if (result != null) return result;
      final isLastAttempt = attempt == maxRetries;
      if (!isLastAttempt) {
        final delay = initialDelaySeconds * attempt; // 2s, 4s, 6s
        debugPrint('[Banner] Attempt $attempt failed. Retrying in ${delay}s...');
        await Future.delayed(Duration(seconds: delay));
      }
    }
    debugPrint('[Banner] All $maxRetries attempts failed.');
    return null;
  }

  static Future<BannerAd?> _tryLoadBanner(AdSize adSize) async {
    final completer = Completer<BannerAd?>();

    final ad = BannerAd(
      adUnitId: AdsIds.banner,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (loadedAd) {AdsAnalytics.logLoaded('Adaptive Banner');completer.complete(loadedAd as BannerAd);},
        onAdFailedToLoad: (failedAd, error) {
          AdsAnalytics.logFailed('Adaptive Banner', error.message);
          failedAd.dispose();
          completer.complete(null); // null means retry
        },
      ),
    );

    await ad.load();
    return completer.future;
  }
}
