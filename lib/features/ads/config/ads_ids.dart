import 'dart:io';
import 'ads_config.dart';

class AdsIds {
  AdsIds._();

  static bool get isAndroid => Platform.isAndroid;

  // >>> ================= TEST ADS ============================================
  static const String _androidBannerTest = 'ca-app-pub-3940256099942544/6300978111';
  static const String _androidInterstitialTest = 'ca-app-pub-3940256099942544/1033173712';
  static const String _androidRewardedTest = 'ca-app-pub-3940256099942544/5224354917';
  static const String _androidRewardedInterstitialTest = 'ca-app-pub-3940256099942544/5354046379';
  static const String _androidNativeTest = 'ca-app-pub-3940256099942544/2247696110';
  static const String _androidAppOpenTest = 'ca-app-pub-3940256099942544/9257395921';

  // >>>> ================= PRODUCTION ADS =====================================
  static const String _androidBannerProd = '';
  static const String _androidInterstitialProd = '';
  static const String _androidRewardedProd = '';
  static const String _androidRewardedInterstitialProd = '';
  static const String _androidNativeProd = '';
  static const String _androidAppOpenProd = '';

  static String get banner => AdsConfig.isTestMode ? _androidBannerTest : _androidBannerProd;
  static String get interstitial => AdsConfig.isTestMode ? _androidInterstitialTest : _androidInterstitialProd;
  static String get rewarded => AdsConfig.isTestMode ? _androidRewardedTest : _androidRewardedProd;
  static String get rewardedInterstitial => AdsConfig.isTestMode ? _androidRewardedInterstitialTest : _androidRewardedInterstitialProd;
  static String get native => AdsConfig.isTestMode ? _androidNativeTest : _androidNativeProd;
  static String get appOpen => AdsConfig.isTestMode ? _androidAppOpenTest : _androidAppOpenProd;
}