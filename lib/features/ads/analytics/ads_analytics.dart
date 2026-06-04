import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsAnalytics {
  AdsAnalytics._();

  // static final _analytics = FirebaseAnalytics.instance;

  // >>> ===================== REVENUE TRACKING ================================
  static void trackPaidEvent(AdWithoutView ad,) {
    ad.onPaidEvent = (Ad ad, double valueMicros, PrecisionType precision, String currencyCode,) {
      final revenue = valueMicros / 1000000;
      //_analytics.logEvent(name: 'ad_revenue', parameters: {'value': revenue, 'currency': currencyCode, 'precision': precision.name,},);
      debugPrint('Revenue: $revenue $currencyCode',);
    };
  }

  // >>> ===================== AD LIFECYCLE EVENTS =============================
  static void logLoaded(String adType,) {
    //_analytics.logEvent(name: 'ad_loaded', parameters: {'ad_type': adType},);
    debugPrint('$adType Loaded',);
  }
  static void logFailed(String adType, String message,) {
    //_analytics.logEvent(name: 'ad_failed', parameters: {'ad_type': adType, 'error': message,},);
    debugPrint('$adType Failed => $message',);
  }
  static void logShown(String adType,) {
    //_analytics.logEvent(name: 'ad_shown', parameters: {'ad_type': adType},);
    debugPrint('$adType Shown',);
  }
  static void logDismissed(String adType,) {
    //_analytics.logEvent(name: 'ad_dismissed', parameters: {'ad_type': adType},);
    debugPrint('$adType Dismissed',);
  }
}