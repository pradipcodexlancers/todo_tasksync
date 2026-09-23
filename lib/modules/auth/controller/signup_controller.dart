import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/utils/error_handler.dart';
import '../../../services/auth_service.dart';

/// Signup Controller
class SignupController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool hidePassword = true.obs;
  final RxBool hideConfirmPassword = true.obs;

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    try {
      final response = await _authService.signUp(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      // With email confirmation on, Supabase returns a fake user with no identities
      // when the email already exists.
      if (response.user?.identities?.isEmpty ?? false) {
        AppUtils.showErrorSnackbar(
          title: 'Signup failed',
          message: 'This email is already registered. Try logging in.',
        );
        return;
      }

      if (response.session != null) {
        // Email confirmation is off: user is already logged in
        Get.offAllNamed(AppRoutes.tasks);
      } else {
        // Email confirmation is on: user must verify first
        AppUtils.showSuccessSnackbar(
          title: 'Account created',
          message: 'Please check your email and verify your account, then log in.',
        );
        Get.offNamed(AppRoutes.login);
      }
    } catch (e) {
      AppErrorHandler.show(e, title: 'Signup failed');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
