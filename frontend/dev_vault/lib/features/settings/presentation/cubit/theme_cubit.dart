import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/settings_repository.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._repository) : super(const ThemeState());

  final SettingsRepository _repository;

  Future<void> loadThemeMode() async {
    if (isClosed) return;
    emit(state.copyWith(status: ThemeStatus.loading, clearError: true));
    try {
      final result = await _repository.loadThemeMode();
      if (isClosed) return;
      emit(
        state.copyWith(
          status: result.isFirstRun ? ThemeStatus.empty : ThemeStatus.success,
          themeMode: _toThemeMode(result.mode),
          clearError: true,
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ThemeStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (isClosed) return;

    final previousMode = state.themeMode;
    emit(
      state.copyWith(
        status: ThemeStatus.success,
        themeMode: themeMode,
        clearError: true,
      ),
    );

    try {
      await _repository.saveThemeMode(_toPreference(themeMode));
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ThemeStatus.failure,
          themeMode: previousMode,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  ThemeMode _toThemeMode(ThemeModePreference preference) {
    return switch (preference) {
      ThemeModePreference.system => ThemeMode.system,
      ThemeModePreference.light => ThemeMode.light,
      ThemeModePreference.dark => ThemeMode.dark,
    };
  }

  ThemeModePreference _toPreference(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => ThemeModePreference.system,
      ThemeMode.light => ThemeModePreference.light,
      ThemeMode.dark => ThemeModePreference.dark,
    };
  }
}
