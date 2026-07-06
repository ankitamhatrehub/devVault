import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock_outline_rounded),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.push(Routes.forgotPassword),
            child: const Text('Forgot password?'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            fullWidth: true,
            onPressed: () => context.go(Routes.mainShell),
            child: const Text('Sign in'),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('New to DevVault?'),
            TextButton(
              onPressed: () => context.go(Routes.signup),
              child: const Text('Create account'),
            ),
          ],
        ),
      ],
    );
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          labelText: 'Full name',
          prefixIcon: const Icon(Icons.person_outline_rounded),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          labelText: 'Work email',
          prefixIcon: const Icon(Icons.email_outlined),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          labelText: 'Password',
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          labelText: 'Confirm password',
          prefixIcon: const Icon(Icons.lock_reset_rounded),
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            fullWidth: true,
            onPressed: () => context.go(Routes.success),
            child: const Text('Create account'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account?'),
            TextButton(
              onPressed: () => context.go(Routes.login),
              child: const Text('Sign in'),
            ),
          ],
        ),
      ],
    );
  }
}

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          labelText: 'Email',
          prefixIcon: const Icon(Icons.email_outlined),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            fullWidth: true,
            onPressed: () => context.go(Routes.otpVerification),
            child: const Text('Send code'),
          ),
        ),
      ],
    );
  }
}

class OtpForm extends StatelessWidget {
  const OtpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (index) => SizedBox(
              width: 44,
              child: AppTextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                counterText: '',
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            fullWidth: true,
            onPressed: () => context.go(Routes.resetPassword),
            child: const Text('Verify code'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: () => context.go(Routes.forgotPassword),
          child: const Text('Resend code'),
        ),
      ],
    );
  }
}

class ResetPasswordForm extends StatelessWidget {
  const ResetPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          labelText: 'New password',
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          labelText: 'Confirm new password',
          prefixIcon: const Icon(Icons.lock_reset_rounded),
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            fullWidth: true,
            onPressed: () => context.go(Routes.success),
            child: const Text('Update password'),
          ),
        ),
      ],
    );
  }
}

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          labelText: 'Current password',
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          labelText: 'New password',
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          labelText: 'Confirm password',
          prefixIcon: const Icon(Icons.lock_reset_rounded),
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            fullWidth: true,
            onPressed: () => context.go(Routes.success),
            child: const Text('Save changes'),
          ),
        ),
      ],
    );
  }
}
