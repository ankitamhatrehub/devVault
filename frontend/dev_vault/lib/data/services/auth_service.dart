import 'package:dio/dio.dart';
import '../constant_urls.dart';
import '../models/profile_model.dart';
import 'local_storage_service.dart';

class AuthService {
  static final Dio _dio = Dio();

  /// Initialize Dio client with token from local storage
  static void initializeDio() {
    final token = LocalStorageService.getToken();
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  /// Update Dio headers with new token
  static void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Validates email format
  static bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  /// Validates password strength
  static bool _isValidPassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

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
    // Validate inputs
    if (name.trim().isEmpty || name.trim().length < 2) {
      throw Exception('Name must be at least 2 characters');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Please enter a valid email address');
    }

    if (!_isValidPassword(password)) {
      throw Exception('Password must be at least 6 characters');
    }

    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    try {
      final response = await _dio.post(
        registerUrl,
        data: {
          'name': name.trim(),
          'email': email.trim(),
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
      if (e.response?.data != null) {
        final errorMessage = e.response?.data['message'] ?? e.message;
        throw Exception(errorMessage);
      }
      throw Exception('Registration error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
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
    // Validate inputs
    if (email.trim().isEmpty) {
      throw Exception('Email is required');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Please enter a valid email address');
    }

    if (password.isEmpty) {
      throw Exception('Password is required');
    }

    if (!_isValidPassword(password)) {
      throw Exception('Password must be at least 6 characters');
    }

    try {
      final response = await _dio.post(
        loginUrl,
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final user = data['data']['user'];
          final accessToken = data['data']['accessToken'];

          // Validate response data
          if (user == null || accessToken == null) {
            throw Exception('Invalid response from server');
          }

          // Set auth token in Dio headers for future requests
          setAuthToken(accessToken);

          return {
            'success': true,
            'message': data['message'] ?? 'Login successful',
            'user': ProfileModel.fromJson(user),
            'accessToken': accessToken,
          };
        } else {
          throw Exception(data['message'] ?? 'Login failed');
        }
      } else {
        throw Exception('Login failed with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorMessage = e.response?.data['message'] ?? e.message;
        throw Exception(errorMessage);
      }
      throw Exception('Login error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Logout user (clear local session and stored data)
  static Future<void> logout() async {
    // Clear token from Dio headers
    _dio.options.headers.remove('Authorization');

    // Clear all auth data from local storage
    await LocalStorageService.clearAuthData();
  }
}
