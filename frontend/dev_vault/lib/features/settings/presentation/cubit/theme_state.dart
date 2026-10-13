import 'package:flutter/material.dart';

enum ThemeStatus { initial, loading, success, empty, failure }

class ThemeState {
  const ThemeState({
    this.status = ThemeStatus.initial,
    this.themeMode = ThemeMode.system,
    this.errorMessage,
  });

  final ThemeStatus status;
  final ThemeMode themeMode;
  final String? errorMessage;

  ThemeState copyWith({
    ThemeStatus? status,
    ThemeMode? themeMode,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ThemeState(
      status: status ?? this.status,
      themeMode: themeMode ?? this.themeMode,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
