class SettingsPreferences {
  const SettingsPreferences({
    this.pushNotificationsEnabled = true,
    this.reminderNotificationsEnabled = true,
    this.securityAlertsEnabled = true,
    this.appLockEnabled = false,
    this.autoLockTimeoutSeconds = 30,
  });

  final bool pushNotificationsEnabled;
  final bool reminderNotificationsEnabled;
  final bool securityAlertsEnabled;
  final bool appLockEnabled;
  final int autoLockTimeoutSeconds;

  SettingsPreferences copyWith({
    bool? pushNotificationsEnabled,
    bool? reminderNotificationsEnabled,
    bool? securityAlertsEnabled,
    bool? appLockEnabled,
    int? autoLockTimeoutSeconds,
  }) {
    return SettingsPreferences(
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      reminderNotificationsEnabled:
          reminderNotificationsEnabled ?? this.reminderNotificationsEnabled,
      securityAlertsEnabled: securityAlertsEnabled ?? this.securityAlertsEnabled,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      autoLockTimeoutSeconds:
          autoLockTimeoutSeconds ?? this.autoLockTimeoutSeconds,
    );
  }
}
