import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/widgets.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late List<TaskItem> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = [
      const TaskItem(
        id: 't1',
        title: 'System design revision',
        description: 'Review scalability patterns and design a notification service',
        priority: 'High',
        progress: 0.6,
        dueDate: '2026-07-10',
        status: 'In Progress',
        category: 'Learning',
        createdAt: 'Created 2h ago',
      ),
      const TaskItem(
        id: 't2',
        title: 'Review Flutter architecture',
        description: 'Complete the Flutter architecture module and understand routing patterns',
        priority: 'Medium',
        progress: 0.82,
        dueDate: '2026-07-08',
        status: 'In Progress',
        category: 'Learning',
        createdAt: 'Created yesterday',
      ),
      const TaskItem(
        id: 't3',
        title: 'Polish DevVault onboarding',
        description: 'Ensure the onboarding flow is smooth and visually polished',
        priority: 'High',
        progress: 0.45,
        dueDate: '2026-07-18',
        status: 'Planning',
        category: 'Project',
        createdAt: 'Created 3 days ago',
      ),
      const TaskItem(
        id: 't4',
        title: 'Mock interview preparation',
        description: 'Practice system design and behavioral questions',
        priority: 'Medium',
        progress: 0.3,
        dueDate: '2026-07-12',
        status: 'Pending',
        category: 'Interview',
        createdAt: 'Created 1 day ago',
      ),
    ];
    unawaited(_loadTasks());
  }

  Future<void> _loadTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _refreshTasks() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _addTask(TaskItem task) {
    setState(() {
      _tasks.insert(0, task);
      _isLoading = false;
    });
  }

  void _updateTask(TaskItem updatedTask) {
    setState(() {
      final index = _tasks.indexWhere((item) => item.id == updatedTask.id);
      if (index >= 0) {
        _tasks[index] = updatedTask;
      }
    });
  }

  void _deleteTask(String id) {
    final removed = _tasks.firstWhere((item) => item.id == id);
    setState(() => _tasks.removeWhere((item) => item.id == id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted successfully'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () => setState(() => _tasks.insert(0, removed)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _tasks.where((task) {
      final query = _searchQuery.toLowerCase();
      return task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query) ||
          task.category.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Tasks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _openTaskForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New task'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Tasks',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Stay focused on what matters most today.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _searchController,
                hintText: 'Search tasks',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: _isLoading
                    ? const TaskSkeletonList()
                    : RefreshIndicator(
                        onRefresh: _refreshTasks,
                        child: filteredTasks.isEmpty
                            ? const EmptyTasksState()
                            : ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: filteredTasks.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: AppSpacing.sm),
                                itemBuilder: (context, index) {
                                  final task = filteredTasks[index];
                                  return TaskTile(
                                    title: task.title,
                                    description: task.description,
                                    priority: task.priority,
                                    status: task.status,
                                    progress: task.progress,
                                    dueDate: task.dueDate,
                                    onTap: () =>
                                        _openTaskDetail(context, task),
                                  );
                                },
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openTaskDetail(
    BuildContext context,
    TaskItem task,
  ) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => TaskDetailScreen(
          task: task,
          onEdit: (updatedTask) async {
            final result = await Navigator.of(context).push<TaskItem?>(
              MaterialPageRoute<TaskItem?>(
                builder: (context) => TaskFormScreen(
                  task: updatedTask,
                  onSave: (savedTask) {
                    _updateTask(savedTask);
                    Navigator.of(context).pop(savedTask);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Task \'${savedTask.title}\' updated successfully!',
                        ),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                ),
              ),
            );
            if (result != null) {
              _updateTask(result);
            }
          },
          onDelete: (id) {
            _deleteTask(id);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _openTaskForm(
    BuildContext context, {
    TaskItem? task,
  }) async {
    await Navigator.of(context).push<TaskItem?>(
      MaterialPageRoute<TaskItem?>(
        builder: (context) => TaskFormScreen(
          task: task,
          onSave: (savedTask) {
            final isCreate = task == null;
            if (isCreate) {
              _addTask(savedTask);
            } else {
              _updateTask(savedTask);
            }
            Navigator.of(context).pop(savedTask);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isCreate
                      ? 'Task \'${savedTask.title}\' created successfully!'
                      : 'Task \'${savedTask.title}\' updated successfully!',
                ),
                backgroundColor: AppColors.success,
              ),
            );
          },
        ),
      ),
    );
  }
}

class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.progress,
    required this.dueDate,
    required this.status,
    required this.category,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String priority;
  final double progress;
  final String dueDate;
  final String status;
  final String category;
  final String createdAt;
}
