import 'package:dev_vault/data/models/learning_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';

class LearningDetailScreen extends StatelessWidget {
  const LearningDetailScreen({
    super.key,
    required this.learning,
    required this.onEdit,
    required this.onDelete,
  });

  final LearningModel learning;
  final ValueChanged<LearningModel> onEdit;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    String _formatDate(DateTime? date) {
      if (date == null) return '-';

      return "${date.day}/${date.month}/${date.year}";
    }

    final completedSteps = learning.steps.where((e) => e.isCompleted).length;

    final totalSteps = learning.steps.length;

    final progress = totalSteps == 0 ? 0.0 : completedSteps / totalSteps;
    return Scaffold(
      appBar: AppBar(title: const Text("Learning Roadmap")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      learning.title,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      learning.des,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Overview', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              _DetailCard(
                child: Column(
                  children: [
                    _InfoRow(label: "Category", value: learning.category),

                    _InfoRow(label: "Status", value: learning.status),

                    _InfoRow(label: "Priority", value: learning.priority),

                    _InfoRow(label: "Start Date", value: learning.startDate),

                    _InfoRow(label: "Target Date", value: learning.targetDate),

                    _InfoRow(
                      label: "Created",
                      value: _formatDate(learning.createdAt),
                    ),

                    _InfoRow(
                      label: "Updated",
                      value: _formatDate(learning.updatedAt),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text("Progress", style: Theme.of(context).textTheme.titleLarge),

              const SizedBox(height: AppSpacing.sm),

              _DetailCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text("Completion")),

                        Text("$completedSteps / $totalSteps"),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Text("${(progress * 100).round()}% Completed"),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Decisions', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              const SizedBox(height: AppSpacing.lg),

              Text(
                "Learning Steps",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: AppSpacing.sm),

              _DetailCard(
                child: learning.steps.isEmpty
                    ? const Text("No steps added")
                    : Column(
                        children: learning.steps.map((step) {
                          return CheckboxListTile(
                            value: step.isCompleted,
                            onChanged: null,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(step.title),
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text("Timeline", style: Theme.of(context).textTheme.titleLarge),

              const SizedBox(height: AppSpacing.sm),

              _DetailCard(
                child: Column(
                  children: [
                    _InfoRow(label: "Start", value: learning.startDate),

                    _InfoRow(label: "Target", value: learning.targetDate),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => onEdit(learning),
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton.icon(
                      variant: AppButtonVariant.tonal,
                      onPressed: () => _confirmDelete(context),
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete learning?'),
        content: Text("Delete '${learning.title}' permanently?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            variant: AppButtonVariant.tonal,
            onPressed: () {
              onDelete(learning.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
