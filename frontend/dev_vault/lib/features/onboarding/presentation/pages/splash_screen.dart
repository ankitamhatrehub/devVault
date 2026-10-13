import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/services/local_storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _taglineAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ).drive(Tween<double>(begin: 0.9, end: 1));
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ).drive(Tween<double>(begin: 0.2, end: 1));
    _taglineAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 1, curve: Curves.easeOutCubic),
    ).drive(Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero));

    _navigationTimer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        final isLoggedIn = LocalStorageService.isLoggedIn();
        if (isLoggedIn) {
          context.go(Routes.dashboard);
        } else {
          context.go(Routes.onboarding);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
    } else if (!_controller.isAnimating && _controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(scale: _scaleAnimation, child: child),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.large),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(
                                alpha: reduceMotion
                                    ? 0.16
                                    : 0.1 + _controller.value * 0.12,
                              ),
                              blurRadius: reduceMotion
                                  ? 20
                                  : 18 + _controller.value * 12,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: child,
                      ),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppRadius.large),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.lock_open_rounded,
                          size: 36,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'DevVault',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SlideTransition(
                      position: _taglineAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'One Place. Every Developer\'s Journey.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: 180,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: const LinearProgressIndicator(minHeight: 6),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Version 1.0.0',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
