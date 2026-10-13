import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.margin,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.width,
    this.height,
    this.alignment,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? color;
  final Color? borderColor;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appStyle = theme.extension<AppStyle>();
    final effectivePadding =
        padding == const EdgeInsets.all(AppSpacing.md)
        ? appStyle?.cardPadding ?? padding
        : padding;
    final radius = borderRadius ?? appStyle?.radiusMedium ?? AppRadius.medium;
    final cardHasBorder =
        appStyle == null ||
        appStyle.cardTreatment == AppCardTreatment.border ||
        appStyle.cardTreatment == AppCardTreatment.flatBorder ||
        appStyle.cardTreatment == AppCardTreatment.glowBorder;
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      margin: margin,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(radius),
        border: cardHasBorder
            ? Border.all(
                color:
                    borderColor ??
                    (appStyle?.cardTreatment == AppCardTreatment.glowBorder
                        ? theme.colorScheme.secondary
                        : AppColors.border),
                width: appStyle?.cardBorderWidth ?? 1,
              )
            : null,
        boxShadow:
            appStyle == null ||
                appStyle.cardTreatment == AppCardTreatment.shadow
            ? [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.08),
                  blurRadius: appStyle?.cardElevation ?? 2,
                  offset: const Offset(0, 2),
                ),
              ]
            : appStyle.cardTreatment == AppCardTreatment.glowBorder
            ? [
                BoxShadow(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.12),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
