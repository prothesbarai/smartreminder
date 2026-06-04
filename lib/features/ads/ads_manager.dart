import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app_open/app_open_ad_helper.dart';
import 'app_open/app_open_lifecycle_manager.dart';
import 'config/ads_config.dart';
import 'interstitial/interstitial_helper.dart';
import 'models/ads_state.dart';
import 'models/ads_state_notifier.dart';
import 'rewarded/rewarded_ads_helper.dart';
import 'rewarded_interstitial/rewarded_interstitial_helper.dart';

class AdsManager {
  AdsManager._();

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  // >>>> Listen to it from the UI
  static ValueNotifier<AdsState> get stateNotifier => AdsStateNotifier.notifier;
  static AdsState get state => AdsStateNotifier.state;

  static Future<void> initialize() async {
    if (_initialized) return;
    if (!AdsConfig.adsEnabled) return;

    try {
      await MobileAds.instance.initialize();
      if (AdsConfig.interstitialEnabled) await InterstitialHelper.load();
      if (AdsConfig.rewardedEnabled) await RewardedAdsHelper.load();
      if (AdsConfig.rewardedInterstitialEnabled) await RewardedInterstitialHelper.load();
      if (AdsConfig.appOpenEnabled) {
        await AppOpenAdHelper.load();
        AppOpenLifecycleManager.instance.initialize();
      }
      _initialized = true;
      AdsStateNotifier.update(initialized: true);
    } catch (e) {
      debugPrint('Ads initialization failed: $e');
    }
  }

  static void dispose() {
    if (AdsConfig.appOpenEnabled) {AppOpenLifecycleManager.instance.dispose();}
    AdsStateNotifier.dispose();
  }
}
