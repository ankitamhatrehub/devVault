import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GlassSurface extends StatelessWidget {
  const GlassSurface({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.borderRadius,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final radius = borderRadius ?? AppRadius.large;
    final fillOpacity = theme.brightness == Brightness.dark ? 0.82 : 0.78;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface.withValues(alpha: fillOpacity),
                colorScheme.surfaceContainerHighest.withValues(
                  alpha: fillOpacity * 0.82,
                ),
              ],
            ),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.72),
            ),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
