import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../services/auth_service.dart';
import '../controller/task_controller.dart';

/// Task Screen Header
///
/// Displays the title, subtitle, sync indicator badge, avatar, and options button.
class TaskHeader extends GetView<TaskController> {
  const TaskHeader({super.key});

  AuthService get _auth => Get.find<AuthService>();

  String get _initial {
    final source = _auth.userName.isNotEmpty ? _auth.userName : _auth.userEmail;
    return source.isEmpty ? '?' : source[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: Title & Subtitle + Action Buttons
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.myTasks,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.appTagline,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13.5,
                        ),
                  ),
                ],
              ),
            ),

            // Top Right Actions (Avatar 'A' + More options '...')
            Row(
              children: [
                // Avatar 'A' - Clickable
                GestureDetector(
                  onTap: () => _showProfileBottomSheet(context),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.circleButtonBg,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _initial,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // More Options (...) Button - Clickable with high-contrast bottom sheet
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.circleButtonBg,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.more_horiz,
                      color: AppColors.iconLight,
                      size: 22,
                    ),
                    onPressed: () => _showOptionsMenu(context),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Synced badge pill
        Obx(() {
          final isSyncing = controller.isSyncing.value;
          final isOnline = controller.isOnline.value;
          final pendingCount = controller.pendingSyncCount;
          final String label;
          if (isSyncing) {
            label = 'Syncing...';
          } else if (!isOnline) {
            label = pendingCount > 0 ? 'Offline - $pendingCount pending' : 'Offline';
          } else if (pendingCount > 0) {
            label = '$pendingCount pending sync';
          } else {
            label = AppStrings.syncedJustNow;
          }
          final isWarning = !isOnline || pendingCount > 0;

          return GestureDetector(
            onTap: controller.syncTodos,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isWarning ? AppColors.pendingSyncBg : AppColors.syncBadgeBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isWarning ? AppColors.pendingSyncText : AppColors.syncBadgeDot,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: isWarning ? AppColors.pendingSyncText : AppColors.syncBadgeText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  /// Profile Details Bottom Sheet when Avatar 'A' is clicked
  void _showProfileBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: const BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Avatar Circle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _initial,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Name & Email
              Text(
                _auth.userName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _auth.userEmail,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // Quick Stats
              Obx(() {
                final total = controller.tasks.length;
                final completed = controller.tasks.where((t) => t.isCompleted).length;
                final pending = total - completed;

                return Row(
                  children: [
                    _buildStatCard('Total Tasks', '$total', AppColors.primary),
                    const SizedBox(width: 12),
                    _buildStatCard('Completed', '$completed', AppColors.success),
                    const SizedBox(width: 12),
                    _buildStatCard('Pending', '$pending', AppColors.error),
                  ],
                );
              }),

              const SizedBox(height: 20),

              // Actions
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.settings_outlined, color: AppColors.primary, size: 20),
                ),
                title: const Text(
                  'Go to Settings',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: const Text(
                  'Configure cloud sync and notifications',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.inactiveNav),
                onTap: () {
                  Get.back();
                  controller.setNavIndex(2); // Switches to Settings tab
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 3-Dot Options Bottom Sheet
  void _showOptionsMenu(BuildContext context) {
    Get.bottomSheet(
      Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Task Actions',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Sync Now
              _buildMenuTile(
                icon: Icons.sync,
                iconColor: AppColors.primary,
                title: 'Sync Now',
                subtitle: 'Trigger instant synchronization with cloud',
                onTap: () {
                  Get.back();
                  controller.syncTodos();
                },
              ),

              // Sort by Priority
              _buildMenuTile(
                icon: Icons.sort_rounded,
                iconColor: const Color(0xFFF59E0B),
                title: 'Sort by Priority',
                subtitle: 'Arrange High, Medium, Low tasks',
                onTap: () {
                  Get.back();
                  controller.sortByPriority();
                },
              ),

              // Open Settings
              _buildMenuTile(
                icon: Icons.settings_outlined,
                iconColor: AppColors.primary,
                title: 'Settings',
                subtitle: 'Sync preferences, dark mode, and account',
                onTap: () {
                  Get.back();
                  controller.setNavIndex(2); // Switches to Settings tab
                },
              ),

              // Clear Completed
              _buildMenuTile(
                icon: Icons.delete_sweep_outlined,
                iconColor: Colors.redAccent,
                title: 'Clear Completed Tasks',
                subtitle: 'Remove all checked off items',
                onTap: () {
                  Get.back();
                  controller.clearCompletedTasks();
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      onTap: onTap,
    );
  }
}
