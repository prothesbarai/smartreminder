class AdsConfig {
  AdsConfig._();

  /// >>> Production release এর আগে false করবে
  static bool isTestMode = true;

  /// >>> Global Ad Enable/Disable
  static bool adsEnabled = true;

  /// >>>> Banner Enable
  static bool bannerEnabled = true;

  /// >>> Interstitial Enable
  static bool interstitialEnabled = true;

  /// >>> Rewarded Enable
  static bool rewardedEnabled = true;

  /// >>> Rewarded Interstitial Enable
  static bool rewardedInterstitialEnabled = true;

  /// >>> Native Enable
  static bool nativeEnabled = true;

  /// >>> App Open Enable
  static bool appOpenEnabled = true;
}