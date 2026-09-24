import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/routes/app_routes.dart';
import 'local_storage_service.dart';
import 'storage_service.dart';

/// Auth Service (Supabase)
///
/// Handles signup, login, session and logout.
/// Supabase persists the session on the device, so the user stays logged in
/// after restarting the app until [logout] is called.
/// The logged-in user's id is saved in SharedPreferences ([StorageService]).
class AuthService extends GetxService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final StorageService _storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    // Session restored from an older app version without a saved user id
    if (currentUser != null && _storage.userId == null) {
      _storage.saveUserId(currentUser!.id);
    }

    // Whenever the session ends (logout / expired / revoked), go back to login
    _supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  User? get currentUser => _supabase.auth.currentUser;

  bool get isLoggedIn => _supabase.auth.currentSession != null;

  String get userName => (currentUser?.userMetadata?['name'] as String?) ?? '';

  String get userEmail => currentUser?.email ?? '';

  Future<AuthResponse> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'name': name.trim()},
    );
    // Email confirmation off -> user is logged in right away
    if (response.session != null) {
      await _storage.saveUserId(response.user!.id);
    }
    return response;
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    await _storage.saveUserId(response.user!.id);
    return response;
  }

  /// End the session and remove the previous user's local data
  Future<void> logout() async {
    await _supabase.auth.signOut();
    await _storage.remove(StorageService.keyUserId);
    await Get.find<LocalStorageService>().clearTodos();
  }
}
