import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dashboard_model.dart';
import '../../../../data/services/dashboard_service.dart';
import '../../../notes/presentation/pages/note_form_screen.dart';
import '../../../projects/presentation/widgets/project_tile.dart';
import '../widgets/dashboard_widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardModel? _dashboard;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final dashboard = await DashboardService.getDashboard();
      setState(() {
        _dashboard = dashboard;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading dashboard: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

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
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showExitDialog(context);
        if (shouldExit) SystemNavigator.pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $_error'),
                      const SizedBox(height: AppSpacing.md),
                      ElevatedButton(
                        onPressed: _loadDashboardData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getGreeting()}, Developer 👋',
                            style: Theme.of(context).textTheme.headlineLarge,
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
                        // height: 140,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                MetricCard(
                                  title: 'Active Projects',
                                  value: '${_dashboard?.activeProjects ?? 0}',
                                  caption: 'In progress',
                                  icon: Icons.folder_open_rounded,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                MetricCard(
                                  title: 'Learnings',
                                  value: '${_dashboard?.learningCount ?? 0}',
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
                                  value: '${_dashboard?.completedTasks ?? 0}',
                                  caption: 'Finished',
                                  icon: Icons.check_circle_rounded,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                MetricCard(
                                  title: 'Pending Tasks',
                                  value: '${_dashboard?.pendingTasks ?? 0}',
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
                            _dashboard?.todayFocus?.toString() ??
                            'No focus set',
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
                      if ((_dashboard?.recentProjects ?? []).isEmpty)
                        EmptyStateSection(
                          icon: Icons.folder_outlined,
                          title: 'No projects yet',
                          subtitle:
                              'Start building your portfolio by creating a new project',
                          actionLabel: 'Create Project',
                          onAction: () => context.push(Routes.projects),
                        )
                      else
                        ...(_dashboard?.recentProjects ?? []).map((project) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: GestureDetector(
                              onTap: () => context.push(Routes.projects),
                              child: ProjectTile(
                                name: project['name'] ?? 'Untitled',
                                status: project['status'] ?? 'In progress',
                                stack: project['stack'] ?? 'Unknown',
                                progress: ((project['progress'] ?? 0) as num)
                                    .toDouble(),
                                deadline: project['deadline'] ?? '2026-07-28',
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
                      if ((_dashboard?.recentTasks ?? []).isEmpty)
                        TaskPreview()
                      else ...[
                        TaskPreview(
                          title: _dashboard!.recentTasks[0]['title'] ?? '',
                          description:
                              _dashboard!.recentTasks[0]['description'],
                          priority: _dashboard!.recentTasks[0]['priority'],
                          status: _dashboard!.recentTasks[0]['status'],
                          dueDate: _dashboard!.recentTasks[0]['dueDate'],
                          progress:
                              ((_dashboard!.recentTasks[0]['progress'] ?? 0)
                                      as num)
                                  .toDouble(),
                        ),
                      ],
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
  Navigator.of(
    context,
  ).push<void>(MaterialPageRoute<void>(builder: (context) => NoteFormScreen()));
}
