import 'dart:async';

import 'package:dev_vault/data/models/tasks_model.dart';
import 'package:dev_vault/data/services/tasks_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
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
  List<TasksModel> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

 Future<void> _loadTasks() async {
    try {
      setState(() => _isLoading = true);

      final tasksData = await TasksService.getAllTasks();

      if (!mounted) return;

      setState(() {
        _tasks = tasksData;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

Future<void> _refreshTasks() async {
    await _loadTasks();
  }

Future<void> _deleteTask(String id) async {
    try {
      await TasksService.deleteTask(id);

      await _loadTasks();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task deleted successfully"),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
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
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.dashboard);
            }
          },
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
                                    progress: (task.progress / 100).clamp(0.0, 1.0),
                                    dueDate: task.dueDate,
                                    onTap: () => _openTaskDetail(context, task),
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

  Future<void> _openTaskDetail(BuildContext context, TasksModel task) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => TaskDetailScreen(
          task: task,
         onEdit: (task) async {
            await _openTaskForm(context, task: task);
          },
         onDelete: (id) async {
            await _deleteTask(id);

            if (!mounted) return;

            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> _openTaskForm(BuildContext context, {TasksModel? task}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TaskFormScreen(task: task, onSave: () {}),
      ),
    );

    if (result == true) {
      await _loadTasks();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            task == null
                ? "Task created successfully"
                : "Task updated successfully",
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
