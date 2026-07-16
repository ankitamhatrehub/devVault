import 'dart:io';
import 'dart:convert';
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

  /// Download Resume File as bytes (actual PDF file from backend)
  static Future<List<int>> downloadResumeFile() async {
    try {
      print('📥 [1/4] Starting resume file download...');
      print('📥 URL: $downloadResumeUrl');

      final headers = _getAuthHeaders();
      print('📥 [2/4] Auth headers prepared');
      final authValue = headers['Authorization'] ?? '';
      print('📥 Authorization: ${authValue.isNotEmpty ? authValue.substring(0, 20) + '...' : 'EMPTY'}');

      final response = await _dio.get(
        downloadResumeUrl,
        options: Options(
          headers: headers,
          responseType: ResponseType.bytes,
        ),
      );

      print('📥 [3/4] Response received');
      print('📥 Status code: ${response.statusCode}');
      print('📥 Content type: ${response.headers['content-type']}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bytes = response.data as List<int>;
        print('✅ [4/4] Resume file downloaded successfully - ${bytes.length} bytes');
        return bytes;
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ DioException occurred');
      print('❌ Message: ${e.message}');
      print('❌ Type: ${e.type}');
      print('❌ Status code: ${e.response?.statusCode}');

      String errorMessage = e.message ?? 'Unknown error';

      if (e.response?.data != null) {
        try {
          final responseData = e.response!.data;
          print('❌ Response data type: ${responseData.runtimeType}');
          print('❌ Response data: $responseData');

          // If response is bytes, decode to string then parse JSON
          if (responseData is List<int>) {
            final decodedString = utf8.decode(responseData);
            print('❌ Decoded response: $decodedString');
            final jsonData = jsonDecode(decodedString);
            errorMessage = jsonData['message'] ?? errorMessage;
          } else if (responseData is Map) {
            errorMessage = responseData['message'] ?? errorMessage;
          }
        } catch (parseError) {
          print('❌ Could not parse error response: $parseError');
        }
      }

      throw Exception(errorMessage);
    } catch (e) {
      print('❌ Unexpected error: $e');
      print('❌ Error type: ${e.runtimeType}');
      throw Exception(e.toString());
    }
  }

  /// Upload Resume File to Backend (which uploads to Cloudinary)
  static Future<ResumeModel> uploadResumeFile(File resumeFile) async {
    try {
      print('📤 Uploading resume to backend...');

      // Create FormData with file
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          resumeFile.path,
          filename: resumeFile.path.split('/').last,
        ),
      });

      // Send to backend upload endpoint
      final response = await _dio.post(
        uploadResumeUrl,
        data: formData,
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final resume = ResumeModel.fromJson(data['data']);
          print('✅ Resume uploaded successfully to backend');
          return resume;
        }

        throw Exception(data['message'] ?? 'Failed to upload resume');
      }

      throw Exception('Failed with status ${response.statusCode}');
    } on DioException catch (e) {
      print('❌ Error: ${e.message}');
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
