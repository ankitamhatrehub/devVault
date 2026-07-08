import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/pages/login_screen.dart';
import '../../data/models/profile_model.dart';
import '../../features/interview/presentation/pages/interview_questions_screen.dart';
import '../../features/learning/presentation/pages/resources_screen.dart';
import '../../features/main_shell/presentation/pages/main_shell.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/onboarding/presentation/pages/splash_screen.dart';
import '../../features/profile/presentation/pages/edit_profile_screen.dart';
import '../../features/tasks/presentation/pages/tasks_screen.dart';

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
  static const resources = '/resources';
  static const interviewQuestions = '/interview-questions';
  static const mainShell = '/main-shell';
}

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.signup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.otpVerification,
        name: 'otpVerification',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: Routes.resetPassword,
        name: 'resetPassword',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: Routes.changePassword,
        name: 'changePassword',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: Routes.success,
        name: 'success',
        builder: (context, state) => const AuthSuccessScreen(),
      ),
      GoRoute(
        path: Routes.mainShell,
        name: 'mainShell',
        builder: (context, state) => const MainShell(),
      ),
      GoRoute(
        path: Routes.dashboard,
        name: 'dashboard',
        builder: (context, state) => const MainShell(initialIndex: 0),
      ),
      GoRoute(
        path: Routes.projects,
        name: 'projects',
        builder: (context, state) => const MainShell(initialIndex: 1),
      ),
      GoRoute(
        path: Routes.notes,
        name: 'notes',
        builder: (context, state) => const MainShell(initialIndex: 3),
      ),
      GoRoute(
        path: Routes.learning,
        name: 'learning',
        builder: (context, state) => const MainShell(initialIndex: 2),
      ),
      GoRoute(
        path: Routes.profile,
        name: 'profile',
        builder: (context, state) => const MainShell(initialIndex: 4),
      ),
      // GoRoute(
      //   path: Routes.editProfile,
      //   name: 'editProfile',
      //   builder: (context, state) {
      //     final profile = state.extra as Map<String, dynamic>?;
      //     return EditProfileScreen(
      //       profile: profile != null
      //           ? ProfileModel(
      //               id: profile['id']?.toString() ?? '',
      //               name: profile['name']?.toString() ?? '',
      //               email: profile['email']?.toString() ?? '',
      //             )
      //           : ProfileModel(id: '', name: '', email: ''),
      //     );
      //   },
      // ),
      GoRoute(
        path: Routes.resources,
        name: 'resources',
        builder: (context, state) => const ResourcesScreen(),
      ),
      GoRoute(
        path: Routes.interviewQuestions,
        name: 'interviewQuestions',
        builder: (context, state) => const InterviewQuestionsScreen(),
      ),
      GoRoute(
        path: Routes.tasks,
        name: 'tasks',
        builder: (context, state) => const TasksScreen(),
      ),
    ],
  );
}
