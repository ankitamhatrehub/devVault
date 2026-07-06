import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class InterviewQuestionsScreen extends StatelessWidget {
  const InterviewQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final questions = [
      _QuestionItem(
        title: 'How would you design a scalable notification service?',
        difficulty: 'Medium',
        status: 'Bookmarked',
      ),
      _QuestionItem(
        title: 'Explain the difference between stateful and stateless systems.',
        difficulty: 'Easy',
        status: 'Solved',
      ),
      _QuestionItem(
        title: 'How do you optimize a Flutter app for smooth scrolling?',
        difficulty: 'Medium',
        status: 'Revision',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Questions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Practice questions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Practice the questions that matter most for your current target role.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ListView.separated(
                  itemCount: questions.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final question = questions[index];
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
                                  question.title,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySoft,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.pill,
                                  ),
                                ),
                                child: Text(
                                  question.difficulty,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            question.status,
                            style: Theme.of(context).textTheme.bodyMedium
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

class _QuestionItem {
  const _QuestionItem({
    required this.title,
    required this.difficulty,
    required this.status,
  });

  final String title;
  final String difficulty;
  final String status;
}
