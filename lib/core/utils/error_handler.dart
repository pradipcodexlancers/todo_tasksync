import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_utils.dart';

/// Common Error Handler
///
/// Converts any thrown error into a friendly message and shows it
/// as a GetX snackbar. Use it in every `catch` block.
class AppErrorHandler {
  AppErrorHandler._();

  static const String _networkMessage = 'No internet connection. Please check your network and try again.';

  /// Show the error as a snackbar
  static void show(Object error, {String title = 'Error'}) {
    AppUtils.showErrorSnackbar(title: title, message: message(error));
  }

  /// Friendly message for an error
  static String message(Object error) {
    if (error is AuthRetryableFetchException || error is SocketException || error is TimeoutException) {
      return _networkMessage;
    }

    if (error is AuthException) {
      switch (error.code) {
        case 'invalid_credentials':
          return 'Incorrect email or password.';
        case 'email_not_confirmed':
          return 'Please verify your email before logging in.';
        case 'user_already_exists':
        case 'email_exists':
          return 'This email is already registered. Try logging in.';
        case 'weak_password':
          return 'Password is too weak. Use a stronger password.';
        case 'validation_failed':
          return 'Please enter a valid email address.';
        case 'signup_disabled':
          return 'Signups are currently disabled.';
        case 'over_request_rate_limit':
        case 'over_email_send_rate_limit':
          return 'Too many attempts. Please wait a moment and try again.';
      }
      return error.message;
    }

    if (error is PostgrestException) return error.message;

    return 'Something went wrong. Please try again.';
  }
}
