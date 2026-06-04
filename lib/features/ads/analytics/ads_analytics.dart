import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsAnalytics {
  AdsAnalytics._();

  static void trackPaidEvent(AdWithoutView ad,) {
    ad.onPaidEvent = (Ad ad, double valueMicros, PrecisionType precision, String currencyCode,) {
      final revenue = valueMicros / 1000000;
      debugPrint('Revenue: $revenue $currencyCode',);
    };
  }

  static void logLoaded(String adType,) {debugPrint('$adType Loaded',);}
  static void logFailed(String adType, String message,) {debugPrint('$adType Failed => $message',);}
  static void logShown(String adType,) {debugPrint('$adType Shown',);}
  static void logDismissed(String adType,) {debugPrint('$adType Dismissed',);}
}