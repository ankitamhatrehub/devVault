import 'package:dio/dio.dart';
import '../constant_urls.dart';
import '../models/profile_model.dart';
import 'local_storage_service.dart';

class ProfileService {
  static final Dio _dio = Dio();

  /// Get authorization headers with stored token
  static Map<String, dynamic> _getAuthHeaders() {
    final token = LocalStorageService.getToken();
    print('🔑 Token from LocalStorage: ${token?.substring(0, 20)}...');
    return {'Authorization': token != null ? 'Bearer $token' : ''};
  }

  /// Get user profile
  /// Returns ProfileModel with all user data
  /// Throws Exception on failure
  static Future<ProfileModel> getProfile() async {
    try {
      print('📡 Fetching profile from: $getProfileUrl');
      print('🔑 Using stored token for authentication');

      final response = await _dio.get(
        getProfileUrl,
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final profile = ProfileModel.fromJson(
            data['data']['user'] ?? data['data'],
          );
          print('✅ Profile fetched successfully');
          print('   Name: ${profile.name}');
          print('   Email: ${profile.email}');
          return profile;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch profile');
        }
      } else {
        throw Exception(
          'Failed to fetch profile with status ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      if (e.response?.data != null) {
        final errorMessage = e.response?.data['message'] ?? e.message;
        throw Exception(errorMessage);
      }
      throw Exception('Error fetching profile: ${e.message}');
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception(e.toString());
    }
  }

  /// Update user profile
  /// Takes name and email as parameters
  /// Returns updated ProfileModel
  /// Throws Exception on failure
  static Future<ProfileModel> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      print('📡 Updating profile at: $editProfileUrl');
      print('   Name: $name');
      print('   Email: $email');
      print('🔑 Using stored token for authentication');

      final response = await _dio.put(
        editProfileUrl,
        data: {'name': name, 'email': email},
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final profile = ProfileModel.fromJson(
            data['data']['user'] ?? data['data'],
          );
          print('✅ Profile updated successfully');
          print('   Updated Name: ${profile.name}');
          print('   Updated Email: ${profile.email}');
          return profile;
        } else {
          throw Exception(data['message'] ?? 'Failed to update profile');
        }
      } else {
        throw Exception(
          'Failed to update profile with status ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      if (e.response?.data != null) {
        final errorMessage = e.response?.data['message'] ?? e.message;
        throw Exception(errorMessage);
      }
      throw Exception('Error updating profile: ${e.message}');
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception(e.toString());
    }
  }

  /// Get stored user ID
  static String? getStoredUserId() {
    return LocalStorageService.getUserId();
  }

  /// Get stored user email
  static String? getStoredEmail() {
    return LocalStorageService.getUserEmail();
  }

  /// Get stored user name
  static String? getStoredName() {
    return LocalStorageService.getUserName();
  }
}
