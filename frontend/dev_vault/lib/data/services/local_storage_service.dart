import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  static late SharedPreferences _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save auth token
  static Future<bool> saveToken(String token) async {
    return await _prefs.setString(_tokenKey, token);
  }

  /// Get auth token
  static String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Save user ID
  static Future<bool> saveUserId(String userId) async {
    return await _prefs.setString(_userIdKey, userId);
  }

  /// Get user ID
  static String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  /// Save user email
  static Future<bool> saveUserEmail(String email) async {
    return await _prefs.setString(_userEmailKey, email);
  }

  /// Get user email
  static String? getUserEmail() {
    return _prefs.getString(_userEmailKey);
  }

  /// Save user name
  static Future<bool> saveUserName(String name) async {
    return await _prefs.setString(_userNameKey, name);
  }

  /// Get user name
  static String? getUserName() {
    return _prefs.getString(_userNameKey);
  }

  /// Save all user data
  static Future<void> saveUserData({
    required String userId,
    required String token,
    required String email,
    required String name,
  }) async {
    await Future.wait([
      saveUserId(userId),
      saveToken(token),
      saveUserEmail(email),
      saveUserName(name),
    ]);
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    return getToken() != null && getUserId() != null;
  }

  /// Clear all auth data (logout)
  static Future<bool> clearAuthData() async {
    return await _prefs.remove(_tokenKey) &&
        await _prefs.remove(_userIdKey) &&
        await _prefs.remove(_userEmailKey) &&
        await _prefs.remove(_userNameKey);
  }

  /// Clear all data
  static Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
