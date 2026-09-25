import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Central theme configuration for Gift Nest.
/// Implements a boutique gifting marketplace aesthetic with Material 3,
/// Poppins typography, rounded surfaces, and curated brand colors.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    final textTheme = baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        color: AppColors.mainText,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        color: AppColors.mainText,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        color: AppColors.mainText,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        color: AppColors.mainText,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        color: AppColors.mainText,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        color: AppColors.mainText,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        color: AppColors.mainText,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        color: AppColors.secondaryText,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        color: AppColors.mainText,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        color: AppColors.mainText,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        color: AppColors.secondaryText,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        color: AppColors.mainText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );

    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.darkPrimary,
      secondary: AppColors.softRose,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.softRoseLight,
      onSecondaryContainer: AppColors.darkPrimary,
      tertiary: AppColors.warmCream,
      onTertiary: AppColors.darkPrimary,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.mainText,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.secondaryText,
      outline: AppColors.border,
      shadow: AppColors.cardShadow,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: textTheme,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.mainText,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.mainText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        iconTheme: IconThemeData(color: AppColors.mainText),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      // Card
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          side: BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMd,
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMd,
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(
          color: AppColors.secondaryText,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.warmCream,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.surfaceVariant,
        labelStyle: const TextStyle(
          color: AppColors.mainText,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        side: const BorderSide(color: AppColors.border, width: 1),
        shape: const RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusFull,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: CircleBorder(),
      ),
    );
  }
}
