import '../../data/settings_model.dart';

enum SettingsStatus { initial, loading, success, empty, failure }

class SettingsState {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.preferences = const SettingsPreferences(),
    this.isInitialized = false,
    this.errorMessage,
  });

  final SettingsStatus status;
  final SettingsPreferences preferences;
  final bool isInitialized;
  final String? errorMessage;

  SettingsState copyWith({
    SettingsStatus? status,
    SettingsPreferences? preferences,
    bool? isInitialized,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      preferences: preferences ?? this.preferences,
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
