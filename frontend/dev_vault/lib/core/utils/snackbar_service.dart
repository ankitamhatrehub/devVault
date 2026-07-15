import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SnackBarService {
  SnackBarService._();

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: duration,
        behavior: SnackBarBehavior.floating,
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_rounded, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.danger,
        duration: duration,
        behavior: SnackBarBehavior.floating,
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_rounded, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.primary,
        duration: duration,
        behavior: SnackBarBehavior.floating,
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_rounded, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.warning,
        duration: duration,
        behavior: SnackBarBehavior.floating,
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
