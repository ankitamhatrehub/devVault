import 'package:flutter/material.dart';

import 'app_palette.dart';
import 'app_style.dart';
import 'app_theme_variant.dart';
import 'theme_config.dart';

export 'app_palette.dart';
export 'app_style.dart';
export 'app_theme_variant.dart';
export 'theme_config.dart';

class AppColors {
  AppColors._();

  static Color get primary => _color('primary');
  static Color get primarySoft => _color('primarySoft');
  static Color get accent => _color('accent');
  static Color get surface => _color('surface');
  static Color get surfaceElevated => _color('surfaceElevated');
  static Color get textPrimary => _color('textPrimary');
  static Color get textSecondary => _color('textSecondary');
  static Color get border => _color('border');
  static Color get success => _color('success');
  static Color get warning => _color('warning');
  static Color get danger => _color('danger');

  static Color get darkSurface =>
      AppTheme.config.palette.darkSurface;
  static Color get darkSurfaceElevated =>
      AppTheme.config.palette.darkSurfaceElevated;

  static Color _color(String token) =>
      AppTheme.config.palette.resolve(token, AppTheme.currentBrightness);
}

class AppSpacing {
  AppSpacing._();

  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 40.0;

  static double scaled(double value, BuildContext context) {
    final style = Theme.of(context).extension<AppStyle>();
    return value * (style?.spacingScale ?? 1);
  }
}

class AppRadius {
  AppRadius._();

  static double get small => AppTheme.style.radiusSmall;
  static double get medium => AppTheme.style.radiusMedium;
  static double get large => AppTheme.style.radiusLarge;
  static const pill = 999.0;
}

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get headline => TextStyle(
    fontSize: 28,
    fontWeight: AppTheme.style.headingWeight,
    fontFamily: AppTheme.style.fontFamily,
    letterSpacing: -0.5,
  );

  static TextStyle get title => TextStyle(
    fontSize: 20,
    fontWeight: AppTheme.style.headingWeight,
    fontFamily: AppTheme.style.fontFamily,
  );

  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const caption = TextStyle(fontSize: 13, fontWeight: FontWeight.w500);
}

class AppTheme {
  AppTheme._();

  static final ValueNotifier<AppThemeVariant> variantNotifier =
      ValueNotifier(activeThemeVariant);

  static Brightness currentBrightness = Brightness.light;

  static AppThemeVariant get currentVariant => variantNotifier.value;
  static ThemeConfig get config => ThemeConfig.forVariant(currentVariant);
  static AppStyle get style => config.style;

  static ThemeData build(AppThemeVariant variant, Brightness brightness) {
    final config = ThemeConfig.forVariant(variant);
    final palette = config.palette;
    final style = config.style;
    final isDark = brightness == Brightness.dark;
    final primary = palette.resolve('primary', brightness);
    final primarySoft = palette.resolve('primarySoft', brightness);
    final accent = palette.resolve('accent', brightness);
    final surface = palette.resolve('surface', brightness);
    final elevated = palette.resolve('surfaceElevated', brightness);
    final textPrimary = palette.resolve('textPrimary', brightness);
    final textSecondary = palette.resolve('textSecondary', brightness);
    final border = palette.resolve('border', brightness);
    final danger = palette.resolve('danger', brightness);
    final shadowColor = isDark ? Colors.black : const Color(0xFF152C3A);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accent,
      error: danger,
      surface: surface,
      onSurface: textPrimary,
      brightness: brightness,
    ).copyWith(
      primaryContainer: primarySoft,
      onPrimaryContainer: textPrimary,
      secondaryContainer: primarySoft,
      onSecondaryContainer: textPrimary,
      errorContainer: isDark
          ? const Color(0xFF5C1B1B)
          : const Color(0xFFFFDAD6),
      onErrorContainer: isDark
          ? const Color(0xFFFFDAD6)
          : const Color(0xFF410002),
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: border,
      outlineVariant: border,
      surfaceTint: primary,
    );

