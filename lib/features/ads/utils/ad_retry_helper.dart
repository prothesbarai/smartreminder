import 'dart:async';
import 'package:flutter/foundation.dart';

class AdRetryHelper {
  AdRetryHelper._();

  /// Retry করবে [maxAttempts] বার, প্রতিবার [initialDelaySeconds] * attempt delay দিয়ে।
  /// যেমন: 1st retry → 2s, 2nd retry → 4s, 3rd retry → 8s (exponential backoff)
  static Future<void> retryWithBackoff({
    required Future<void> Function() action,
    required String adType,
    int maxAttempts = 3,
    int initialDelaySeconds = 2,
  }) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        await action();
        return; // Exit if successful
      } catch (e) {
        final isLastAttempt = attempt == maxAttempts;

        if (isLastAttempt) {
          debugPrint('[$adType] Retry failed after $maxAttempts attempts: $e');
          return;
        }

        final delaySeconds = initialDelaySeconds * attempt; // 2s, 4s, 6s
        debugPrint('[$adType] Attempt $attempt failed. Retrying in ${delaySeconds}s...');
        await Future.delayed(Duration(seconds: delaySeconds));
      }
    }
  }
}
