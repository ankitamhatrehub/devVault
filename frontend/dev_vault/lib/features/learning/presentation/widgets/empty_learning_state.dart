import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class EmptyLearningState extends StatelessWidget {
  const EmptyLearningState({this.isSearchResult = false, super.key});

  final bool isSearchResult;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: reduceMotion ? 1 : 0.84, end: 1),
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 420),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) =>
              Transform.scale(scale: scale, child: child),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 72,
              color: AppColors.textSecondary.withOpacity(.6),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(
              isSearchResult ? "No matching roadmaps" : "No Learning Roadmaps",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              isSearchResult
                  ? "Try another search term to find a roadmap."
                  : "Create your first learning roadmap to track your progress.",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
