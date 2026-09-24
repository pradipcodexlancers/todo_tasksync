import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local Storage Service (SharedPreferences)
///
/// Manages persistent local key-value storage (such as the logged-in user id,
/// app preferences, or onboarding flags).
///
/// In main.dart, call:
/// `await Get.putAsync(() => StorageService().init());`
class StorageService extends GetxService {
  late final SharedPreferences _prefs;

  // Common Storage Keys
  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyThemeMode = 'theme_mode';

  /// Async initialization called before `runApp()`
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  /// Id of the logged-in user, saved at login
  String? get userId => read<String>(keyUserId);

  Future<void> saveUserId(String id) => write(keyUserId, id);

  /// Write a value to storage (String, bool, int, double or `List<String>`)
  Future<void> write(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      throw ArgumentError('Unsupported type for key "$key": ${value.runtimeType}');
    }
  }

  /// Read a value from storage
  T? read<T>(String key) {
    return _prefs.get(key) as T?;
  }

  /// Check if a key exists in storage
  bool hasData(String key) {
    return _prefs.containsKey(key);
  }

  /// Remove a specific key from storage
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// Clear all stored data (e.g. on logout)
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
