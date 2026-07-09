import 'package:dev_vault/data/models/notes_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';


class NoteDetailScreen extends StatelessWidget {
  const NoteDetailScreen({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  final NotesModel note;
  final ValueChanged<NotesModel> onEdit;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    String _formatDate(DateTime? date) {
      if (date == null) return '-';

      return "${date.day}/${date.month}/${date.year}";
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Note details')),
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
                      note.title,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      note.body,
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
                    _InfoRow(label: 'Category', value: note.category),
                    _InfoRow(label: 'Last update', value: _formatDate(note.updatedAt)),
                    _InfoRow(
                      label: 'Pinned',
                      value: note.pinned ? 'Yes' : 'No',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Decisions', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              ComingSoonBadge(
                label: 'Coming Soon',
                child: _DetailCard(
                  child: Text(
                    'Keep a short action item, one decision, and one follow-up for each note.',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => onEdit(note),
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
        title: const Text('Delete note?'),
        content: const Text('This note will be archived from your workspace.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            variant: AppButtonVariant.tonal,
            onPressed: () {
              onDelete(note.id);
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
