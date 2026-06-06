import 'package:flutter/foundation.dart';

class AdsConfig {
  AdsConfig._();

  /// >>> Production release এর আগে false করবে
  //static bool isTestMode = true;
  static bool isTestMode = kDebugMode;

  /// >>> Global Ad Enable/Disable ( All Ads Control )
  static bool adsEnabled = true;

  /// >>>> Only Banner Ads Enable/Disable
  static bool bannerEnabled = false;

  /// >>> Only Interstitial Ads /Disable
  static bool interstitialEnabled = true;

  /// >>> Only Rewarded Ads Enable/Disable
  static bool rewardedEnabled = true;

  /// >>> Only Rewarded Interstitial Ads Enable/Disable
  static bool rewardedInterstitialEnabled = true;

  /// >>> Only App Open Ads Enable/Disable ( Use When App Open Then Show ads )
  static bool appOpenEnabled = false;
}