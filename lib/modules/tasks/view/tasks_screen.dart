import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/common_loader.dart';
import '../controller/task_controller.dart';
import '../widgets/completed_tab_view.dart';
import '../widgets/filter_chip_bar.dart';
import '../widgets/settings_tab_view.dart';
import '../widgets/task_bottom_nav.dart';
import '../widgets/task_card.dart';
import '../widgets/task_form_sheet.dart';
import '../widgets/task_header.dart';

/// Tasks Screen
///
/// Main view with reactive tab switching:
/// - Index 0: My Tasks Dashboard (matches screenshot)
/// - Index 1: Completed Tasks Tab
/// - Index 2: Settings Tab
class TasksScreen extends GetView<TaskController> {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          switch (controller.selectedNavIndex.value) {
            case 0:
              return _buildTasksTab(context);
            case 1:
              return const CompletedTabView();
            case 2:
              return const SettingsTabView();
            default:
              return _buildTasksTab(context);
          }
        }),
      ),
      bottomNavigationBar: const SafeArea(
        top: false,
        child: TaskBottomNav(),
      ),
    );
  }

  /// Primary Tasks Tab (matching the user's reference design)
  Widget _buildTasksTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Header Section (Title, Subtitle, Sync pill, Avatar & Actions)
          const TaskHeader(),

          const SizedBox(height: 18),

          // Filter Chips Row (All, Today, Pending, High Priority)
          const FilterChipBar(),

          const SizedBox(height: 16),

          // Scrollable Task List
          Expanded(
            child: Obx(() {
              final tasks = controller.filteredTasks;

              if (controller.isLoading.value) {
                return const CommonLoader(message: 'Loading your tasks...');
              }

              if (tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 64,
                        color: AppColors.inactiveNav.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No tasks found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    key: ValueKey(task.key),
                    task: task,
                  );
                },
              );
            }),
          ),

          // Add Task Button
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
            child: _buildAddTaskButton(context),
          ),
        ],
      ),
    );
  }

  /// Full-width vibrant Add Task Button
  Widget _buildAddTaskButton(BuildContext context) {
    return GestureDetector(
      onTap: () => TaskFormSheet.show(context),
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.32),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.24),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              AppStrings.addTask,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
