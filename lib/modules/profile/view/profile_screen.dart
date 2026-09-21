import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/common_loader.dart';
import '../../../widgets/custom_button.dart';
import '../controller/profile_controller.dart';

/// Profile Screen View
///
/// Implements [GetView<ProfileController>] for viewing and managing user profile.
class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profileTitle),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CommonLoader(message: 'Loading profile...');
        }

        final user = controller.profile.value;
        if (user == null) {
          return const Center(child: Text('No profile data available'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            children: [
              // Avatar
              const Center(
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.person,
                    size: 54,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Name & Email
              Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Profile Details Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.phone_outlined, color: AppColors.primary),
                      title: const Text('Phone Number'),
                      subtitle: Text(user.phoneNumber),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.info_outline, color: AppColors.primary),
                      title: const Text('Bio'),
                      subtitle: Text(user.bio ?? 'No bio added'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Settings Action Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit_outlined, color: AppColors.primary),
                      title: const Text(AppStrings.editProfile),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined, color: AppColors.primary),
                      title: const Text(AppStrings.settings),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Logout Button
              CustomButton(
                text: AppStrings.logout,
                backgroundColor: AppColors.error,
                prefixIcon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  Get.defaultDialog(
                    title: AppStrings.logout,
                    middleText: AppStrings.logoutConfirm,
                    textConfirm: 'Yes',
                    textCancel: 'Cancel',
                    confirmTextColor: Colors.white,
                    buttonColor: AppColors.error,
                    onConfirm: () {
                      Get.back(); // close dialog
                      controller.logout();
                    },
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
