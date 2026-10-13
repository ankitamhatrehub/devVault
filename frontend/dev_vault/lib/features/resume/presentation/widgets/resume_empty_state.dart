import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';

class ResumeEmptyState extends StatelessWidget {
  final VoidCallback onUpload;

  const ResumeEmptyState({required this.onUpload, super.key});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return SingleChildScrollView(
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: reduceMotion ? 1 : 0.9, end: 1),
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          builder: (context, scale, child) =>
              Transform.scale(scale: scale, child: child),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.description_outlined,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'No Resume Uploaded',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Upload your latest resume so recruiters\ncan quickly review your profile.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              GlassSurface(
                padding: const EdgeInsets.all(AppSpacing.md),
                borderRadius: AppRadius.medium,
                child: Column(
                  children: [
                     Text(
                      'Supported Format',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Text('✔ PDF'),
                    const SizedBox(height: AppSpacing.md),
                     Divider(color: AppColors.border),
                    const SizedBox(height: AppSpacing.md),
                     Text(
                      'Maximum Size',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Text('✔ 5 MB'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: onUpload,
                icon: const Icon(Icons.upload_file_rounded),
                label: const Text('Upload Resume'),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
