import 'package:flutter/foundation.dart';
import 'ads_state.dart';

class AdsStateNotifier {
  AdsStateNotifier._();
  static final _notifier = ValueNotifier<AdsState>(AdsState.initial());
  static ValueNotifier<AdsState> get notifier => _notifier;
  static AdsState get state => _notifier.value;
  static void update({bool? initialized, bool? interstitialLoaded, bool? rewardedLoaded, bool? rewardedInterstitialLoaded, bool? appOpenLoaded,}) {
    _notifier.value = state.copyWith(
      initialized: initialized,
      interstitialLoaded: interstitialLoaded,
      rewardedLoaded: rewardedLoaded,
      rewardedInterstitialLoaded: rewardedInterstitialLoaded,
      appOpenLoaded: appOpenLoaded,
    );
  }

  static void dispose() => _notifier.dispose();
}
