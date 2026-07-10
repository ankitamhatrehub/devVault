import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class LearningSkeleton extends StatelessWidget {
  const LearningSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, __) => const _LearningSkeletonTile(),
    );
  }
}

class _LearningSkeletonTile extends StatelessWidget {
  const _LearningSkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SkeletonBox(width: 180, height: 18),
          SizedBox(height: AppSpacing.sm),
          _SkeletonBox(width: double.infinity, height: 14),
          SizedBox(height: AppSpacing.xs),
          _SkeletonBox(width: 220, height: 14),
          SizedBox(height: AppSpacing.md),
          _SkeletonBox(width: double.infinity, height: 8),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _SkeletonBox(width: 70, height: 12),
              Spacer(),
              _SkeletonBox(width: 60, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == double.infinity ? double.infinity : width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
    );
  }
}
