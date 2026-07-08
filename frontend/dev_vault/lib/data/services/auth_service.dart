import 'package:dio/dio.dart';
import '../constant_urls.dart';
import '../models/profile_model.dart';

class AuthService {
  static final Dio _dio = Dio();

  /// Register a new user
  ///
  /// Takes [name], [email], [password], [confirmPassword] as parameters
  /// Returns ProfileModel on success
  /// Throws Exception on failure
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _dio.post(
        registerUrl,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          return {
            'success': true,
            'message': data['message'] ?? 'Registration successful',
            'user': ProfileModel.fromJson(data['data']['user'] ?? {}),
          };
        } else {
          throw Exception(data['message'] ?? 'Registration failed');
        }
      } else {
        throw Exception('Registration failed with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Registration error: ${e.message}');
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  /// Login user with email and password
  ///
  /// Takes [email] and [password] as parameters
  /// Returns map with user ProfileModel and accessToken on success
  /// Throws Exception on failure
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Validate email format
      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      if (!emailRegex.hasMatch(email)) {
        throw Exception('Please enter a valid email address');
      }

      // Validate password
      if (password.isEmpty) {
        throw Exception('Please enter your password');
      }

      final response = await _dio.post(
        loginUrl,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          return {
            'success': true,
            'message': data['message'] ?? 'Login successful',
            'user': ProfileModel.fromJson(data['data']['user'] ?? {}),
            'accessToken': data['data']['accessToken'] ?? '',
          };
        } else {
          throw Exception(data['message'] ?? 'Login failed');
        }
      } else {
        throw Exception('Login failed with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Login error: ${e.message}');
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  /// Logout user (clear local session)
  /// This is a client-side operation
  static Future<void> logout() async {
    // TODO: Clear local storage/shared preferences
    // Remove stored token, user data, etc.
  }
}
