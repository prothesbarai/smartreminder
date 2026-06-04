class InterstitialFrequencyController {
  InterstitialFrequencyController._();

  static int _clickCount = 0;
  static DateTime? _lastShownTime;

  /// Every N Clicks
  static bool canShowByClick({int frequency = 3,}) {
    _clickCount++;
    return _clickCount % frequency == 0;
  }

  /// Cooldown Timer
  static bool canShowByCooldown({int seconds = 60,}) {
    if (_lastShownTime == null) {return true;}
    return DateTime.now().difference(_lastShownTime!,).inSeconds >= seconds;
  }

  static bool canShow({int frequency = 3, int cooldownSeconds = 60,}) {
    return canShowByClick(frequency: frequency,) && canShowByCooldown(seconds: cooldownSeconds,);
  }

  static void markShown() {_lastShownTime = DateTime.now();}
  static void reset() {_clickCount = 0;_lastShownTime = null;}
}