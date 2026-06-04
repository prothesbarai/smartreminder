import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app_open/app_open_ad_helper.dart';
import 'config/ads_config.dart';
import 'interstitial/interstitial_helper.dart';
import 'rewarded/rewarded_ads_helper.dart';
import 'rewarded_interstitial/rewarded_interstitial_helper.dart';

class AdsManager {
  AdsManager._();

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static Future<void> initialize() async {
    if (_initialized) return;
    if (!AdsConfig.adsEnabled) return;

    try {
      await MobileAds.instance.initialize();
      if (AdsConfig.interstitialEnabled) {await InterstitialHelper.load();}
      if (AdsConfig.rewardedEnabled) {await RewardedAdsHelper.load();}
      if (AdsConfig.rewardedInterstitialEnabled) {await RewardedInterstitialHelper.load();}
      if (AdsConfig.appOpenEnabled) {await AppOpenAdHelper.load();}
      _initialized = true;
    } catch (e) {
      debugPrint('Ads initialization failed: $e');
    }
  }
}