import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/utils/error_handler.dart';
import '../../../services/auth_service.dart';

/// Login Controller
class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool hidePassword = true.obs;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    try {
      await _authService.login(email: emailController.text, password: passwordController.text);
      Get.offAllNamed(AppRoutes.tasks);
    } catch (e) {
      AppErrorHandler.show(e, title: 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
