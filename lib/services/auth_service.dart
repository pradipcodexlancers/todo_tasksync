import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/routes/app_routes.dart';
import 'local_storage_service.dart';

/// Auth Service (Supabase)
///
/// Handles signup, login, session and logout.
/// Supabase persists the session on the device, so the user stays logged in
/// after restarting the app until [logout] is called.
class AuthService extends GetxService {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
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
    return await _supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'name': name.trim()},
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// End the session and remove the previous user's local todos
  Future<void> logout() async {
    await _supabase.auth.signOut();
    await Get.find<LocalStorageService>().clearTodos();
  }
}
