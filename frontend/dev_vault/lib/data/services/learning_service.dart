import 'package:dio/dio.dart';
import '../constant_urls.dart';
import '../models/learning_model.dart';
import 'local_storage_service.dart';

class LearningService {
  static final Dio _dio = Dio();

  static Map<String, dynamic> _getAuthHeaders() {
    final token = LocalStorageService.getToken();
    return {'Authorization': token != null ? 'Bearer $token' : ''};
  }

  /// Get all Learning
  static Future<List<LearningModel>> getAllLearning() async {
    try {
      print('📡 Fetching all Learning from: $getAllLearningsUrl');

      final response = await _dio.get(
        getAllLearningsUrl,
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final LearningList = (data['data'] as List)
              .map((Learning) => LearningModel.fromJson(Learning))
              .toList();
          print('✅ Learning fetched: ${LearningList.length} total');
          return LearningList;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch Learning');
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

  /// Get Learning by ID
  static Future<LearningModel> getLearningById(String id) async {
    try {
      print('📡 Fetching Learning: $id');

      final response = await _dio.get(
        '$getLearningByIdUrl$id',
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final Learning = LearningModel.fromJson(data['data']);
          print('✅ Learning fetched: ${Learning.title}');
          return Learning;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch Learning');
        }
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Create Learning
 /// Create Learning
  static Future<LearningModel> createLearning({
    required String title,
    required String des,
    required String category,
    required String status,
    required String priority,
    required String startDate,
    required String targetDate,
    required List<LearningStepModel> steps,
  }) async {
    try {
      print('📝 Creating Learning: $title');

      final response = await _dio.post(
        createLearningUrl,
        data: {
          'title': title,
          'des': des,
          'category': category,
          'status': status,
          'priority': priority,
          'startDate': startDate,
          'targetDate': targetDate,
          'steps': steps.map((e) => e.toJson()).toList(),
        },
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          return LearningModel.fromJson(data['data']);
        }

        throw Exception(data['message'] ?? 'Failed to create Learning');
      }

      throw Exception('Failed with status ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Update Learning
/// Update Learning
  static Future<LearningModel> updateLearning({
    required String id,
    required String title,
    required String des,
    required String category,
    required String status,
    required String priority,
    required String startDate,
    required String targetDate,
    required List<LearningStepModel> steps,
  }) async {
    try {
      print('✏️ Updating Learning: $id');

      final response = await _dio.put(
        '$updateLearningUrl$id',
        data: {
          'title': title,
          'des': des,
          'category': category,
          'status': status,
          'priority': priority,
          'startDate': startDate,
          'targetDate': targetDate,
          'steps': steps.map((e) => e.toJson()).toList(),
        },
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          return LearningModel.fromJson(data['data']);
        }

        throw Exception(data['message'] ?? 'Failed to update Learning');
      }

      throw Exception('Failed with status ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Delete Learning
  static Future<void> deleteLearning(String id) async {
    try {
      print('🗑️ Deleting Learning: $id');

      final response = await _dio.delete(
        '$deleteLearningUrl$id',
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          print('✅ Learning deleted');
        } else {
          throw Exception(data['message'] ?? 'Failed to delete Learning');
        }
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
