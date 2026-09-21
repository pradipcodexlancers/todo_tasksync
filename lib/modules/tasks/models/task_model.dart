import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

enum TaskPriority { high, medium, low }

enum TaskSyncStatus { none, pendingSync, synced }

/// Task Data Model
class TaskModel {
  final String id;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final TaskPriority priority;
  final String tag;
  final String dueText;
  final TaskSyncStatus syncStatus;

  const TaskModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    required this.priority,
    required this.tag,
    required this.dueText,
    this.syncStatus = TaskSyncStatus.none,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    bool? isCompleted,
    TaskPriority? priority,
    String? tag,
    String? dueText,
    TaskSyncStatus? syncStatus,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      tag: tag ?? this.tag,
      dueText: dueText ?? this.dueText,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  // Helper getters for UI presentation
  String get priorityLabel {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  Color get priorityBgColor {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.priorityHighBg;
      case TaskPriority.medium:
        return AppColors.priorityMedBg;
      case TaskPriority.low:
        return AppColors.priorityLowBg;
    }
  }

  Color get priorityTextColor {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.priorityHighText;
      case TaskPriority.medium:
        return AppColors.priorityMedText;
      case TaskPriority.low:
        return AppColors.priorityLowText;
    }
  }

  Color get tagBgColor {
    switch (tag.toLowerCase()) {
      case 'work':
        return AppColors.tagWorkBg;
      case 'study':
        return AppColors.tagStudyBg;
      case 'personal':
        return AppColors.tagPersonalBg;
      default:
        return AppColors.primaryLight;
    }
  }

  Color get tagTextColor {
    switch (tag.toLowerCase()) {
      case 'work':
        return AppColors.tagWorkText;
      case 'study':
        return AppColors.tagStudyText;
      case 'personal':
        return AppColors.tagPersonalText;
      default:
        return AppColors.primary;
    }
  }
}
