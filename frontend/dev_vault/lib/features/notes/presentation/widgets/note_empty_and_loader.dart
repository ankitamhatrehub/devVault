import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NoteSkeletonList extends StatelessWidget {
  const NoteSkeletonList({super.key});

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
            Container(width: 120, height: 12, color: AppColors.border),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              height: 12,
              color: AppColors.border,
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(width: 180, height: 12, color: AppColors.border),
          ],
        ),
      ),
    );
  }
}

class EmptyNotesState extends StatelessWidget {
  const EmptyNotesState({super.key});

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
                Icons.note_alt_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('No notes yet', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Record important context while it is still fresh.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
