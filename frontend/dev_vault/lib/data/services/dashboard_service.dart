import 'package:dio/dio.dart';
import '../constant_urls.dart';
import '../models/dashboard_model.dart';
import 'local_storage_service.dart';

class DashboardService {
  static final Dio _dio = Dio();

  static Map<String, dynamic> _getAuthHeaders() {
    final token = LocalStorageService.getToken();
    return {'Authorization': token != null ? 'Bearer $token' : ''};
  }

  /// Get dashboard data with all statistics
  static Future<DashboardModel> getDashboard() async {
    try {
      print('📊 Fetching dashboard from: $getDashboardUrl');

      final response = await _dio.get(
        getDashboardUrl,
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final dashboard = DashboardModel.fromJson(data['data']);
          print('✅ Dashboard data fetched successfully');
          print('   Total Tasks: ${dashboard.totalTasks}');
          print('   Total Notes: ${dashboard.totalNotes}');
          print('   Total Projects: ${dashboard.totalProjects}');
          print('   Total Learnings: ${dashboard.totalLearnings}');
          return dashboard;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch dashboard');
        }
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Error: ${e.message}');
      if (e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? e.message);
      }
      throw Exception('Error fetching dashboard: ${e.message}');
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception(e.toString());
    }
  }
}
