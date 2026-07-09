import 'package:dio/dio.dart';
import '../constant_urls.dart';
import '../models/notes_model.dart';
import 'local_storage_service.dart';

class NotesService {
  static final Dio _dio = Dio();

  static Map<String, dynamic> _getAuthHeaders() {
    final token = LocalStorageService.getToken();
    return {'Authorization': token != null ? 'Bearer $token' : ''};
  }

  /// Get all notes
  static Future<List<NotesModel>> getAllNotes() async {
    try {
      print('📡 Fetching all notes from: $getAllNotesUrl');

      final response = await _dio.get(
        getAllNotesUrl,
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final notesList = (data['data'] as List)
              .map((note) => NotesModel.fromJson(note))
              .toList();
          print('✅ Notes fetched: ${notesList.length} total');
          return notesList;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch notes');
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

  /// Get note by ID
  static Future<NotesModel> getNoteById(String id) async {
    try {
      print('📡 Fetching note: $id');

      final response = await _dio.get(
        '$getNoteByIdUrl$id',
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final note = NotesModel.fromJson(data['data']);
          print('✅ Note fetched: ${note.title}');
          return note;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch note');
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

  /// Create note
  static Future<NotesModel> createNote({
    required String title,
    required String body,
    required String category,
    bool pinned = false,
  }) async {
    try {
      print('📝 Creating note: $title');

      final response = await _dio.post(
        createNoteUrl,
        data: {
          'title': title,
          'body': body,
          'category': category,
          'pinned': pinned,
        },
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final note = NotesModel.fromJson(data['data']);
          print('✅ Note created: ${note.title}');
          return note;
        } else {
          throw Exception(data['message'] ?? 'Failed to create note');
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

  /// Update note
  static Future<NotesModel> updateNote({
    required String id,
    required String title,
    required String body,
    required String category,
    bool pinned = false,
  }) async {
    try {
      print('✏️ Updating note: $id');

      final response = await _dio.put(
        '$updateNoteUrl$id',
        data: {
          'title': title,
          'body': body,
          'category': category,
          'pinned': pinned,
        },
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final note = NotesModel.fromJson(data['data']);
          print('✅ Note updated: ${note.title}');
          return note;
        } else {
          throw Exception(data['message'] ?? 'Failed to update note');
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

  /// Delete note
  static Future<void> deleteNote(String id) async {
    try {
      print('🗑️ Deleting note: $id');

      final response = await _dio.delete(
        '$deleteNoteUrl$id',
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          print('✅ Note deleted');
        } else {
          throw Exception(data['message'] ?? 'Failed to delete note');
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
