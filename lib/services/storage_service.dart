import 'package:get/get.dart';

/// Local Storage Service
///
/// Manages persistent local key-value storage (such as auth tokens, user session,
/// app preferences, or onboarding flags).
///
/// HOW TO INTEGRATE:
/// To persist data to disk, add `shared_preferences` or `get_storage` to pubspec.yaml
/// and initialize it inside [init].
///
/// In main.dart, call:
/// `await Get.putAsync(() => StorageService().init());`
class StorageService extends GetxService {
  // In-memory cache map for boilerplate demonstration
  final Map<String, dynamic> _memoryCache = {};

  // Common Storage Keys
  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyThemeMode = 'theme_mode';

  /// Async initialization called before `runApp()` or in initial bindings
  Future<StorageService> init() async {
    // Example: Initialize SharedPreferences / GetStorage here
    // final prefs = await SharedPreferences.getInstance();
    return this;
  }

  /// Write a value to storage
  Future<void> write(String key, dynamic value) async {
    _memoryCache[key] = value;
  }

  /// Read a value from storage
  T? read<T>(String key) {
    return _memoryCache[key] as T?;
  }

  /// Check if a key exists in storage
  bool hasData(String key) {
    return _memoryCache.containsKey(key);
  }

  /// Remove a specific key from storage
  Future<void> remove(String key) async {
    _memoryCache.remove(key);
  }

  /// Clear all stored data (e.g. on logout)
  Future<void> clearAll() async {
    _memoryCache.clear();
  }
}
