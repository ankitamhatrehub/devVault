import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/pages/login_screen.dart';
import '../../data/models/profile_model.dart';
import '../../features/interview/presentation/pages/interview_questions_screen.dart';
import '../../features/learning/presentation/pages/resources_screen.dart';
import '../../features/main_shell/presentation/pages/main_shell.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/onboarding/presentation/pages/splash_screen.dart';
import '../../features/profile/presentation/pages/edit_profile_screen.dart';
import '../../features/resume/presentation/pages/resume_screen.dart';
import '../../features/tasks/presentation/pages/tasks_screen.dart';
import '../theme/theme_preview_screen.dart';

class Routes {
  Routes._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const otpVerification = '/otp-verification';
  static const resetPassword = '/reset-password';
  static const changePassword = '/change-password';
  static const success = '/success';
  static const dashboard = '/dashboard';
  static const projects = '/projects';
  static const notes = '/notes';
  static const tasks = '/tasks';
  static const learning = '/learning';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const resume = '/resume';
  static const resources = '/resources';
  static const interviewQuestions = '/interview-questions';
  static const mainShell = '/main-shell';
  static const themePreview = '/theme-preview';
}

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        name: 'splash',
        pageBuilder: (context, state) =>
            _transitionPage(state, const SplashScreen()),
      ),
      GoRoute(
        path: Routes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) =>
            _transitionPage(state, const OnboardingScreen()),
      ),
      GoRoute(
        path: Routes.login,
        name: 'login',
        pageBuilder: (context, state) =>
            _transitionPage(state, const LoginScreen()),
      ),
      GoRoute(
        path: Routes.signup,
        name: 'signup',
        pageBuilder: (context, state) =>
            _transitionPage(state, const SignupScreen()),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) =>
            _transitionPage(state, const ForgotPasswordScreen()),
      ),
      GoRoute(
        path: Routes.otpVerification,
        name: 'otpVerification',
        pageBuilder: (context, state) =>
            _transitionPage(state, const OtpVerificationScreen()),
      ),
      GoRoute(
        path: Routes.resetPassword,
        name: 'resetPassword',
        pageBuilder: (context, state) =>
            _transitionPage(state, const ResetPasswordScreen()),
      ),
      GoRoute(
        path: Routes.changePassword,
        name: 'changePassword',
        pageBuilder: (context, state) =>
            _transitionPage(state, const ChangePasswordScreen()),
      ),
      GoRoute(
        path: Routes.success,
        name: 'success',
        pageBuilder: (context, state) =>
            _transitionPage(state, const AuthSuccessScreen()),
      ),
      GoRoute(
        path: Routes.mainShell,
        name: 'mainShell',
        pageBuilder: (context, state) =>
            _transitionPage(state, const MainShell()),
      ),
      GoRoute(
        path: Routes.themePreview,
        name: 'themePreview',
        pageBuilder: (context, state) =>
            _transitionPage(state, const ThemePreviewScreen()),
      ),
      GoRoute(
        path: Routes.dashboard,
        name: 'dashboard',
        pageBuilder: (context, state) =>
            _transitionPage(state, const MainShell(initialIndex: 0)),
      ),
      GoRoute(
        path: Routes.projects,
        name: 'projects',
        pageBuilder: (context, state) =>
            _transitionPage(state, const MainShell(initialIndex: 1)),
      ),
      GoRoute(
        path: Routes.notes,
        name: 'notes',
        pageBuilder: (context, state) =>
            _transitionPage(state, const MainShell(initialIndex: 3)),
      ),
      GoRoute(
        path: Routes.learning,
        name: 'learning',
        pageBuilder: (context, state) =>
            _transitionPage(state, const MainShell(initialIndex: 2)),
      ),
      GoRoute(
        path: Routes.profile,
        name: 'profile',
        pageBuilder: (context, state) =>
            _transitionPage(state, const MainShell(initialIndex: 4)),
      ),
      GoRoute(
        path: Routes.editProfile,
        name: 'editProfile',
        pageBuilder: (context, state) {
          print("edit profile screen openinhg");
          final profile = state.extra as ProfileModel?;
          if (profile == null) {
            return _transitionPage(
              state,
              Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(child: Text('Profile data not found')),
              ),
            );
          }
          return _transitionPage(state, EditProfileScreen());
        },
      ),
      GoRoute(
        path: Routes.resources,
        name: 'resources',
        pageBuilder: (context, state) =>
            _transitionPage(state, const ResourcesScreen()),
      ),
      GoRoute(
        path: Routes.interviewQuestions,
        name: 'interviewQuestions',
        pageBuilder: (context, state) =>
            _transitionPage(state, const InterviewQuestionsScreen()),
      ),
      GoRoute(
        path: Routes.tasks,
        name: 'tasks',
        pageBuilder: (context, state) =>
            _transitionPage(state, const TasksScreen()),
      ),
      GoRoute(
        path: Routes.resume,
        name: 'resume',
        pageBuilder: (context, state) =>
            _transitionPage(state, const ResumeScreen()),
      ),
    ],
  );
}

CustomTransitionPage<void> _transitionPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.of(context).disableAnimations) return child;

      final curvedAnimation = animation.drive(
        CurveTween(curve: Curves.easeOutCubic),
      );
      final slideAnimation = animation.drive(
        Tween<Offset>(
          begin: const Offset(0.025, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
      );
      final scaleAnimation = animation.drive(
        Tween<double>(
          begin: 0.985,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        ),
      );
    },
  );
}
