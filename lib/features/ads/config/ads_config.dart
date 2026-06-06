import 'package:flutter/foundation.dart';

class AdsConfig {
  AdsConfig._();

  /// >>> Production release এর আগে false করবে
  //static bool isTestMode = true;
  static bool isTestMode = kDebugMode;

  /// >>> Global Ad Enable/Disable
  static bool adsEnabled = true;

  /// >>>> Banner Enable
  static bool bannerEnabled = false;

  /// >>> Interstitial Enable
  static bool interstitialEnabled = true;

  /// >>> Rewarded Enable
  static bool rewardedEnabled = true;

  /// >>> Rewarded Interstitial Enable
  static bool rewardedInterstitialEnabled = true;

  /// >>> App Open Enable
  static bool appOpenEnabled = true;
}