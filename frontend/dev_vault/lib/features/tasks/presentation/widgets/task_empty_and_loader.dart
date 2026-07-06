import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TaskSkeletonList extends StatelessWidget {
  const TaskSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 150, height: 16, color: AppColors.border),
            const SizedBox(height: AppSpacing.sm),
            Container(width: double.infinity, height: 12, color: AppColors.border),
            const SizedBox(height: AppSpacing.xs),
            Container(width: 200, height: 12, color: AppColors.border),
            const SizedBox(height: AppSpacing.md),
            Container(width: double.infinity, height: 8, color: AppColors.border),
          ],
        ),
      ),
    );
  }
}

class EmptyTasksState extends StatelessWidget {
  const EmptyTasksState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Create a task to stay focused and track your progress.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
