import 'package:flutter/material.dart';

@immutable
class AppPalette {
  const AppPalette({
    required this.primary,
    required this.primarySoft,
    required this.accent,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.success,
    required this.warning,
    required this.danger,
    required this.darkPrimary,
    required this.darkPrimarySoft,
    required this.darkAccent,
    required this.darkSurface,
    required this.darkSurfaceElevated,
    required this.darkTextPrimary,
    required this.darkTextSecondary,
    required this.darkBorder,
    required this.darkSuccess,
    required this.darkWarning,
    required this.darkDanger,
  });

  final Color primary;
  final Color primarySoft;
  final Color accent;
  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color success;
  final Color warning;
  final Color danger;

  final Color darkPrimary;
  final Color darkPrimarySoft;
  final Color darkAccent;
  final Color darkSurface;
  final Color darkSurfaceElevated;
  final Color darkTextPrimary;
  final Color darkTextSecondary;
  final Color darkBorder;
  final Color darkSuccess;
  final Color darkWarning;
  final Color darkDanger;

  Color resolve(String token, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return switch (token) {
      'primary' => isDark ? darkPrimary : primary,
      'primarySoft' => isDark ? darkPrimarySoft : primarySoft,
      'accent' => isDark ? darkAccent : accent,
      'surface' => isDark ? darkSurface : surface,
      'surfaceElevated' => isDark ? darkSurfaceElevated : surfaceElevated,
      'textPrimary' => isDark ? darkTextPrimary : textPrimary,
      'textSecondary' => isDark ? darkTextSecondary : textSecondary,
      'border' => isDark ? darkBorder : border,
      'success' => isDark ? darkSuccess : success,
      'warning' => isDark ? darkWarning : warning,
      'danger' => isDark ? darkDanger : danger,
      _ => throw ArgumentError.value(token, 'token', 'Unknown palette token'),
    };
  }
}
