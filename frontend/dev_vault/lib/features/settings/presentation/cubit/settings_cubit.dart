import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/settings_model.dart';
import '../../data/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository) : super(const SettingsState());

  final SettingsRepository _repository;

  Future<void> loadSettings() async {
    if (isClosed) return;
    emit(state.copyWith(status: SettingsStatus.loading, clearError: true));

    try {
      final result = await _repository.loadSettings();
      if (isClosed) return;
      emit(
        state.copyWith(
          status: result.isFirstRun
              ? SettingsStatus.empty
              : SettingsStatus.success,
          preferences: result.preferences,
          isInitialized: true,
          clearError: true,
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> setPushNotificationsEnabled(bool enabled) =>
      _update(preferences: state.preferences.copyWith(
        pushNotificationsEnabled: enabled,
      ));

  Future<void> setReminderNotificationsEnabled(bool enabled) =>
      _update(preferences: state.preferences.copyWith(
        reminderNotificationsEnabled: enabled,
      ));

  Future<void> setSecurityAlertsEnabled(bool enabled) =>
      _update(preferences: state.preferences.copyWith(
        securityAlertsEnabled: enabled,
      ));

  Future<void> setAppLockEnabled(bool enabled) =>
      _update(preferences: state.preferences.copyWith(appLockEnabled: enabled));

  Future<void> setAutoLockTimeoutSeconds(int seconds) =>
      _update(preferences: state.preferences.copyWith(
        autoLockTimeoutSeconds: seconds,
      ));

  Future<void> _update({required SettingsPreferences preferences}) async {
    if (isClosed) return;

    try {
      await _repository.saveSettings(preferences);
      if (isClosed) return;
      emit(
        state.copyWith(
          status: SettingsStatus.success,
          preferences: preferences,
          clearError: true,
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
