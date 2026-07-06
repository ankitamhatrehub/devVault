import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/widgets.dart';

class ProjectItem {
  const ProjectItem({
    required this.id,
    required this.name,
    required this.summary,
    required this.status,
    required this.progress,
    required this.stack,
    required this.deadline,
    required this.team,
    required this.tags,
    required this.updatedAt,
    required this.notes,
  });

  final String id;
  final String name;
  final String summary;
  final String status;
  final double progress;
  final String stack;
  final String deadline;
  final String team;
  final List<String> tags;
  final String updatedAt;
  final String notes;
}

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({
    super.key,
    required this.project,
    required this.onEdit,
    required this.onDelete,
  });

  final ProjectItem project;
  final ValueChanged<ProjectItem> onEdit;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project details'),
        actions: [
          Tooltip(
            message: 'Coming Soon',
            child: IconButton(
              onPressed: null,
              icon: const Icon(Icons.ios_share_rounded),
            ),
          ),
        ],
      ),
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
                      project.name,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      project.summary,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(project.status),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          project.updatedAt,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Overview', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              DetailCard(
                child: Column(
                  children: [
                    InfoRow(label: 'Stack', value: project.stack),
                    InfoRow(label: 'Deadline', value: project.deadline),
                    InfoRow(label: 'Team', value: project.team),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Status', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              DetailCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('Progress')),
                        Text('${(project.progress * 100).round()}%'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: LinearProgressIndicator(
                        value: project.progress,
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Timeline', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              ComingSoonBadge(
                label: 'Coming Soon',
                child: DetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kickoff • 3 days ago'),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Design review • scheduled tomorrow'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Notes', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              DetailCard(child: Text(project.notes)),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Attachments',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              ComingSoonBadge(
                label: 'Coming Soon',
                child: DetailCard(
                  child: Text(
                    'Design mockups and architecture notes will appear here.',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => onEdit(project),
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
        title: const Text('Delete project?'),
        content: Text(
          'This will remove ${project.name} from your active workspace.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            variant: AppButtonVariant.tonal,
            onPressed: () {
              onDelete(project.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${project.name} deleted successfully'),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
