import 'package:flutter/material.dart';

enum AppCardTreatment { border, shadow, flatBorder, glowBorder }

enum AppButtonShape { pill, rounded, sharp }

enum AppInputStyle { outlined, filled, underline }

enum AppSpacingDensity { compact, comfortable, spacious }

@immutable
class AppStyle extends ThemeExtension<AppStyle> {
  const AppStyle({
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusLarge,
    required this.cardElevation,
    required this.cardTreatment,
    required this.cardBorderWidth,
    required this.buttonShape,
    required this.inputStyle,
    required this.spacingDensity,
    required this.spacingScale,
    required this.fontFamily,
    required this.headingWeight,
  });

  final double radiusSmall;
  final double radiusMedium;
  final double radiusLarge;
  final double cardElevation;
  final AppCardTreatment cardTreatment;
  final double cardBorderWidth;
  final AppButtonShape buttonShape;
  final AppInputStyle inputStyle;
  final AppSpacingDensity spacingDensity;
  final double spacingScale;
  final String fontFamily;
  final FontWeight headingWeight;

  double get buttonRadius => switch (buttonShape) {
    AppButtonShape.pill => 999,
    AppButtonShape.rounded => radiusLarge,
    AppButtonShape.sharp => radiusSmall,
  };

  EdgeInsets get controlPadding => EdgeInsets.symmetric(
    horizontal: 16 * spacingScale,
    vertical: 12 * spacingScale,
  );

  EdgeInsets get cardPadding => EdgeInsets.all(16 * spacingScale);

  @override
  AppStyle copyWith({
    double? radiusSmall,
    double? radiusMedium,
    double? radiusLarge,
    double? cardElevation,
    AppCardTreatment? cardTreatment,
    double? cardBorderWidth,
    AppButtonShape? buttonShape,
    AppInputStyle? inputStyle,
    AppSpacingDensity? spacingDensity,
    double? spacingScale,
    String? fontFamily,
    FontWeight? headingWeight,
  }) {
    return AppStyle(
      radiusSmall: radiusSmall ?? this.radiusSmall,
      radiusMedium: radiusMedium ?? this.radiusMedium,
      radiusLarge: radiusLarge ?? this.radiusLarge,
      cardElevation: cardElevation ?? this.cardElevation,
      cardTreatment: cardTreatment ?? this.cardTreatment,
      cardBorderWidth: cardBorderWidth ?? this.cardBorderWidth,
      buttonShape: buttonShape ?? this.buttonShape,
      inputStyle: inputStyle ?? this.inputStyle,
      spacingDensity: spacingDensity ?? this.spacingDensity,
      spacingScale: spacingScale ?? this.spacingScale,
      fontFamily: fontFamily ?? this.fontFamily,
      headingWeight: headingWeight ?? this.headingWeight,
    );
  }

  @override
  AppStyle lerp(ThemeExtension<AppStyle>? other, double t) {
    if (other is! AppStyle) return this;
    return AppStyle(
      radiusSmall: lerpDouble(radiusSmall, other.radiusSmall, t)!,
      radiusMedium: lerpDouble(radiusMedium, other.radiusMedium, t)!,
      radiusLarge: lerpDouble(radiusLarge, other.radiusLarge, t)!,
      cardElevation: lerpDouble(cardElevation, other.cardElevation, t)!,
      cardTreatment: t < 0.5 ? cardTreatment : other.cardTreatment,
      cardBorderWidth: lerpDouble(cardBorderWidth, other.cardBorderWidth, t)!,
      buttonShape: t < 0.5 ? buttonShape : other.buttonShape,
      inputStyle: t < 0.5 ? inputStyle : other.inputStyle,
      spacingDensity: t < 0.5 ? spacingDensity : other.spacingDensity,
      spacingScale: lerpDouble(spacingScale, other.spacingScale, t)!,
      fontFamily: t < 0.5 ? fontFamily : other.fontFamily,
      headingWeight: t < 0.5 ? headingWeight : other.headingWeight,
    );
  }
}

double? lerpDouble(num? a, num? b, double t) {
  if (a == null && b == null) return null;
  final first = a ?? 0;
  final second = b ?? 0;
  return first + (second - first) * t;
}
