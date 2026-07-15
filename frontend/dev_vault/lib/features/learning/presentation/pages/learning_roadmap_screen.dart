import 'package:dev_vault/core/widgets/app_text_field.dart';
import 'package:dev_vault/data/models/learning_model.dart';
import 'package:dev_vault/data/services/learning_service.dart';
import 'package:dev_vault/features/learning/presentation/widgets/learning_skeleton.dart';
import 'package:dev_vault/features/learning/presentation/widgets/learning_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'learning_detail_screen.dart';
import 'learning_form_screen.dart';
import '../widgets/empty_learning_state.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/snackbar_service.dart';

class LearningRoadmapScreen extends StatefulWidget {
  const LearningRoadmapScreen({super.key});

  @override
  State<LearningRoadmapScreen> createState() => _LearningRoadmapScreenState();
}

class _LearningRoadmapScreenState extends State<LearningRoadmapScreen> {
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  List<LearningModel> _learnings = [];
  @override
  void initState() {
    super.initState();
    _loadLearnings();
  }

  Future<void> _loadLearnings() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final data = await LearningService.getAllLearning();

      if (!mounted) return;

      setState(() {
        _learnings = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      SnackBarService.showErrorFromException(context, error: e);
    }
  }

  Future<void> _refreshLearnings() async {
    await _loadLearnings();
  }

  Future<void> _deleteLearning(String id) async {
    try {
      await LearningService.deleteLearning(id);

      await _loadLearnings();

      if (!mounted) return;

      SnackBarService.showSuccess(
        context,
        message: 'Learning deleted successfully',
      );
    } catch (e) {
      if (!mounted) return;

      SnackBarService.showErrorFromException(context, error: e);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<String> categories = const [
    "Flutter",
    "Node.js",
    "System Design",
    "Docker",
  ];
  @override
  Widget build(BuildContext context) {
    final filteredLearnings = _learnings.where((learning) {
      final query = _searchQuery.toLowerCase();

      return learning.title.toLowerCase().contains(query) ||
          learning.des.toLowerCase().contains(query) ||
          learning.category.toLowerCase().contains(query) ||
          learning.priority.toLowerCase().contains(query) ||
          learning.status.toLowerCase().contains(query);
    }).toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _openLearningForm(context),
        icon: const Icon(Icons.add),
        label: const Text("New Roadmap"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Learning roadmap',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'A calm, personal progression plan for your next engineering milestone.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _searchController,
                hintText: "Search roadmap",

                prefixIcon: const Icon(Icons.search),

                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();

                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),

                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: AppSpacing.md),

              Wrap(
                spacing: 0,
                runSpacing: 0,
                children: categories
                    .map(
                      (category) => Chip(
                        label: Text(category),
                        backgroundColor: AppColors.surfaceElevated,
                        side: const BorderSide(color: AppColors.border),
                      ),
                    )
                    .toList(),
              ),

              Expanded(
                child: _isLoading
                    ? const LearningSkeleton()
                    : RefreshIndicator(
                        onRefresh: _refreshLearnings,
                        child: filteredLearnings.isEmpty
                            ? const EmptyLearningState()
                            : ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: filteredLearnings.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: AppSpacing.sm),
                                itemBuilder: (context, index) {
                                  final learning = filteredLearnings[index];

                                  final completed = learning.steps
                                      .where((e) => e.isCompleted)
                                      .length;

                                  final total = learning.steps.length;

                                  final progress = total == 0
                                      ? 0.0
                                      : completed / total;

                                  return LearningTile(
                                    title: learning.title,
                                    description: learning.des,
                                    category: learning.category,
                                    status: learning.status,
                                    priority: learning.priority,
                                    progress: progress,
                                    completedSteps: completed,
                                    totalSteps: total,
                                    targetDate: learning.targetDate,
                                    onTap: () =>
                                        _openLearningDetail(context, learning),
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

  Future<void> _openLearningDetail(
    BuildContext context,
    LearningModel learning,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LearningDetailScreen(
          learning: learning,

          onEdit: (learning) async {
            await _openLearningForm(context, learning: learning);
          },

          onDelete: (id) async {
            await _deleteLearning(id);

            if (!mounted) return;

            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> _openLearningForm(
    BuildContext context, {
    LearningModel? learning,
  }) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => LearningFormScreen(learning: learning)),
    );

    if (result == true) {
      await _loadLearnings();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          content: Text(
            learning == null
                ? "Learning roadmap created successfully"
                : "Learning roadmap updated successfully",
          ),
        ),
      );
    }
  }
}
