import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../controller/signup_controller.dart';

/// Signup Page
class SignupPage extends GetView<SignupController> {
  const SignupPage({super.key});

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
                    'Create account',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text('Sign up to sync your tasks', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: controller.nameController,
                    labelText: 'Name',
                    hintText: 'Your name',
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: Validators.name,
                  ),
                  const SizedBox(height: 16),
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
                      hintText: 'At least 6 characters',
                      obscureText: controller.hidePassword.value,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(controller.hidePassword.value ? Icons.visibility_off : Icons.visibility),
                        onPressed: controller.hidePassword.toggle,
                      ),
                      validator: Validators.password,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => CustomTextField(
                      controller: controller.confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      obscureText: controller.hideConfirmPassword.value,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(controller.hideConfirmPassword.value ? Icons.visibility_off : Icons.visibility),
                        onPressed: controller.hideConfirmPassword.toggle,
                      ),
                      validator: (value) => Validators.confirmPassword(value, controller.passwordController.text),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(() => CustomButton(text: 'Sign up', isLoading: controller.isLoading.value, onPressed: controller.signUp)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?', style: TextStyle(color: AppColors.textSecondary)),
                      TextButton(onPressed: () => Get.offNamed(AppRoutes.login), child: const Text('Login')),
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
