import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';

class AuthPageScaffold extends StatelessWidget {
  const AuthPageScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
    this.leadingIcon,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showExitDialog(context);
        if (shouldExit) SystemNavigator.pop();
      },
      child: AnimatedGradientBackground(
        compact: true,
        child: Scaffold(
          backgroundColor: theme.colorScheme.surface.withValues(alpha: 0),
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface.withValues(alpha: 0),
            surfaceTintColor: theme.colorScheme.surface.withValues(alpha: 0),
            elevation: 0,
            leading: IconButton(
              onPressed: () async {
                if (Navigator.of(context).canPop()) {
                  context.pop();
                } else {
                  final shouldExit = await _showExitDialog(context);
                  if (shouldExit) SystemNavigator.pop();
                }
              },
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 420),
                curve: Curves.easeOutCubic,
                builder: (context, progress, child) => Opacity(
                  opacity: progress,
                  child: Transform.translate(
                    offset: Offset(0, (1 - progress) * 14),
                    child: child,
                  ),
                ),
                child: GlassSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (leadingIcon != null) ...[
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(
                              AppRadius.medium,
                            ),
                          ),
                          child: Icon(
                            leadingIcon,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      Text(title, style: theme.textTheme.headlineLarge),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      child,
                    ],
                  ),
                ),
              ),
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
