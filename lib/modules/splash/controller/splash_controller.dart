import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../services/storage_service.dart';

/// Splash Screen Controller
///
/// Handles app startup logic, such as checking user authentication,
/// pre-loading configuration, and navigating to the appropriate initial screen.
class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _handleNavigation();
  }

  /// Wait for a brief moment then navigate to Login or Home
  Future<void> _handleNavigation() async {
    // Simulate loading/initialization time
    await Future.delayed(const Duration(seconds: 2));

    // Check login status dynamically from StorageService
    final storage = Get.find<StorageService>();
    final bool isLoggedIn = storage.read<bool>(StorageService.keyIsLoggedIn) ?? false;

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
