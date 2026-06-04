import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app_open/app_open_ad_helper.dart';
import 'app_open/app_open_lifecycle_manager.dart';
import 'config/ads_config.dart';
import 'interstitial/interstitial_helper.dart';
import 'models/ads_state.dart';
import 'rewarded/rewarded_ads_helper.dart';
import 'rewarded_interstitial/rewarded_interstitial_helper.dart';

class AdsManager {
  AdsManager._();

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  /// >>> Any widget that listens to this will get ad status
  static final stateNotifier = ValueNotifier<AdsState>(AdsState.initial());
  static AdsState get state => stateNotifier.value;

  // Shortcut to update state — no need to call from outside
  static void _update({bool? initialized, bool? interstitialLoaded, bool? rewardedLoaded, bool? rewardedInterstitialLoaded, bool? appOpenLoaded,}) {
    stateNotifier.value = state.copyWith(initialized: initialized, interstitialLoaded: interstitialLoaded, rewardedLoaded: rewardedLoaded, rewardedInterstitialLoaded: rewardedInterstitialLoaded, appOpenLoaded: appOpenLoaded,);
  }

  static Future<void> initialize() async {
    if (_initialized) return;
    if (!AdsConfig.adsEnabled) return;

    try {
      await MobileAds.instance.initialize();

      if (AdsConfig.interstitialEnabled) {await InterstitialHelper.load();_update(interstitialLoaded: InterstitialHelper.isReady);}
      if (AdsConfig.rewardedEnabled) {await RewardedAdsHelper.load();_update(rewardedLoaded: RewardedAdsHelper.isReady);}
      if (AdsConfig.rewardedInterstitialEnabled) {await RewardedInterstitialHelper.load();_update(rewardedInterstitialLoaded: RewardedInterstitialHelper.isReady);}
      if (AdsConfig.appOpenEnabled) {
        await AppOpenAdHelper.load();
        _update(appOpenLoaded: AppOpenAdHelper.isReady);
        AppOpenLifecycleManager.instance.initialize();
      }
      _initialized = true;
      _update(initialized: true);
    } catch (e) {
      debugPrint('Ads initialization failed: $e');
    }
  }

  // >>> Call to refresh the state after the ad is show (If show is ad null, so isReady becomes false)

  static void refreshState() {
    _update(
      interstitialLoaded: InterstitialHelper.isReady,
      rewardedLoaded: RewardedAdsHelper.isReady,
      rewardedInterstitialLoaded: RewardedInterstitialHelper.isReady,
      appOpenLoaded: AppOpenAdHelper.isReady,
    );
  }


  static void dispose() {
    if (AdsConfig.appOpenEnabled) {AppOpenLifecycleManager.instance.dispose();}
    stateNotifier.dispose();
  }



}