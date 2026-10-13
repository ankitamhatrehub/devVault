import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/onboarding_content.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: BlocBuilder<OnboardingCubit, int>(
            builder: (context, currentPage) {
              final page = onboardingPages[currentPage];

              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.read<OnboardingCubit>().skipToEnd(
                          onboardingPages.length,
                        );
                        _moveToPage(onboardingPages.length - 1, reduceMotion);
                      },
                      child: const Text('Skip'),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: onboardingPages.length,
                      onPageChanged: (value) =>
                          context.read<OnboardingCubit>().setPage(value),
                      itemBuilder: (context, index) {
                        final item = onboardingPages[index];
                        return _OnboardingPage(item: item);
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: currentPage == 0
                              ? const SizedBox.shrink(key: ValueKey('empty'))
                              : TextButton(
                                  key: ValueKey(currentPage),
                                  onPressed: () {
                                    context
                                        .read<OnboardingCubit>()
                                        .previousPage();
                                    _moveToPage(currentPage - 1, reduceMotion);
                                  },
                                  child: const Text('Back'),
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 96,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onboardingPages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: currentPage == index ? 16 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: currentPage == index
                                    ? AppColors.primary
                                    : AppColors.border,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.pill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AppButton(
                            width: 140,
                            onPressed: () {
                              if (currentPage == onboardingPages.length - 1) {
                                context.go(Routes.login);
                              } else {
                                context.read<OnboardingCubit>().nextPage(
                                  onboardingPages.length,
                                );
                                _moveToPage(currentPage + 1, reduceMotion);
                              }
                            },
                            child: Text(
                              currentPage == onboardingPages.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AnimatedSwitcher(
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(0, 0.08),
                            end: Offset.zero,
                          ),
                        ),
                        child: child,
                      ),
                    ),
                    child: Column(
                      key: ValueKey(currentPage),
                      children: [
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          child: Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        ),
      ),
    );
  }

  void _moveToPage(int page, bool reduceMotion) {
    if (reduceMotion) {
      _pageController.jumpToPage(page);
    } else {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.item});

  final OnboardingPageModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.94, end: 1),
            duration: MediaQuery.of(context).disableAnimations
                ? Duration.zero
                : const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) => Transform.scale(
              scale: scale,
              child: child,
            ),
            child: GlassSurface(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.large),
                child: Image.asset(
                  item.imagePath,
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                  semanticLabel: item.imageDescription,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
