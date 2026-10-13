import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SnackBarService {
  SnackBarService._();

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: colorScheme.surfaceContainerHigh,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        margin: const EdgeInsets.all(AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_rounded, color: AppColors.danger, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: colorScheme.surfaceContainerHigh,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        margin: const EdgeInsets.all(AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_rounded, color: colorScheme.primary, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: colorScheme.surfaceContainerHigh,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        margin: const EdgeInsets.all(AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_rounded, color: AppColors.warning, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: colorScheme.surfaceContainerHigh,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        margin: const EdgeInsets.all(AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    );
  }

  /// Clean up and extract user-friendly error message from exception
  static String _cleanErrorMessage(dynamic error) {
    String errorMsg = error.toString();

    if (errorMsg.contains('SocketException')) {
      return 'No internet connection. Please check your network.';
    } else if (errorMsg.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    } else if (errorMsg.contains('401') || errorMsg.contains('Unauthorized')) {
      return 'Your session expired. Please login again.';
    } else if (errorMsg.contains('403') || errorMsg.contains('Forbidden')) {
      return 'You don\'t have permission to perform this action.';
    } else if (errorMsg.contains('404') || errorMsg.contains('Not Found')) {
      return 'The requested resource was not found.';
    } else if (errorMsg.contains('500') || errorMsg.contains('Server Error')) {
      return 'Server error. Please try again later.';
    } else if (errorMsg.contains('Exception:')) {
      return errorMsg.replaceAll('Exception: ', '');
    }

    return errorMsg.length > 100 ? '${errorMsg.substring(0, 100)}...' : errorMsg;
  }

  static void showErrorFromException(
    BuildContext context, {
    required dynamic error,
    Duration duration = const Duration(seconds: 4),
  }) {
    showError(
      context,
      message: _cleanErrorMessage(error),
      duration: duration,
    );
  }
}
