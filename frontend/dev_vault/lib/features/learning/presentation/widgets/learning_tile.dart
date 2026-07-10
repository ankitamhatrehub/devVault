import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';

class LearningTile extends StatelessWidget {
  const LearningTile({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.priority,
    required this.progress,
    required this.completedSteps,
    required this.totalSteps,
    required this.targetDate,
    required this.onTap,
  });

  final String title;
  final String description;
  final String category;
  final String status;
  final String priority;
  final double progress;
  final int completedSteps;
  final int totalSteps;
  final String targetDate;
  final VoidCallback onTap;

  Color _statusColor() {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;

      case 'in progress':
        return AppColors.primary;

      case 'not started':
        return AppColors.warning;

      default:
        return AppColors.textSecondary;
    }
  }

  Color _priorityColor() {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;

      case 'medium':
        return Colors.orange;

      case 'low':
        return Colors.green;

      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: AppCard(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor().withOpacity(.12),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    status,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _statusColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),

            const SizedBox(height: AppSpacing.md),

            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                Chip(
                  label: Text(category),
                  backgroundColor: AppColors.surfaceElevated,
                  side: const BorderSide(color: AppColors.border),
                ),

                Chip(
                  label: Text(priority),
                  backgroundColor: _priorityColor().withOpacity(.10),
                  side: BorderSide(color: _priorityColor()),
                  labelStyle: TextStyle(
                    color: _priorityColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: Text(
                    "$completedSteps/$totalSteps completed",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),

                Text(
                  "${(progress * 100).round()}%",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(value: progress, minHeight: 8),
            ),

            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),

                const SizedBox(width: AppSpacing.xs),

                Expanded(
                  child: Text(
                    targetDate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
