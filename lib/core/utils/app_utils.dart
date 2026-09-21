import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

/// Application Utility Helpers
///
/// General-purpose utility functions including snackbars, dialogs,
/// validators, and UI interaction helpers.
class AppUtils {
  // Private constructor to prevent direct instantiation
  AppUtils._();

  /// Show a standard snackbar using GetX
  static void showSnackbar({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM,
    Color backgroundColor = AppColors.darkSurface,
    Color textColor = AppColors.textLight,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: textColor,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: duration,
    );
  }

  /// Show a success snackbar
  static void showSuccessSnackbar({
    String title = 'Success',
    required String message,
  }) {
    showSnackbar(
      title: title,
      message: message,
      backgroundColor: AppColors.success,
      textColor: AppColors.textLight,
    );
  }

  /// Show an error snackbar
  static void showErrorSnackbar({
    String title = 'Error',
    required String message,
  }) {
    showSnackbar(
      title: title,
      message: message,
      backgroundColor: AppColors.error,
      textColor: AppColors.textLight,
    );
  }

  /// Dismiss the on-screen keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /// Basic email validation regex
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  /// General required validator helper
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? '$fieldName is required' : AppStrings.fieldRequired;
    }
    return null;
  }
}
