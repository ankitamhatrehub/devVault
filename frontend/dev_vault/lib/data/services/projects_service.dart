import 'package:dio/dio.dart';
import '../constant_urls.dart';
import '../models/projects_model.dart';
import 'local_storage_service.dart';

class ProjectsService {
  static final Dio _dio = Dio();

  static Map<String, dynamic> _getAuthHeaders() {
    final token = LocalStorageService.getToken();
    return {'Authorization': token != null ? 'Bearer $token' : ''};
  }

  /// Get all projects
  static Future<List<ProjectsModel>> getAllProjects() async {
    try {
      print('📡 Fetching all projects from: $getAllProjectsUrl');

      final response = await _dio.get(
        getAllProjectsUrl,
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final projectsList = (data['data'] as List)
              .map((project) => ProjectsModel.fromJson(project))
              .toList();
          print('✅ Projects fetched: ${projectsList.length} total');
          return projectsList;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch projects');
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

  /// Get project by ID
  static Future<ProjectsModel> getProjectById(String id) async {
    try {
      print('📡 Fetching project: $id');

      final response = await _dio.get(
        '$getProjectByIdUrl$id',
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final project = ProjectsModel.fromJson(data['data']);
          print('✅ Project fetched: ${project.projectName}');
          return project;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch project');
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

  /// Create project
  static Future<ProjectsModel> createProject({
    required String projectName,
    required String summary,
    required String primaryStack,
    required String status,
    required String deadline,
    required String teamSize,
    required String projectNotes,
    List<String> focusTags = const [],
    int progress = 0,
  }) async {
    try {
      print('🚀 Creating project: $projectName');

      final response = await _dio.post(
        createProjectUrl,
        data: {
          'projectName': projectName,
          'summary': summary,
          'primaryStack': primaryStack,
          'status': status,
          'deadline': deadline,
          'teamSize': teamSize,
          'projectNotes': projectNotes,
          'focusTags': focusTags,
          'progress': progress,
        },
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final project = ProjectsModel.fromJson(data['data']);
          print('✅ Project created: ${project.projectName}');
          return project;
        } else {
          throw Exception(data['message'] ?? 'Failed to create project');
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

  /// Update project
  static Future<ProjectsModel> updateProject({
    required String id,
    required String projectName,
    required String summary,
    required String primaryStack,
    required String status,
    required String deadline,
    required String teamSize,
    required String projectNotes,
    List<String> focusTags = const [],
    int progress = 0,
  }) async {
    try {
      print('✏️ Updating project: $id');

      final response = await _dio.put(
        '$updateProjectUrl$id',
        data: {
          'projectName': projectName,
          'summary': summary,
          'primaryStack': primaryStack,
          'status': status,
          'deadline': deadline,
          'teamSize': teamSize,
          'projectNotes': projectNotes,
          'focusTags': focusTags,
          'progress': progress,
        },
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final project = ProjectsModel.fromJson(data['data']);
          print('✅ Project updated: ${project.projectName}');
          return project;
        } else {
          throw Exception(data['message'] ?? 'Failed to update project');
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

  /// Delete project
  static Future<void> deleteProject(String id) async {
    try {
      print('🗑️ Deleting project: $id');

      final response = await _dio.delete(
        '$deleteProjectUrl$id',
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          print('✅ Project deleted');
        } else {
          throw Exception(data['message'] ?? 'Failed to delete project');
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
