import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../analytics/ads_analytics.dart';
import '../config/ads_ids.dart';

class BannerAdHelper {
  BannerAdHelper._();

  static Future<BannerAd?> createAdaptiveBanner(BuildContext context,) async {
    final width = MediaQuery.of(context).size.width.toInt();
    final adSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width,);
    if (adSize == null) {return null;}
    final ad = BannerAd(
      adUnitId: AdsIds.banner,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {AdsAnalytics.logLoaded("Adaptive Banner",);},
        onAdFailedToLoad: (ad, error,) {AdsAnalytics.logFailed("Adaptive Banner", error.message,);ad.dispose();},
      ),
    );

    await ad.load();

    return ad;
  }
}