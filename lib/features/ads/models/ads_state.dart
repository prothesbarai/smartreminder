class AdsState {
  final bool initialized;
  final bool interstitialLoaded;
  final bool rewardedLoaded;
  final bool rewardedInterstitialLoaded;
  final bool appOpenLoaded;

  const AdsState({required this.initialized, required this.interstitialLoaded, required this.rewardedLoaded, required this.rewardedInterstitialLoaded, required this.appOpenLoaded,});

  factory AdsState.initial() {
    return const AdsState(initialized: false, interstitialLoaded: false, rewardedLoaded: false, rewardedInterstitialLoaded: false, appOpenLoaded: false,);
  }

  AdsState copyWith({bool? initialized, bool? interstitialLoaded, bool? rewardedLoaded, bool? rewardedInterstitialLoaded, bool? appOpenLoaded,}) {
    return AdsState(
      initialized: initialized ?? this.initialized,
      interstitialLoaded: interstitialLoaded ?? this.interstitialLoaded,
      rewardedLoaded: rewardedLoaded ?? this.rewardedLoaded,
      rewardedInterstitialLoaded:
      rewardedInterstitialLoaded ?? this.rewardedInterstitialLoaded,
      appOpenLoaded: appOpenLoaded ?? this.appOpenLoaded,
    );
  }
}