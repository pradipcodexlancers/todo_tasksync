import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../controller/login_controller.dart';

/// Login Page
class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(AppStrings.appTagline, style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: controller.emailController,
                    labelText: 'Email',
                    hintText: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => CustomTextField(
                      controller: controller.passwordController,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      obscureText: controller.hidePassword.value,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(controller.hidePassword.value ? Icons.visibility_off : Icons.visibility),
                        onPressed: controller.hidePassword.toggle,
                      ),
                      validator: Validators.password,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(() => CustomButton(text: 'Login', isLoading: controller.isLoading.value, onPressed: controller.login)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?", style: TextStyle(color: AppColors.textSecondary)),
                      TextButton(onPressed: () => Get.offNamed(AppRoutes.signup), child: const Text('Sign up')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
