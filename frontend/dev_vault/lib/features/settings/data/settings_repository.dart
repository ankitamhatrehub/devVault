import 'package:shared_preferences/shared_preferences.dart';

import 'settings_model.dart';

abstract interface class SettingsRepository {
  Future<({SettingsPreferences preferences, bool isFirstRun})> loadSettings();
  Future<void> saveSettings(SettingsPreferences preferences);
  Future<({ThemeModePreference mode, bool isFirstRun})> loadThemeMode();
  Future<void> saveThemeMode(ThemeModePreference mode);
}

enum ThemeModePreference { system, light, dark }

class SharedPreferencesSettingsRepository implements SettingsRepository {
  static const _pushNotificationsKey = 'settings_push_notifications';
  static const _reminderNotificationsKey = 'settings_reminder_notifications';
  static const _securityAlertsKey = 'settings_security_alerts';
  static const _appLockKey = 'settings_app_lock';
  static const _autoLockTimeoutKey = 'settings_auto_lock_timeout';
  static const _themeModeKey = 'settings_theme_mode';

  @override
  Future<({SettingsPreferences preferences, bool isFirstRun})>
  loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = !_hasAnySettings(prefs);

    return (
      preferences: SettingsPreferences(
        pushNotificationsEnabled: prefs.getBool(_pushNotificationsKey) ?? true,
        reminderNotificationsEnabled:
            prefs.getBool(_reminderNotificationsKey) ?? true,
        securityAlertsEnabled: prefs.getBool(_securityAlertsKey) ?? true,
        appLockEnabled: prefs.getBool(_appLockKey) ?? false,
        autoLockTimeoutSeconds: prefs.getInt(_autoLockTimeoutKey) ?? 30,
      ),
      isFirstRun: isFirstRun,
    );
  }

  @override
  Future<void> saveSettings(SettingsPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await Future.wait([
      prefs.setBool(
        _pushNotificationsKey,
        preferences.pushNotificationsEnabled,
      ),
      prefs.setBool(
        _reminderNotificationsKey,
        preferences.reminderNotificationsEnabled,
      ),
      prefs.setBool(_securityAlertsKey, preferences.securityAlertsEnabled),
      prefs.setBool(_appLockKey, preferences.appLockEnabled),
      prefs.setInt(_autoLockTimeoutKey, preferences.autoLockTimeoutSeconds),
    ]);

    if (saved.any((result) => !result)) {
      throw StateError('Unable to save all settings preferences.');
    }
  }

  @override
  Future<({ThemeModePreference mode, bool isFirstRun})> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeModeKey);
    return (
      mode: ThemeModePreference.values.firstWhere(
        (mode) => mode.name == value,
        orElse: () => ThemeModePreference.system,
      ),
      isFirstRun: value == null,
    );
  }

  @override
  Future<void> saveThemeMode(ThemeModePreference mode) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString(_themeModeKey, mode.name);
    if (!saved) {
      throw StateError('Unable to save the selected theme mode.');
    }
  }

  bool _hasAnySettings(SharedPreferences prefs) {
    return prefs.containsKey(_pushNotificationsKey) ||
        prefs.containsKey(_reminderNotificationsKey) ||
        prefs.containsKey(_securityAlertsKey) ||
        prefs.containsKey(_appLockKey) ||
        prefs.containsKey(_autoLockTimeoutKey);
  }
}
