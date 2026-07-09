import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../notes/presentation/pages/note_form_screen.dart';
import '../../../projects/presentation/widgets/project_tile.dart';
import '../widgets/dashboard_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showExitDialog(context);
        if (shouldExit) SystemNavigator.pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good evening, Priya',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Your engineering roadmap is progressing steadily.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: MetricCard(
                        title: 'Learning streak',
                        value: '12 days',
                        caption: 'Keep the momentum',
                        icon: Icons.local_fire_department_rounded,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: MetricCard(
                        title: 'Projects',
                        value: '5 active',
                        caption: '3 shipping this month',
                        icon: Icons.folder_open_rounded,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                GlassCard(
                  title: 'Today\'s focus',
                  subtitle: 'System design revision • 60% complete',
                  trailing: const Text('2h 15m'),
                  child: const LinearProgressIndicator(value: 0.6),
                ),
                const SizedBox(height: AppSpacing.md),
                const SectionHeader(title: 'Quick actions'),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    QuickActionChip(
                      icon: Icons.note_alt_outlined,
                      label: 'Write note',
                      onTap: () => _openNoteForm(context),
                    ),
                    QuickActionChip(
                      icon: Icons.quiz_outlined,
                      label: 'Practice interview',
                      onTap: () => context.push(Routes.interviewQuestions),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(title: 'Recent projects'),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: () => context.push(Routes.projects),
                    child: ProjectTile(
                      name: 'DevVault',
                      status: 'In review',
                      stack: 'Flutter • GoRouter',
                      progress: 0.82,
                      deadline: '2026-07-18',
                      onTap: () => context.push(Routes.projects),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: () => context.push(Routes.projects),
                    child: ProjectTile(
                      name: 'Expense Tracker',
                      status: 'Shipping soon',
                      stack: 'Flutter • Firebase',
                      progress: 0.61,
                      deadline: '2026-07-28',
                      onTap: () => context.push(Routes.projects),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SectionHeader(title: 'Today\'s tasks'),
                    TextButton(
                      onPressed: () => context.push(Routes.tasks),
                      child: const Text('See all'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                const TaskPreview(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> _showExitDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Exit app'),
      content: const Text('Are you sure you want to exit the app?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Exit'),
        ),
      ],
    ),
  );
  return result == true;
}

void _openNoteForm(BuildContext context) {
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (context) => NoteFormScreen(),
    ),
  );
}
