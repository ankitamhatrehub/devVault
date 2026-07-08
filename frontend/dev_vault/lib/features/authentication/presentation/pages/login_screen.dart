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
      child: ChangePasswordForm(),
    );
  }
}

class AuthSuccessScreen extends StatelessWidget {
  const AuthSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('All set', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your account is ready. Jump into your developer dashboard and keep building momentum.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    );
  }
}
