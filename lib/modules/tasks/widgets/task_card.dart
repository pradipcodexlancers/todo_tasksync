import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../controller/task_controller.dart';
import '../models/todo_model.dart';
import 'task_form_sheet.dart';

/// Task Item Card Widget
///
/// Renders an individual task with its checkbox, title, priority pill,
/// subtitle, tags, due date, and sync status.
class TaskCard extends GetView<TaskController> {
  final TodoModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.035), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rounded Checkbox
          GestureDetector(
            onTap: () => controller.toggleTask(task.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: task.isCompleted ? AppColors.checkboxCheckedBg : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: task.isCompleted ? AppColors.checkboxCheckedBg : AppColors.checkboxBorder,
                  width: 1.6,
                ),
              ),
              child: task.isCompleted ? const Icon(Icons.check, size: 17, color: Colors.white) : null,
            ),
          ),

          const SizedBox(width: 14),

          // Main Task Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title, Priority Pill & Options Menu
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Task Title
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: task.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                          decorationColor: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Priority Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: task.priorityBgColor, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(color: task.priorityTextColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.priorityLabel,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: task.priorityTextColor),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 4),

                    // 3 Vertical Dots Menu
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 18, color: AppColors.inactiveNav),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onSelected: (value) {
                        if (value == 'toggle') {
                          controller.toggleTask(task.key);
                        } else if (value == 'edit') {
                          TaskFormSheet.show(context, todo: task);
                        } else if (value == 'delete') {
                          controller.deleteTask(task.key);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'toggle',
                          child: Text(
                            task.isCompleted ? 'Mark as Incomplete' : 'Mark as Done',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit Task', style: TextStyle(fontSize: 13)),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Task', style: TextStyle(fontSize: 13, color: Colors.red)),
                        ),
                      ],
                    ),
                  ],
                ),

                // Description / Notes
                if (task.description?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description!,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3),
                  ),
                ],

                const SizedBox(height: 10),

                // Bottom Row: Tag Badge, Date, and Pending Sync
                Row(
                  children: [
                    // Category Tag Badge
                    if (task.category != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(color: task.tagBgColor, borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          task.category!,
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: task.tagTextColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Due Date / Done Info
                    Text(
                      task.dueText,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                    ),

                    const Spacer(),

                    // Pending Sync Badge
                    if (task.isPendingSync)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.pendingSyncBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Pending Sync',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.pendingSyncText),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
