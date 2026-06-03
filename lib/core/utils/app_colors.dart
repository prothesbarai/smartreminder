import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xff030303);
  static const Color secondaryColor = Color(0xffffffff);
  static const Color yellowAccent = Color(0xffffff00);
  static const Color bodyBgOverlayColor = Color(0xffffffff);

  static const Color appButtonBgColor = Color(0xff030303);
  static const Color appButtonTextColor = Color(0xffffffff);

  static const Color appInputFieldActiveColor = Color(0xff030303);
  static const Color appInputFieldUnActiveColor = Color(0x7e2f2f31);

  static const Color dangerColor = Color(0xFFDC3545);
  static const Color success = Color(0xFF21b531);

  // Base
  static const Color bg = Color(0xFF0B0F1A);
  static const Color card = Color(0xFF111827);

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;

  // Accent (ONLY 2 MAIN ACCENTS)
  static const Color gold1 = Color(0xFFFFD54F);
  static const Color gold2 = Color(0xFFFF9800);

  static const Color blue1 = Color(0xFF4F8CFF);
  static const Color blue2 = Color(0xFF1E3A8A);

  static const Color danger = Color(0xFFDC3545);

  // Glass
  static Color glass = Colors.white.withValues(alpha: 0.06);
  static Color border = Colors.white.withValues(alpha: 0.08);
}

class AppGradients {
  static const LinearGradient gold = LinearGradient(colors: [AppColors.gold1, AppColors.gold2],);
  static const LinearGradient blue = LinearGradient(colors: [AppColors.blue1, AppColors.blue2],);
  static final LinearGradient glass = LinearGradient(colors: [Colors.white.withValues(alpha: 0.10), Colors.white.withValues(alpha: 0.04),], begin: Alignment.topLeft, end: Alignment.bottomRight,);
}