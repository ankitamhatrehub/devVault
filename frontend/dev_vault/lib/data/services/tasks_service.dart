import 'package:dio/dio.dart';
import '../constant_urls.dart';
import '../models/tasks_model.dart';
import 'local_storage_service.dart';

class TasksService {
  static final Dio _dio = Dio();

  /// Get authorization headers with stored token
  static Map<String, dynamic> _getAuthHeaders() {
    final token = LocalStorageService.getToken();
    return {'Authorization': token != null ? 'Bearer $token' : ''};
  }

  /// Get all tasks
  static Future<List<TasksModel>> getAllTasks() async {
    try {
      print('📡 Fetching all tasks from: $getAllTasksUrl');
      print('🔑 Using stored token for authentication');

      final response = await _dio.get(
        getAllTasksUrl,
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final tasksList = (data['data'] as List)
              .map((task) => TasksModel.fromJson(task))
              .toList();
          print('✅ Tasks fetched successfully');
          print('   Total tasks: ${tasksList.length}');
          return tasksList;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch tasks');
        }
      } else {
        throw Exception('Failed to fetch tasks with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      if (e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      throw Exception('Error fetching tasks: ${e.message}');
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception(e.toString());
    }
  }

  /// Get task by ID
  static Future<TasksModel> getTaskById(String id) async {
    try {
      print('📡 Fetching task with ID: $id');

      final response = await _dio.get(
        '$getTaskByIdUrl$id',
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final task = TasksModel.fromJson(data['data']);
          print('✅ Task fetched successfully: ${task.title}');
          return task;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch task');
        }
      } else {
        throw Exception('Failed to fetch task with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      if (e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      throw Exception('Error fetching task: ${e.message}');
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception(e.toString());
    }
  }

  /// Create new task
  static Future<TasksModel> createTask({
    required String title,
    required String description,
    required String priority,
    required String status,
    required String dueDate,
    required String category,
    int progress = 0,
  }) async {
    try {
      print('📡 Creating new task');
      print('   Title: $title');
      print('   Priority: $priority');
      print('   Category: $category');

      final response = await _dio.post(
        createTaskUrl,
        data: {
          'title': title,
          'description': description,
          'priority': priority,
          'status': status,
          'dueDate': dueDate,
          'category': category,
          'progress': progress,
        },
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final task = TasksModel.fromJson(data['data']);
          print('✅ Task created successfully: ${task.title}');
          return task;
        } else {
          throw Exception(data['message'] ?? 'Failed to create task');
        }
      } else {
        throw Exception('Failed to create task with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      if (e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      throw Exception('Error creating task: ${e.message}');
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception(e.toString());
    }
  }

  /// Update task
  static Future<TasksModel> updateTask({
    required String id,
    required String title,
    required String description,
    required String priority,
    required String status,
    required String dueDate,
    required String category,
    int progress = 0,
  }) async {
    try {
      print('📡 Updating task with ID: $id');
      print('   Title: $title');
      print('   Status: $status');

      final response = await _dio.put(
        '$updateTaskUrl$id',
        data: {
          'title': title,
          'description': description,
          'priority': priority,
          'status': status,
          'dueDate': dueDate,
          'category': category,
          'progress': progress,
        },
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final task = TasksModel.fromJson(data['data']);
          print('✅ Task updated successfully: ${task.title}');
          return task;
        } else {
          throw Exception(data['message'] ?? 'Failed to update task');
        }
      } else {
        throw Exception('Failed to update task with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      if (e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      throw Exception('Error updating task: ${e.message}');
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception(e.toString());
    }
  }

  /// Delete task
  static Future<void> deleteTask(String id) async {
    try {
      print('📡 Deleting task with ID: $id');

      final response = await _dio.delete(
        '$deleteTaskUrl$id',
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true) {
          print('✅ Task deleted successfully');
        } else {
          throw Exception(data['message'] ?? 'Failed to delete task');
        }
      } else {
        throw Exception('Failed to delete task with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      if (e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      throw Exception('Error deleting task: ${e.message}');
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception(e.toString());
    }
  }
}
