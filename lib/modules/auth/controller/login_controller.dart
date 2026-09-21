import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_utils.dart';

/// Login Controller
///
/// Manages state for the Login screen, including text controllers,
/// password visibility toggle, loading state, and the login submission action.
class LoginController extends GetxController {
  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Input text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Reactive state observables (.obs)
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;

  /// Toggle password field visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  /// Handle user login submission
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API network call
      await Future.delayed(const Duration(seconds: 2));

      // Example: Save token to StorageService
      // final storage = Get.find<StorageService>();
      // await storage.write(StorageService.keyIsLoggedIn, true);

      AppUtils.showSuccessSnackbar(message: 'Login successful!');

      // Navigate to Home screen and clear the navigation stack
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      AppUtils.showErrorSnackbar(message: 'Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to Register screen
  void goToRegister() {
    Get.toNamed(AppRoutes.register);
  }

  @override
  void onClose() {
    // Dispose text editing controllers when controller is destroyed
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
