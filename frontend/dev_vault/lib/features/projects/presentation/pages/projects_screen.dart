import 'dart:async';

import 'package:dev_vault/data/models/projects_model.dart';
import 'package:dev_vault/data/services/projects_service.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'project_detail_screen.dart';
import 'project_form_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<ProjectsModel> _projects = [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    try {
      setState(() => _isLoading = true);

      final projects = await ProjectsService.getAllProjects();

      if (!mounted) return;

      setState(() {
        _projects = projects;
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

  Future<void> _refreshProjects() async {
    await _loadProjects();
  }

  void _addProject(ProjectsModel project) {
    setState(() {
      _projects.insert(0, project);
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${project.projectName} created successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateProject(ProjectsModel updatedProject) {
    setState(() {
      final index = _projects.indexWhere(
        (item) => item.id == updatedProject.id,
      );
      if (index >= 0) {
        _projects[index] = updatedProject;
      }
    });
  }

  Future<void> _deleteProject(String id) async {
    try {
      await ProjectsService.deleteProject(id);

      await _loadProjects();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Project deleted successfully"),
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
    final filteredProjects = _projects.where((project) {
      final query = _searchQuery.toLowerCase();
      return project.projectName.toLowerCase().contains(query) ||
          project.primaryStack.toLowerCase().contains(query) ||
          project.focusTags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _openProjectForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New project'),
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
                          'Projects',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Keep delivery, ideas, and product momentum in one calm workspace.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _showFilterSheet,
                    icon: const Icon(Icons.tune_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search projects',
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
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: _isLoading
                    ? const ProjectSkeletonList()
                    : RefreshIndicator(
                        onRefresh: _refreshProjects,
                        child: filteredProjects.isEmpty
                            ? const EmptyProjectsState()
                            : ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: filteredProjects.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: AppSpacing.sm),
                                itemBuilder: (context, index) {
                                  final project = filteredProjects[index];
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.medium,
                                    ),
                                    onTap: () =>
                                        _openProjectDetail(context, project),
                                    child: ProjectTile(
                                      name: project.projectName,
                                      status: project.status,
                                      stack: project.primaryStack,
                                      progress: project.progress / 100,
                                      deadline: project.deadline,
                                      onTap: () =>
                                          _openProjectDetail(context, project),
                                    ),
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

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.large),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort & filter',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              children: const [
                Chip(label: Text('Priority')),
                Chip(label: Text('This week')),
                Chip(label: Text('In review')),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openProjectDetail(
    BuildContext context,
    ProjectsModel project,
  ) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => ProjectDetailScreen(
          project: project,
          onEdit: (project) async {
            await _openProjectForm(context, project: project);
          },
          onDelete: (id) async {
            await _deleteProject(id);

            if (!mounted) return;

            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> _openProjectForm(
    BuildContext context, {
    ProjectsModel? project,
  }) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ProjectFormScreen(project: project)),
    );

    if (result == true) {
      await _loadProjects();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            project == null
                ? "Project created successfully"
                : "Project updated successfully",
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
