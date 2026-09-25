import 'package:flutter/material.dart';

/// Central color palette for Gift Nest.
/// Modern + warm + premium + personal boutique gifting aesthetic.
class AppColors {
  AppColors._();

  // Core Brand Colors
  static const Color primary = Color(0xFF6D3F67);
  static const Color darkPrimary = Color(0xFF492B46);
  static const Color softRose = Color(0xFFD98FA7);
  static const Color warmCream = Color(0xFFFFF8F4);
  static const Color background = Color(0xFFFCFAF9);

  // Typography Colors
  static const Color mainText = Color(0xFF272327);
  static const Color text = mainText;
  static const Color secondaryText = Color(0xFF777177);

  // Functional & Border Colors
  static const Color success = Color(0xFF4F8A67);
  static const Color border = Color(0xFFEAE3E5);
  static const Color error = Color(0xFFBA1A1A);
  static const Color warning = Color(0xFFE08D3C);
  static const Color starGold = Color(0xFFF4B23E);

  // Surface & Card Accents
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF7F2F4);
  static const Color cardShadow = Color(0x0D492B46); // Subtle boutique shadow
  static const Color softRoseLight = Color(0xFFF8E7EC);
  static const Color primaryLight = Color(0xFFF2EAF1);
}
