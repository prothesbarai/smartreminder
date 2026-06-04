import 'dart:io';
import 'ads_config.dart';

class AdsIds {
  AdsIds._();

  static bool get _isAndroid => Platform.isAndroid;

  // >>> ===================== ANDROID TEST ====================================
  static const String _androidBannerTest         = 'ca-app-pub-3940256099942544/6300978111';
  static const String _androidInterstitialTest    = 'ca-app-pub-3940256099942544/1033173712';
  static const String _androidRewardedTest        = 'ca-app-pub-3940256099942544/5224354917';
  static const String _androidRewardedIntTest     = 'ca-app-pub-3940256099942544/5354046379';
  static const String _androidNativeTest          = 'ca-app-pub-3940256099942544/2247696110';
  static const String _androidAppOpenTest         = 'ca-app-pub-3940256099942544/9257395921';

  // >>> ===================== ANDROID PRODUCTION ==============================
  static const String _androidBannerProd          = '';
  static const String _androidInterstitialProd    = '';
  static const String _androidRewardedProd        = '';
  static const String _androidRewardedIntProd     = '';
  static const String _androidNativeProd          = '';
  static const String _androidAppOpenProd         = '';

  // >>>> ===================== iOS TEST =======================================
  static const String _iosBannerTest              = 'ca-app-pub-3940256099942544/2934735716';
  static const String _iosInterstitialTest        = 'ca-app-pub-3940256099942544/4411468910';
  static const String _iosRewardedTest            = 'ca-app-pub-3940256099942544/1712485313';
  static const String _iosRewardedIntTest         = 'ca-app-pub-3940256099942544/6978759866';
  static const String _iosNativeTest              = 'ca-app-pub-3940256099942544/3986624511';
  static const String _iosAppOpenTest             = 'ca-app-pub-3940256099942544/5575463023';

  // >>>> ===================== iOS PRODUCTION =================================
  static const String _iosBannerProd              = '';
  static const String _iosInterstitialProd        = '';
  static const String _iosRewardedProd            = '';
  static const String _iosRewardedIntProd         = '';
  static const String _iosNativeProd              = '';
  static const String _iosAppOpenProd             = '';

  // >>>> GETTERS will give the correct ID according to platform + mode ========
  static String get banner {
    if (_isAndroid) return AdsConfig.isTestMode ? _androidBannerTest : _androidBannerProd;
    return AdsConfig.isTestMode ? _iosBannerTest : _iosBannerProd;
  }

  static String get interstitial {
    if (_isAndroid) return AdsConfig.isTestMode ? _androidInterstitialTest : _androidInterstitialProd;
    return AdsConfig.isTestMode ? _iosInterstitialTest : _iosInterstitialProd;
  }

  static String get rewarded {
    if (_isAndroid) return AdsConfig.isTestMode ? _androidRewardedTest : _androidRewardedProd;
    return AdsConfig.isTestMode ? _iosRewardedTest : _iosRewardedProd;
  }

  static String get rewardedInterstitial {
    if (_isAndroid) return AdsConfig.isTestMode ? _androidRewardedIntTest : _androidRewardedIntProd;
    return AdsConfig.isTestMode ? _iosRewardedIntTest : _iosRewardedIntProd;
  }

  static String get native {
    if (_isAndroid) return AdsConfig.isTestMode ? _androidNativeTest : _androidNativeProd;
    return AdsConfig.isTestMode ? _iosNativeTest : _iosNativeProd;
  }

  static String get appOpen {
    if (_isAndroid) return AdsConfig.isTestMode ? _androidAppOpenTest : _androidAppOpenProd;
    return AdsConfig.isTestMode ? _iosAppOpenTest : _iosAppOpenProd;
  }
}
