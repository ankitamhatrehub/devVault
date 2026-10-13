import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/services/auth_service.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_handleFocusChange);
    _emailFocusNode.addListener(_handleFocusChange);
    _passwordFocusNode.addListener(_handleFocusChange);
    _confirmPasswordFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _nameFocusNode.removeListener(_handleFocusChange);
    _emailFocusNode.removeListener(_handleFocusChange);
    _passwordFocusNode.removeListener(_handleFocusChange);
    _confirmPasswordFocusNode.removeListener(_handleFocusChange);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) setState(() {});
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _showErrorSnackBar(String message) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: colorScheme.error),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: colorScheme.onInverseSurface),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.inverseSurface,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: colorScheme.onInverseSurface),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.inverseSurface,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleRegister() async {
    // Validate all fields
    final nameError = _validateName(_nameController.text);
    final emailError = _validateEmail(_emailController.text);
    final passwordError = _validatePassword(_passwordController.text);
    final confirmPasswordError = _validateConfirmPassword(
      _confirmPasswordController.text,
    );

    // Show first error found
    if (nameError != null) {
      _showErrorSnackBar(nameError);
      return;
    }
    if (emailError != null) {
      _showErrorSnackBar(emailError);
      return;
    }
    if (passwordError != null) {
      _showErrorSnackBar(passwordError);
      return;
    }
    if (confirmPasswordError != null) {
      _showErrorSnackBar(confirmPasswordError);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (mounted) {
        if (result['success'] == true) {
          _showSuccessSnackBar(result['message'] ?? 'Registration successful');
          // Navigate directly to login screen
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              context.go(Routes.login);
            }
          });
        } else {
          _showErrorSnackBar(result['message'] ?? 'Registration failed');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return StaggeredColumn(
      spacing: AppSpacing.md,
      children: [
        _animatedField(
          context,
          focusNode: _nameFocusNode,
          child: TextField(
            controller: _nameController,
            focusNode: _nameFocusNode,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            decoration: _inputDecoration(
              colorScheme,
              labelText: 'Full name',
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
          ),
        ),
        _animatedField(
          context,
          focusNode: _emailFocusNode,
          child: TextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            decoration: _inputDecoration(
              colorScheme,
              labelText: 'Work email',
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ),
        ),
        _animatedField(
          context,
          focusNode: _passwordFocusNode,
          child: TextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            decoration: _inputDecoration(
              colorScheme,
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                icon: AnimatedSwitcher(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    key: ValueKey(_obscurePassword),
                  ),
                ),
                onPressed: _isLoading
                    ? null
                    : () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }),
              ),
            ),
          ),
        ),
        _animatedField(
          context,
          focusNode: _confirmPasswordFocusNode,
          child: TextField(
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            onSubmitted: (_) => _handleRegister(),
            decoration: _inputDecoration(
              colorScheme,
              labelText: 'Confirm password',
              prefixIcon: const Icon(Icons.lock_reset_rounded),
              suffixIcon: IconButton(
                tooltip: _obscureConfirmPassword
                    ? 'Show password'
                    : 'Hide password',
                icon: AnimatedSwitcher(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    key: ValueKey(_obscureConfirmPassword),
                  ),
                ),
                onPressed: _isLoading
                    ? null
                    : () => setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      }),
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            fullWidth: true,
            onPressed: _isLoading ? null : _handleRegister,
            child: AnimatedSwitcher(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              child: _isLoading
                  ? SizedBox(
                      key: const ValueKey('loading'),
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Text(
                      'Create account',
                      key: ValueKey('create-account'),
                    ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account?'),
            TextButton(
              onPressed: !_isLoading ? () => context.go(Routes.login) : null,
              child: const Text('Sign in'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _animatedField(
    BuildContext context, {
    required FocusNode focusNode,
    required Widget child,
  }) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: focusNode.hasFocus
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.14),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ]
            : const [],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(
    ColorScheme colorScheme, {
    required String labelText,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    final radius = BorderRadius.circular(AppRadius.medium);

    return InputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.58),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
    );
  }
}
