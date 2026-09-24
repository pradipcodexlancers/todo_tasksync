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
  static void showSuccessSnackbar({String title = 'Success', required String message}) {
    showSnackbar(title: title, message: message, backgroundColor: AppColors.success, textColor: AppColors.textLight);
  }

  /// Show an error snackbar
  static void showErrorSnackbar({String title = 'Error', required String message}) {
    showSnackbar(title: title, message: message, backgroundColor: AppColors.error, textColor: AppColors.textLight);
  }

  /// Show a Yes / No dialog, returns true when the user confirms
  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'Cancel',
    Color confirmColor = AppColors.error,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        content: Text(message, style: const TextStyle(fontSize: 14, height: 1.4, color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              confirmText,
              style: TextStyle(color: confirmColor, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
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
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
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
