import 'dart:async';

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
  late List<ProjectItem> _projects;

  @override
  void initState() {
    super.initState();
    _projects = [
      const ProjectItem(
        id: 'p1',
        name: 'DevVault',
        summary: 'A calm workspace for developer growth, learning, and delivery.',
        status: 'In review',
        progress: 0.82,
        stack: 'Flutter • GoRouter',
        deadline: '2026-07-18',
        team: '3 members',
        tags: ['Flutter', 'Product', 'Design'],
        updatedAt: 'Updated 2h ago',
        notes: 'Keep the onboarding flow polished before shipping.',
      ),
      const ProjectItem(
        id: 'p2',
        name: 'Expense Tracker',
        summary: 'An intelligent expense planner with smart categories and alerts.',
        status: 'Shipping soon',
        progress: 0.61,
        stack: 'Flutter • Firebase',
        deadline: '2026-07-28',
        team: '2 members',
        tags: ['Firebase', 'Charts'],
        updatedAt: 'Updated yesterday',
        notes: 'Review the chart density before the beta release.',
      ),
      const ProjectItem(
        id: 'p3',
        name: 'Student Management',
        summary: 'A cross-functional platform for enrolment, advising, and reports.',
        status: 'Planning',
        progress: 0.34,
        stack: 'Node.js • MongoDB',
        deadline: '2026-08-10',
        team: '4 members',
        tags: ['Back-end', 'Reports'],
        updatedAt: 'Updated 3 days ago',
        notes: 'Outline the admin workflows before implementation.',
      ),
    ];
    unawaited(_loadProjects());
  }

  Future<void> _loadProjects() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _refreshProjects() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _addProject(ProjectItem project) {
    setState(() {
      _projects.insert(0, project);
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${project.name} created successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateProject(ProjectItem updatedProject) {
    setState(() {
      final index = _projects.indexWhere((item) => item.id == updatedProject.id);
      if (index >= 0) {
        _projects[index] = updatedProject;
      }
    });
  }

  void _deleteProject(String id) {
    final removed = _projects.firstWhere((item) => item.id == id);
    setState(() => _projects.removeWhere((item) => item.id == id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removed.name} removed from your workspace.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() => _projects.insert(0, removed)),
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
    final filteredProjects = _projects.where((project) {
      final query = _searchQuery.toLowerCase();
      return project.name.toLowerCase().contains(query) ||
          project.stack.toLowerCase().contains(query) ||
          project.tags.any((tag) => tag.toLowerCase().contains(query));
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
                        Text('Projects', style: Theme.of(context).textTheme.headlineLarge),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Keep delivery, ideas, and product momentum in one calm workspace.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
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
                                    borderRadius: BorderRadius.circular(AppRadius.medium),
                                    onTap: () => _openProjectDetail(context, project),
                                    child: ProjectTile(
                                      name: project.name,
                                      status: project.status,
                                      stack: project.stack,
                                      progress: project.progress,
                                      deadline: project.deadline,
                                      onTap: () => _openProjectDetail(context, project),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sort & filter', style: Theme.of(context).textTheme.titleLarge),
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

  Future<void> _openProjectDetail(BuildContext context, ProjectItem project) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => ProjectDetailScreen(
          project: project,
          onEdit: (updatedProject) async {
            final result = await Navigator.of(context).push<ProjectItem?>(
              MaterialPageRoute<ProjectItem?>(
                builder: (context) => ProjectFormScreen(
                  project: updatedProject,
                  onSave: (savedProject) {
                    _updateProject(savedProject);
                    Navigator.of(context).pop(savedProject);
                  },
                ),
              ),
            );
            if (result != null) {
              _updateProject(result);
            }
          },
          onDelete: (id) {
            _deleteProject(id);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _openProjectForm(BuildContext context, {ProjectItem? project}) async {
    final result = await Navigator.of(context).push<ProjectItem?>(
      MaterialPageRoute<ProjectItem?>(
        builder: (context) => ProjectFormScreen(
          project: project,
          onSave: (savedProject) {
            if (project == null) {
              _addProject(savedProject);
            } else {
              _updateProject(savedProject);
            }
            Navigator.of(context).pop(savedProject);
          },
        ),
      ),
    );
    if (result != null && project == null) {
      _addProject(result);
    }
  }
}
