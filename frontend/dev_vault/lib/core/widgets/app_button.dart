import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum AppButtonVariant { primary, tonal }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = AppButtonVariant.primary,
    this.fullWidth = false,
    this.style,
    this.width,
    this.height,
    this.icon,
    this.label,
  });

  const AppButton.icon({
    super.key,
    required this.onPressed,
    required Widget this.icon,
    required Widget this.label,
    this.variant = AppButtonVariant.primary,
    this.fullWidth = false,
    this.style,
    this.width,
    this.height,
  }) : child = null;

  final VoidCallback? onPressed;
  final Widget? child;
  final Widget? icon;
  final Widget? label;
  final AppButtonVariant variant;
  final bool fullWidth;
  final ButtonStyle? style;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle defaultStyle = ElevatedButton.styleFrom(
      backgroundColor: variant == AppButtonVariant.primary
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: variant == AppButtonVariant.primary
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onSecondaryContainer,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      minimumSize: Size(width ?? 64, height ?? 48),
    );

    final effectiveStyle = style == null
        ? defaultStyle
        : defaultStyle.merge(style);

    Widget button;

    if (icon != null && label != null) {
      button = ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon!,
        label: label!,
        style: effectiveStyle,
      );
    } else {
      button = ElevatedButton(
        onPressed: onPressed,
        style: effectiveStyle,
        child: child!,
      );
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, height: height, child: button);
    }
    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: button);
    }
    return button;
  }
}