    final textTheme = _textTheme(
      style: style,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
    );
    final buttonShape = _buttonShape(style);
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(style.radiusMedium),
    );
    final inputBorder = _inputBorder(style, border);
    final focusedInputBorder = _inputBorder(style, primary, width: 2);
    final scaled = style.spacingScale;
    final density = switch (style.spacingDensity) {
      AppSpacingDensity.compact => VisualDensity.compact,
      AppSpacingDensity.comfortable => VisualDensity.standard,
      AppSpacingDensity.spacious => const VisualDensity(
        horizontal: 1,
        vertical: 1,
      ),
    };
    final cardBorder = style.cardBorderWidth > 0
        ? BorderSide(color: border, width: style.cardBorderWidth)
        : BorderSide.none;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,
      canvasColor: surface,
      cardColor: elevated,
      dividerColor: border,
      visualDensity: density,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[style],
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: variant == AppThemeVariant.monoEditorial,
        titleTextStyle: textTheme.titleLarge,
        toolbarHeight: 64 * scaled,
      ),
      cardTheme: CardThemeData(
        color: elevated,
        surfaceTintColor: Colors.transparent,
        elevation: style.cardElevation,
        shadowColor: style.cardTreatment == AppCardTreatment.glowBorder
            ? accent.withValues(alpha: 0.24)
            : shadowColor.withValues(alpha: 0.12),
        shape: cardShape.copyWith(side: cardBorder),
        margin: EdgeInsets.all(8 * scaled),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buttonStyle(
          shape: buttonShape,
          padding: style.controlPadding,
          background: primary,
          foreground: colorScheme.onPrimary,
          elevation: style.cardTreatment == AppCardTreatment.glowBorder
              ? 3
              : style.cardElevation,
          shadowColor: style.cardTreatment == AppCardTreatment.glowBorder
              ? accent.withValues(alpha: 0.35)
              : shadowColor.withValues(alpha: 0.16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _buttonStyle(
          shape: buttonShape,
          padding: style.controlPadding,
          background: primary,
          foreground: colorScheme.onPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buttonStyle(
          shape: buttonShape,
          padding: style.controlPadding,
          foreground: primary,
          side: BorderSide(
            color: style.cardTreatment == AppCardTreatment.glowBorder
                ? accent
                : border,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _buttonStyle(
          shape: buttonShape,
          padding: style.controlPadding,
          foreground: primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: style.inputStyle == AppInputStyle.filled,
        fillColor: style.inputStyle == AppInputStyle.filled
            ? primarySoft
            : elevated,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16 * scaled,
          vertical: 14 * scaled,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: focusedInputBorder,
        errorBorder: _inputBorder(style, danger),
        focusedErrorBorder: _inputBorder(style, danger, width: 2),
        labelStyle: TextStyle(color: textSecondary),
        hintStyle: TextStyle(color: textSecondary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primarySoft,
        selectedColor: primary,
        disabledColor: border.withValues(alpha: 0.3),
        secondarySelectedColor: accent,
        padding: EdgeInsets.symmetric(
          horizontal: 10 * scaled,
          vertical: 6 * scaled,
        ),
        labelStyle: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TextStyle(color: colorScheme.onPrimary),
        side: BorderSide(
          color: style.cardTreatment == AppCardTreatment.glowBorder
              ? accent
              : border,
          width: style.cardBorderWidth > 0 ? 1 : 0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style.buttonRadius),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: elevated,
        indicatorColor: primarySoft,
        elevation: style.cardElevation,
        height: 76 * scaled,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: textSecondary, fontWeight: FontWeight.w600),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? primary
                : textSecondary,
          );
        }),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: elevated,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        elevation: style.cardElevation,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: style.cardElevation + 2,
        shape: buttonShape,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: elevated,
        surfaceTintColor: Colors.transparent,
        elevation: style.cardElevation + 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style.radiusLarge),
          side: cardBorder,
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: elevated,
        surfaceTintColor: Colors.transparent,
        elevation: style.cardElevation + 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(style.radiusLarge),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: border,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? elevated : textPrimary,
        contentTextStyle: TextStyle(
          color: isDark ? textPrimary : Colors.white,
        ),
        actionTextColor: isDark ? accent : primarySoft,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style.radiusMedium),
        ),
        insetPadding: EdgeInsets.all(16 * scaled),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.onPrimary;
          return textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return border.withValues(alpha: 0.45);
        }),
        trackOutlineColor: WidgetStatePropertyAll(border),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? primary : null;
        }),
        checkColor: WidgetStatePropertyAll(colorScheme.onPrimary),
        side: BorderSide(color: border, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style.radiusSmall / 2),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: textSecondary,
        textColor: textPrimary,
        contentPadding: EdgeInsets.symmetric(horizontal: 16 * scaled),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style.radiusMedium),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: border,
        thickness: style.cardTreatment == AppCardTreatment.flatBorder ? 1 : 0.7,
        space: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: primarySoft,
        circularTrackColor: primarySoft,
        refreshBackgroundColor: elevated,
      ),
    );
  }

  static TextTheme _textTheme({
    required AppStyle style,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final heading = TextStyle(
      color: textPrimary,
      fontFamily: style.fontFamily,
      fontWeight: style.headingWeight,
    );
    final body = TextStyle(color: textPrimary, fontFamily: style.fontFamily);
    final label = TextStyle(
      color: textSecondary,
      fontFamily: style.fontFamily,
      fontWeight: FontWeight.w600,
    );
    return TextTheme(
      displayLarge: heading.copyWith(fontSize: 57, height: 1.12),
      displayMedium: heading.copyWith(fontSize: 45, height: 1.16),
      displaySmall: heading.copyWith(fontSize: 36, height: 1.2),
      headlineLarge: heading.copyWith(fontSize: 32, height: 1.22),
      headlineMedium: heading.copyWith(fontSize: 28, height: 1.25),
      headlineSmall: heading.copyWith(fontSize: 24, height: 1.3),
      titleLarge: heading.copyWith(fontSize: 22, height: 1.3),
      titleMedium: heading.copyWith(fontSize: 16, height: 1.45),
      titleSmall: heading.copyWith(fontSize: 14, height: 1.4),
      bodyLarge: body.copyWith(fontSize: 16, height: 1.5),
      bodyMedium: body.copyWith(fontSize: 14, height: 1.45),
      bodySmall: body.copyWith(
        fontSize: 12,
        height: 1.4,
        color: textSecondary,
      ),
      labelLarge: label.copyWith(fontSize: 14, height: 1.4),
      labelMedium: label.copyWith(fontSize: 12, height: 1.3),
      labelSmall: label.copyWith(fontSize: 11, height: 1.3),
    );
  }

  static OutlinedBorder _buttonShape(AppStyle style) {
    final radius = style.buttonRadius;
    return switch (style.buttonShape) {
      AppButtonShape.pill => StadiumBorder(
        side: style.cardTreatment == AppCardTreatment.glowBorder
            ? const BorderSide(width: 1)
            : BorderSide.none,
      ),
      AppButtonShape.rounded => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      AppButtonShape.sharp => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    };
  }

  static ButtonStyle _buttonStyle({
    required OutlinedBorder shape,
    required EdgeInsets padding,
    Color? background,
    Color? foreground,
    BorderSide? side,
    double? elevation,
    Color? shadowColor,
  }) {
    return ButtonStyle(
      shape: WidgetStatePropertyAll(shape),
      padding: WidgetStatePropertyAll(padding),
      backgroundColor: background == null
          ? null
          : WidgetStatePropertyAll(background),
      foregroundColor: foreground == null
          ? null
          : WidgetStatePropertyAll(foreground),
      side: side == null ? null : WidgetStatePropertyAll(side),
      elevation: elevation == null
          ? null
          : WidgetStatePropertyAll(elevation),
      shadowColor: shadowColor == null
          ? null
          : WidgetStatePropertyAll(shadowColor),
    );
  }

  static InputBorder _inputBorder(
    AppStyle style,
    Color color, {
    double width = 1,
  }) {
    if (style.inputStyle == AppInputStyle.underline) {
      return UnderlineInputBorder(
        borderSide: BorderSide(color: color, width: width),
      );
    }
    final radius = style.radiusMedium;
    final side = BorderSide(color: color, width: width);
    return switch (style.inputStyle) {
      AppInputStyle.filled => OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide.none,
      ),
      AppInputStyle.outlined => OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: side,
      ),
      AppInputStyle.underline => UnderlineInputBorder(borderSide: side),
    };
  }
}
