import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/utils/error_handler.dart';
import '../../../services/auth_service.dart';
import '../controller/task_controller.dart';

/// Settings Tab View
///
/// Complete Settings UI with Account info, Sync preferences, Theme toggle,
/// task management, and application details.
class SettingsTabView extends GetView<TaskController> {
  const SettingsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();
    final initialSource = auth.userName.isNotEmpty ? auth.userName : auth.userEmail;
    final initial = initialSource.isEmpty ? '?' : initialSource[0].toUpperCase();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Screen Title
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage your preferences and synchronization',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13.5,
            ),
          ),

          const SizedBox(height: 20),

          // User Profile Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auth.userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        auth.userEmail,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.syncBadgeBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.syncBadgeText,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Sync Section
          _buildSectionHeader('Cloud & Sync'),
          const SizedBox(height: 10),
          _buildSettingsCard(
            children: [
              _buildSwitchTile(
                icon: Icons.sync,
                title: 'Auto Sync',
                subtitle: 'Automatically sync tasks in real-time',
                value: true,
                onChanged: (val) {},
              ),
              const Divider(height: 1, indent: 56, endIndent: 16),
              _buildTapTile(
                icon: Icons.cloud_done_outlined,
                title: 'Sync Now',
                subtitle: 'Push pending changes to cloud',
                trailing: Obx(() => Text(
                      controller.isSyncing.value
                          ? 'Syncing...'
                          : controller.pendingSyncCount > 0
                              ? '${controller.pendingSyncCount} pending'
                              : 'Synced',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.syncBadgeText,
                      ),
                    )),
                onTap: controller.syncTodos,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Preferences Section
          _buildSectionHeader('Preferences'),
          const SizedBox(height: 10),
          _buildSettingsCard(
            children: [
              _buildSwitchTile(
                icon: Icons.notifications_outlined,
                title: 'Reminders & Notifications',
                subtitle: 'Get alerts for due tasks',
                value: true,
                onChanged: (val) {},
              ),
              const Divider(height: 1, indent: 56, endIndent: 16),
              _buildSwitchTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: 'Toggle dark interface appearance',
                value: Get.isDarkMode,
                onChanged: (isDark) {
                  Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Data Management Section
          _buildSectionHeader('Data Management'),
          const SizedBox(height: 10),
          _buildSettingsCard(
            children: [
              _buildTapTile(
                icon: Icons.delete_outline_rounded,
                iconColor: Colors.redAccent,
                title: 'Clear Completed Tasks',
                titleColor: Colors.redAccent,
                subtitle: 'Remove all finished tasks permanently',
                onTap: () {
                  controller.clearCompletedTasks();
                  Get.snackbar(
                    'Cleared',
                    'Completed tasks removed',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.cardSurface,
                    colorText: AppColors.textPrimary,
                    margin: const EdgeInsets.all(16),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Account Section
          _buildSectionHeader('Account'),
          const SizedBox(height: 10),
          _buildSettingsCard(
            children: [
              _buildTapTile(
                icon: Icons.logout_rounded,
                iconColor: Colors.redAccent,
                title: 'Logout',
                titleColor: Colors.redAccent,
                subtitle: 'Sign out of your account',
                onTap: () async {
                  final unsavedCount = controller.pendingSyncCount;
                  final confirmed = await AppUtils.showConfirmDialog(
                    title: 'Log out?',
                    message: unsavedCount > 0
                        ? 'You have $unsavedCount ${unsavedCount == 1 ? 'change' : 'changes'} that '
                            'haven\'t been saved online yet (you were offline).\n\n'
                            'If you log out now, ${unsavedCount == 1 ? 'it' : 'they'} will be lost. '
                            'Connect to the internet first to keep ${unsavedCount == 1 ? 'it' : 'them'}.'
                        : 'Your tasks will be removed from this device.\n\n'
                            'Don\'t worry, they are safely saved in your account and will come back '
                            'when you log in again.',
                    confirmText: unsavedCount > 0 ? 'Log out anyway' : 'Log out',
                  );
                  if (!confirmed) return;

                  try {
                    // AuthService navigates to login when the session ends
                    await Get.find<AuthService>().logout();
                  } catch (e) {
                    AppErrorHandler.show(e, title: 'Logout failed');
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // App Info
          Center(
            child: Column(
              children: const [
                Text(
                  'TaskSync v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Offline-first Flutter & GetX Architecture',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTapTile({
    required IconData icon,
    Color? iconColor,
    required String title,
    Color? titleColor,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: AppColors.inactiveNav,
                ),
          ],
        ),
      ),
    );
  }
}
