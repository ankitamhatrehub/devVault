import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();

  static final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 90),
    ),
  );

  static Map<String, String> authHeaders(String? token) {
    if (token == null || token.isEmpty) return const {};
    return {'Authorization': 'Bearer $token'};
  }
}
