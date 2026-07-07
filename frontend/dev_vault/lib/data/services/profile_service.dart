import 'package:dio/dio.dart';

import '../models/profile_model.dart';

class ProfileService {
  ProfileService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<ProfileModel> getProfile() async {
    final response = await _dio.get(
      'http://10.0.2.2:3000/api/profile/getProfile',
      options: Options(headers: {'Authorization': 'Bearer YOUR_TOKEN'}),
    );

    return ProfileModel.fromJson(response.data['data']);
  }

  Future<ProfileModel> updateProfile({required String name, required String email}) async {
    final response = await _dio.put(
      'http://10.0.2.2:3000/api/profile/editProfile',
      data: {'name': name, 'email': email},
      options: Options(headers: {'Authorization': 'Bearer YOUR_TOKEN'}),
    );

    return ProfileModel.fromJson(response.data['data']);
  }
}
