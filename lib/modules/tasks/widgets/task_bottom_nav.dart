import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../controller/task_controller.dart';

/// Floating Bottom Navigation Bar Widget
///
/// Features 3 destinations: 'Tasks', 'Completed', and 'Settings'
/// with custom active pill container and circular icons.
class TaskBottomNav extends GetView<TaskController> {
  const TaskBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final currentIndex = controller.selectedNavIndex.value;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Tasks Tab (Index 0)
            _buildNavItem(
              index: 0,
              label: AppStrings.navTasks,
              icon: Icons.check,
              isSelected: currentIndex == 0,
            ),

            // Completed Tab (Index 1)
            _buildNavItem(
              index: 1,
              label: AppStrings.navCompleted,
              icon: Icons.star_rounded,
              isSelected: currentIndex == 1,
            ),

            // Settings Tab (Index 2)
            _buildNavItem(
              index: 2,
              label: AppStrings.navSettings,
              icon: Icons.settings_rounded,
              isSelected: currentIndex == 2,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => controller.setNavIndex(index),
      behavior: HitTestBehavior.opaque,
      child: isSelected
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1EFE9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: AppColors.inactiveNav,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inactiveNav,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
