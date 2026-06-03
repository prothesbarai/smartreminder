import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialHelper {
  static InterstitialAd? _interstitialAd;
  static Future<void> load() async {
    await InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {_interstitialAd = ad;},
        onAdFailedToLoad: (error) {debugPrint(error.message);},
      ),
    );
  }

  static bool get isReady => _interstitialAd != null;

  static void show() {
    if (_interstitialAd == null) {return;}
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {ad.dispose();load();}, onAdFailedToShowFullScreenContent: (ad, error) {ad.dispose();load();},);
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}