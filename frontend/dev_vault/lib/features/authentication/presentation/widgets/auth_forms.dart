import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';

// Login and Signup forms are now in separate files:
// - login_form.dart (LoginForm)
// - register_form.dart (SignupForm)

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
