import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';

class LearningRoadmapScreen extends StatelessWidget {
  const LearningRoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['Flutter', 'System Design', 'Node.js', 'Docker'];
    final topics = [
      _TopicItem(
        title: 'Flutter architecture',
        subtitle: 'State management, routing, and clean structure',
        progress: 0.82,
        completed: 9,
        total: 11,
      ),
      _TopicItem(
        title: 'Node.js APIs',
        subtitle: 'Authentication, middleware, and deployment basics',
        progress: 0.63,
        completed: 5,
        total: 8,
      ),
      _TopicItem(
        title: 'System design',
        subtitle: 'Scalability patterns and trade-offs',
        progress: 0.47,
        completed: 4,
        total: 9,
      ),
    ];

    return Scaffold(
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
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekly focus',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Finish the Flutter architecture module and schedule a mock interview.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
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
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(Routes.resources),
                      icon: const Icon(Icons.library_books_rounded),
                      label: const Text('View resources'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(Routes.interviewQuestions),
                      icon: const Icon(Icons.quiz_outlined),
                      label: const Text('Interview prep'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView.separated(
                  itemCount: topics.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    return Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  topic.title,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              Text(
                                '${(topic.progress * 100).round()}%',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            topic.subtitle,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            child: LinearProgressIndicator(
                              value: topic.progress,
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '${topic.completed}/${topic.total} completed',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicItem {
  const _TopicItem({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.completed,
    required this.total,
  });

  final String title;
  final String subtitle;
  final double progress;
  final int completed;
  final int total;
}
