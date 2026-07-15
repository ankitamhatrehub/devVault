import 'package:dio/dio.dart';
import '../constant_urls.dart';
import '../models/resume_model.dart';
import 'local_storage_service.dart';

class ResumeService {
  static final Dio _dio = Dio();

  static Map<String, dynamic> _getAuthHeaders() {
    final token = LocalStorageService.getToken();
    return {'Authorization': token != null ? 'Bearer $token' : ''};
  }

  /// Get Resume
  static Future<ResumeModel> getResume() async {
    try {
      print('📡 Fetching Resume');

      final response = await _dio.get(
        getResumeUrl,
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final resume = ResumeModel.fromJson(data['data']);
          print('✅ Resume fetched: ${resume.fileName}');
          return resume;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch resume');
        }
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Error: ${e.message}');
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Update Resume
  static Future<ResumeModel> updateResume({
    required String fileName,
    required String fileUrl,
    required String fileSize,
    required String publicId,
  }) async {
    try {
      print('✏️ Updating Resume: $fileName');

      final response = await _dio.put(
        updateResumeUrl,
        data: {
          'fileName': fileName,
          'fileUrl': fileUrl,
          'fileSize': fileSize,
          'publicId': publicId,
        },
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final resume = ResumeModel.fromJson(data['data']);
          print('✅ Resume updated successfully');
          return resume;
        }

        throw Exception(data['message'] ?? 'Failed to update resume');
      }

      throw Exception('Failed with status ${response.statusCode}');
    } on DioException catch (e) {
      print('❌ Error: ${e.message}');
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Delete Resume
  static Future<void> deleteResume() async {
    try {
      print('🗑️ Deleting Resume');

      final response = await _dio.delete(
        deleteResumeUrl,
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          print('✅ Resume deleted successfully');
        } else {
          throw Exception(data['message'] ?? 'Failed to delete resume');
        }
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Error: ${e.message}');
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Download/Get Resume for download
  static Future<ResumeModel> downloadResume() async {
    try {
      print('📥 Downloading Resume');

      final response = await _dio.get(
        downloadResumeUrl,
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final resume = ResumeModel.fromJson(data['data']);
          print('✅ Resume downloaded: ${resume.fileName}');
          return resume;
        } else {
          throw Exception(data['message'] ?? 'Failed to download resume');
        }
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Error: ${e.message}');
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
