import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_utils.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../controller/register_controller.dart';

/// Register Screen View
///
/// Implements [GetView<RegisterController>] for signup interactions.
class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.registerTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  AppStrings.registerSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // Name field
                CustomTextField(
                  controller: controller.nameController,
                  labelText: AppStrings.fullName,
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) => AppUtils.validateRequired(value, 'Full Name'),
                ),
                const SizedBox(height: 16),

                // Email field
                CustomTextField(
                  controller: controller.emailController,
                  labelText: AppStrings.email,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) {
                    final requiredError = AppUtils.validateRequired(value, 'Email');
                    if (requiredError != null) return requiredError;
                    if (!AppUtils.isValidEmail(value!)) {
                      return AppStrings.invalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                Obx(
                  () => CustomTextField(
                    controller: controller.passwordController,
                    labelText: AppStrings.password,
                    hintText: 'Create a password',
                    obscureText: controller.isPasswordHidden.value,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    validator: (value) {
                      final requiredError = AppUtils.validateRequired(value, 'Password');
                      if (requiredError != null) return requiredError;
                      if (value!.length < 6) {
                        return AppStrings.passwordTooShort;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm Password field
                Obx(
                  () => CustomTextField(
                    controller: controller.confirmPasswordController,
                    labelText: AppStrings.confirmPassword,
                    hintText: 'Re-enter your password',
                    obscureText: controller.isConfirmPasswordHidden.value,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordHidden.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                    validator: (value) {
                      if (value != controller.passwordController.text) {
                        return AppStrings.passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Register submit button
                Obx(
                  () => CustomButton(
                    text: AppStrings.register,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.register,
                  ),
                ),
                const SizedBox(height: 20),

                // Already have account -> back to login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.alreadyHaveAccount,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Text(
                        AppStrings.login,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
