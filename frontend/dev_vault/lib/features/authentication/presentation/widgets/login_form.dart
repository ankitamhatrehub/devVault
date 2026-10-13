import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../data/services/local_storage_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isButtonPressed = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
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

  void _showErrorSnackBar(String message) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
   
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
   
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleLogin() async {
    print('🔐 ============ LOGIN PROCESS STARTED ============');

    // Validate email
    final emailError = _validateEmail(_emailController.text);
    if (emailError != null) {
      print('❌ Email Validation Error: $emailError');
      _showErrorSnackBar(emailError);
      return;
    }
    print('✅ Email Validation Passed: ${_emailController.text}');

    // Validate password
    final passwordError = _validatePassword(_passwordController.text);
    if (passwordError != null) {
      print('❌ Password Validation Error: $passwordError');
      _showErrorSnackBar(passwordError);
      return;
    }
    print('✅ Password Validation Passed');

    setState(() {
      _isLoading = true;
    });
    print('⏳ Loading state set to true');

    try {
      print('📡 Making API call to login endpoint...');
      final result = await AuthService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      print('📥 API Response Received:');
      print('   Success: ${result['success']}');
      print('   Message: ${result['message']}');

      if (mounted) {
        if (result['success'] == true) {
          print('✅ Login Successful!');

          // Extract user and token from result
          final user = result['user'];
          final accessToken = result['accessToken'] as String? ?? '';

          print('👤 User Data:');
          print('   User ID: ${user?.id}');
          print('   User Name: ${user?.name}');
          print('   User Email: ${user?.email}');
          print('🔑 Access Token: ${accessToken.substring(0, 20)}...');

          // Store token and user data in local storage
          if (user != null && accessToken.isNotEmpty) {
            print('💾 Storing user data in Local Storage...');
            await LocalStorageService.saveUserData(
              userId: user.id,
              token: accessToken,
              email: user.email,
              name: user.name,
            );
            print('✅ User data stored successfully!');
            print('   Stored User ID: ${LocalStorageService.getUserId()}');
            print('   Stored Email: ${LocalStorageService.getUserEmail()}');
            print('   Is Logged In: ${LocalStorageService.isLoggedIn()}');
          }

          _showSuccessSnackBar(result['message'] ?? 'Login successful');

          // Navigate to dashboard after a short delay
          print('🚀 Navigating to dashboard...');
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              print('🔀 Redirecting to: ${Routes.mainShell}');
              context.go(Routes.mainShell);
            }
          });
        } else {
          print('❌ Login Failed: ${result['message']}');
          _showErrorSnackBar(result['message'] ?? 'Login failed');
        }
      }
    } catch (e) {
      print('❌ Exception Caught During Login:');
      print('   Error: $e');
      print('   Error Type: ${e.runtimeType}');
      if (mounted) {
        _showErrorSnackBar(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print('⏳ Loading state set to false');
      }
      print('🔐 ============ LOGIN PROCESS ENDED ============\n');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Column(
      children: [
        AnimatedContainer(
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 180),
          decoration: _fieldDecoration(
            theme,
            colorScheme,
            focused: _emailFocusNode.hasFocus,
          ),
          child: TextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            decoration: _inputDecoration(
              theme,
              colorScheme,
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AnimatedContainer(
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 180),
          decoration: _fieldDecoration(
            theme,
            colorScheme,
            focused: _passwordFocusNode.hasFocus,
          ),
          child: TextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            onSubmitted: (_) => _handleLogin(),
            decoration: _inputDecoration(
              theme,
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
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: !_isLoading
                ? () => context.push(Routes.forgotPassword)
                : null,
            child: const Text('Forgot password?'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Listener(
          onPointerDown: _isLoading
              ? null
              : (_) => setState(() => _isButtonPressed = true),
          onPointerUp: (_) => setState(() => _isButtonPressed = false),
          onPointerCancel: (_) => setState(() => _isButtonPressed = false),
          child: AnimatedScale(
            scale: _isButtonPressed ? 0.985 : 1,
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 100),
            child: AppButton(
              fullWidth: true,
              onPressed: _isLoading ? null : _handleLogin,
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
                    : const Text('Sign in', key: ValueKey('sign-in')),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('New to DevVault?'),
            TextButton(
              onPressed: !_isLoading ? () => context.go(Routes.signup) : null,
              child: const Text('Create account'),
            ),
          ],
        ),
      ],
    );
  }

  BoxDecoration _fieldDecoration(
    ThemeData theme,
    ColorScheme colorScheme, {
    required bool focused,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      boxShadow: focused
          ? [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.14),
                blurRadius: 16,
                spreadRadius: 1,
              ),
            ]
          : const [],
    );
  }

  InputDecoration _inputDecoration(
    ThemeData theme,
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
