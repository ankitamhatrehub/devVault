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
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade600,
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
    return Column(
      children: [
        // Email Field
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          enabled: !_isLoading,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Password Field
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          enabled: !_isLoading,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Forgot Password Link
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

        // Sign In Button
        SizedBox(
          width: double.infinity,
          child: AppButton(
            fullWidth: true,
            onPressed: _isLoading ? null : _handleLogin,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Sign in'),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Sign Up Link
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
}
