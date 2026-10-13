import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_card.dart';
import 'shimmer_effect.dart';

class AppSkeletonList extends StatelessWidget {
  const AppSkeletonList({this.itemCount = 3, this.physics, super.key});

  final int itemCount;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView.separated(
        physics: physics,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) => AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SkeletonBlock(width: 150, height: 16),
              const SizedBox(height: AppSpacing.sm),
              const _SkeletonBlock(width: double.infinity, height: 12),
              const SizedBox(height: AppSpacing.xs),
              const _SkeletonBlock(width: 200, height: 12),
              const SizedBox(height: AppSpacing.md),
              const _SkeletonBlock(width: double.infinity, height: 8),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: const [
                  _SkeletonBlock(width: 68, height: 11),
                  Spacer(),
                  _SkeletonBlock(width: 54, height: 11),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest;
    final lightenedColor = Color.alphaBlend(
      colorScheme.onSurface.withValues(
        alpha: Theme.of(context).brightness == Brightness.dark ? 0.04 : 0.12,
      ),
      baseColor,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: lightenedColor,
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: SizedBox(width: width, height: height),
    );
  }
}
