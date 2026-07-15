import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class EmptyLearningState extends StatelessWidget {
  const EmptyLearningState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
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
              "No Learning Roadmaps",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              "Create your first learning roadmap to track your progress.",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
