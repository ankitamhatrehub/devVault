import 'package:dev_vault/features/authentication/presentation/widgets/login_form.dart';
import 'package:dev_vault/features/authentication/presentation/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageScaffold(
      title: 'Welcome back',
      subtitle: 'Continue to DevVault',
      leadingIcon: Icons.lock_person_outlined,
      child: LoginForm(),
    );
  }
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageScaffold(
      title: 'Create your account',
      subtitle: 'Join DevVault and organize your engineering journey.',
      leadingIcon: Icons.person_add_alt_1_rounded,
      child: SignupForm(),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageScaffold(
      title: 'Reset your password',
      subtitle: 'We will send a one-time code to your email.',
      leadingIcon: Icons.mark_email_read_outlined,
      child: ForgotPasswordForm(),
    );
  }
}

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageScaffold(
      title: 'Verify your code',
      subtitle: 'Enter the six-digit code sent to your inbox.',
      leadingIcon: Icons.verified_user_outlined,
      child: OtpForm(),
    );
  }
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageScaffold(
      title: 'Set a new password',
      subtitle: 'Choose a strong password to keep your account secure.',
      leadingIcon: Icons.password_rounded,
      child: ResetPasswordForm(),
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthPageScaffold(
      title: 'Change password',
      subtitle: 'Keep your credentials current and secure.',
      leadingIcon: Icons.lock_reset_rounded,
      child: ChangePasswordForm(),
    );
  }
}

class AuthSuccessScreen extends StatelessWidget {
  const AuthSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      body: AnimatedGradientBackground(
        compact: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: GlassSurface(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.55, end: 1),
                      duration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 520),
                      curve: Curves.easeOutBack,
                      builder: (context, scale, child) => Transform.scale(
                        scale: scale,
                        child: child,
                      ),
                      child: Semantics(
                        label: 'Success',
                        liveRegion: true,
                        child: ExcludeSemantics(
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(
                                AppRadius.large,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.16,
                                  ),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 48,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('All set', style: theme.textTheme.headlineLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Your account is ready. Jump into your developer dashboard and keep building momentum.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        fullWidth: true,
                        variant: AppButtonVariant.primary,
                        onPressed: () => context.go(Routes.mainShell),
                        child: const Text('Go to dashboard'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: () => context.go(Routes.login),
                      child: const Text('Back to sign in'),
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
