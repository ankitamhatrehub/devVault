import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF2563EB);
  static const primarySoft = Color(0xFFDCEBFF);
  static const accent = Color(0xFF14B8A6);
  static const surface = Color(0xFFF8FAFC);
  static const surfaceElevated = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const border = Color(0xFFE2E8F0);
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);
  static const darkSurface = Color(0xFF0F172A);
  static const darkSurfaceElevated = Color(0xFF111827);
}

class AppSpacing {
  AppSpacing._();

  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 14.0;
  static const xl = 32.0;
  static const xxl = 40.0;
}

class AppRadius {
  AppRadius._();

  static const small = 12.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const pill = 999.0;
}

class AppTextStyles {
  AppTextStyles._();

  static const headline = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const title = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const caption = TextStyle(fontSize: 13, fontWeight: FontWeight.w500);
}

class AppTheme {
  AppTheme._();

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.surface,
    cardColor: AppColors.surfaceElevated,
    dividerColor: AppColors.border,
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.headline,
      titleLarge: AppTextStyles.title,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.caption,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
      ),
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.darkSurface,
    cardColor: AppColors.darkSurfaceElevated,
    dividerColor: AppColors.border.withValues(alpha: 0.18),
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.headline,
      titleLarge: AppTextStyles.title,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.caption,
    ),
  );
}
