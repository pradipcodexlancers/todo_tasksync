import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/task_controller.dart';
import '../models/todo_model.dart';

/// Add / Edit Task Bottom Sheet
///
/// Opens empty to create a task, or pre-filled with [todo] to update it.
class TaskFormSheet {
  TaskFormSheet._();

  static const List<String> categories = ['Work', 'Study', 'Personal'];
  static const List<int> priorities = [
    TodoModel.priorityHigh,
    TodoModel.priorityMedium,
    TodoModel.priorityLow,
  ];

  static void show(BuildContext context, {TodoModel? todo}) {
    final controller = Get.find<TaskController>();
    final isEdit = todo != null;

    final titleController = TextEditingController(text: todo?.title);
    final descriptionController = TextEditingController(text: todo?.description);
    final selectedPriority = (todo?.priority ?? TodoModel.priorityMedium).obs;
    final selectedCategory = RxnString(todo?.category ?? categories.first);
    final selectedDueDate = Rxn<DateTime>(todo?.dueDate ?? (isEdit ? null : DateTime.now()));

    Get.bottomSheet(
      Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Drag Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEdit ? 'Edit Task' : 'Create New Task',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Task Title Field
                _buildTextField(
                  controller: titleController,
                  label: 'Task Title',
                  hint: 'e.g. Complete Flutter Project',
                  autofocus: !isEdit,
                  isTitle: true,
                ),
                const SizedBox(height: 14),

                // Description Field
                _buildTextField(
                  controller: descriptionController,
                  label: 'Description / Notes',
                  hint: 'e.g. Finish offline sync implementation',
                ),
                const SizedBox(height: 18),

                // Priority Selection
                _buildSectionLabel('Priority'),
                const SizedBox(height: 8),
                Obx(() => Row(
                      children: priorities
                          .map((priority) => _buildChoiceChip(
                                label: TodoModel.labelForPriority(priority),
                                isSelected: selectedPriority.value == priority,
                                onTap: () => selectedPriority.value = priority,
                              ))
                          .toList(),
                    )),
                const SizedBox(height: 16),

                // Category Selection
                _buildSectionLabel('Tag'),
                const SizedBox(height: 8),
                Obx(() => Row(
                      children: categories
                          .map((category) => _buildChoiceChip(
                                label: category,
                                isSelected: selectedCategory.value == category,
                                onTap: () => selectedCategory.value = category,
                              ))
                          .toList(),
                    )),
                const SizedBox(height: 16),

                // Due Date Selection
                _buildSectionLabel('Due Date'),
                const SizedBox(height: 8),
                Obx(() {
                  final dueDate = selectedDueDate.value;
                  return GestureDetector(
                    onTap: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: dueDate ?? now,
                        firstDate: DateTime(now.year - 1),
                        lastDate: DateTime(now.year + 5),
                      );
                      if (picked != null) selectedDueDate.value = picked;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: 10),
                          Text(
                            dueDate == null
                                ? 'No due date'
                                : TodoModel(title: '', dueDate: dueDate).dueText,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // Save Task Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      final title = titleController.text.trim();
                      if (title.isEmpty) return;
                      final description = descriptionController.text.trim();

                      if (isEdit) {
                        controller.updateTask(todo.copyWith(
                          title: title,
                          description: description,
                          priority: selectedPriority.value,
                          category: selectedCategory.value,
                          dueDate: selectedDueDate.value,
                        ));
                      } else {
                        controller.addTask(
                          title: title,
                          description: description.isEmpty ? null : description,
                          priority: selectedPriority.value,
                          category: selectedCategory.value,
                          dueDate: selectedDueDate.value,
                        );
                      }
                      Get.back();
                    },
                    child: Text(
                      isEdit ? 'Update Task' : 'Save Task',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  static Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool autofocus = false,
    bool isTitle = false,
  }) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      style: TextStyle(
        fontSize: isTitle ? 15 : 14,
        fontWeight: isTitle ? FontWeight.w600 : FontWeight.normal,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
        filled: true,
        fillColor: AppColors.scaffoldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  static Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  static Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.scaffoldBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
        ),
      ),
    );
  }
}
