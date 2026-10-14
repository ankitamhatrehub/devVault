import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../notes/presentation/pages/note_form_screen.dart';
import '../../../projects/presentation/widgets/project_tile.dart';
import '../cubit/dashboard_cubit.dart';
import '../widgets/dashboard_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit()..loadDashboard(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final dashboard = state.dashboard;
        final todayFocusProgress =
            ((dashboard?.todayFocus?['progress'] ?? 0) as num).toDouble();

        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final shouldExit = await _showExitDialog(context);
            if (shouldExit) SystemNavigator.pop();
          },
          child: Scaffold(
            body: SafeArea(
              child: AnimatedGradientBackground(
                child: state.isLoading
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: AppSpacing.md),
                            Text('Loading your dashboard...'),
                          ],
                        ),
                      )
                    : state.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: ${state.error}'),
                            const SizedBox(height: AppSpacing.md),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<DashboardCubit>()
                                  .loadDashboard(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: StaggeredColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_getGreeting()}, Developer 👋',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineLarge,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Track your progress and build amazing things.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          SizedBox(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    MetricCard(
                                      title: 'Active Projects',
                                      value:
                                          '${dashboard?.activeProjects ?? 0}',
                                      caption: 'In progress',
                                      icon: Icons.folder_open_rounded,
                                      color: AppColors.accent,
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    MetricCard(
                                      title: 'Learnings',
                                      value: '${dashboard?.learningCount ?? 0}',
                                      caption: 'Keep learning',
                                      icon: Icons.school_rounded,
                                      color: AppColors.warning,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    MetricCard(
                                      title: 'Completed Tasks',
                                      value:
                                          '${dashboard?.completedTasks ?? 0}',
                                      caption: 'Finished',
                                      icon: Icons.check_circle_rounded,
                                      color: AppColors.success,
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    MetricCard(
                                      title: 'Pending Tasks',
                                      value: '${dashboard?.pendingTasks ?? 0}',
                                      caption: 'To do',
                                      icon: Icons.pending_actions_rounded,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          GlassCard(
                            title: 'Today\'s focus',
                            subtitle:
                                (dashboard?.todayFocus?['title'] as String?) ??
                                'No focus set',
                            trailing: const Text('2h 15m'),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 0,
                                end: (todayFocusProgress / 100).clamp(0.0, 1.0),
                              ),
                              duration: MediaQuery.of(context).disableAnimations
                                  ? Duration.zero
                                  : const Duration(milliseconds: 700),
                              curve: Curves.easeOutCubic,
                              builder: (context, progress, _) =>
                                  LinearProgressIndicator(value: progress),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const SectionHeader(title: 'Quick actions'),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: [
                              QuickActionChip(
                                icon: Icons.create_new_folder_rounded,
                                label: 'New Project',
                                onTap: () => context.push(Routes.projects),
                              ),
                              QuickActionChip(
                                icon: Icons.add_task_rounded,
                                label: 'New Task',
                                onTap: () => context.push(Routes.tasks),
                              ),
                              QuickActionChip(
                                icon: Icons.note_alt_outlined,
                                label: 'Write note',
                                onTap: () => _openNoteForm(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          const SectionHeader(title: 'Recent projects'),
                          const SizedBox(height: AppSpacing.sm),
                          if ((dashboard?.recentProjects ?? []).isEmpty)
                            EmptyStateSection(
                              icon: Icons.folder_outlined,
                              title: 'No projects yet',
                              subtitle:
                                  'Start building your portfolio by creating a new project',
                              actionLabel: 'Create Project',
                              onAction: () => context.push(Routes.projects),
                            )
                          else
                            ...(dashboard?.recentProjects ?? []).map((project) {
                              final progressValue =
                                  ((project['progress'] ?? 0) as num)
                                      .toDouble();
                              final normalizedProgress = progressValue > 1
                                  ? (progressValue / 100).clamp(0.0, 1.0)
                                  : progressValue.clamp(0.0, 1.0);
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: GestureDetector(
                                  onTap: () => context.push(Routes.projects),
                                  child: ProjectTile(
                                    name: project['projectName'] ?? 'Untitled',
                                    status: project['status'] ?? 'In progress',
                                    stack: project['primaryStack'] ?? 'Unknown',
                                    progress: normalizedProgress,
                                    deadline:
                                        project['deadline'] ?? '2026-07-28',
                                    onTap: () => context.push(Routes.projects),
                                  ),
                                ),
                              );
                            }),
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
                          if ((dashboard?.recentTasks ?? []).isEmpty)
                            TaskPreview()
                          else ...[
                            ...(dashboard?.recentTasks ?? []).take(2).map((
                              task,
                            ) {
                              final progressValue =
                                  ((task['progress'] ?? 0) as num).toDouble();
                              final normalizedProgress = progressValue > 1
                                  ? (progressValue / 100).clamp(0.0, 1.0)
                                  : progressValue.clamp(0.0, 1.0);

                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: TaskPreview(
                                  title: task['title'] ?? 'Untitled',
                                  description: task['description'],
                                  priority: task['priority'],
                                  status: task['status'],
                                  dueDate: task['dueDate'],
                                  progress: normalizedProgress,
                                ),
                              );
                            }),
                          ],
                                  ],
                                ),
                              ),
                      ),
                    ),
            ),
          );
      },
    );
  }
}

Future<bool> _showExitDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => GlassAlertDialog(
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
  Navigator.of(
    context,
  ).push<void>(MaterialPageRoute<void>(builder: (context) => NoteFormScreen()));
}
