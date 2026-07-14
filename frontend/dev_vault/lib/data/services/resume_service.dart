import 'dart:io';
import '../models/resume_model.dart';

class ResumeService {
  // TODO: Integrate with backend API
  // This service will handle:
  // - Fetching resume data
  // - Uploading resume to Cloudinary
  // - Deleting resume
  // - Downloading resume

  static Future<ResumeModel?> getResume() async {
    try {
      // TODO: Implement API call to fetch resume
      // final response = await http.get(Uri.parse('$baseUrl/resume'));
      // return ResumeModel.fromJson(jsonDecode(response.body));
      return null;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String?> uploadResume(File file) async {
    try {
      // TODO: Implement upload to Cloudinary
      // 1. Get Cloudinary credentials from backend
      // 2. Upload file to Cloudinary
      // 3. Save resume data to backend API
      // 4. Return URL
      return null;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteResume(String resumeId) async {
    try {
      // TODO: Implement API call to delete resume
      // final response = await http.delete(Uri.parse('$baseUrl/resume/$resumeId'));
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> downloadResume(String fileUrl) async {
    try {
      // TODO: Implement download functionality
    } catch (e) {
      rethrow;
    }
  }
}
