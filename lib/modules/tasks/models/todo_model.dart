import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// Change that still has to be pushed to Supabase (offline edits)
enum SyncAction { none, create, update, delete }

/// Todo Data Model
/// Priority :
/// 1 = Low
/// 2 = Medium
/// 3 = High
/// Represents a row of the Supabase `todos` table and the GetStorage cache.
class TodoModel {
  static const int priorityLow = 1;
  static const int priorityMedium = 2;
  static const int priorityHigh = 3;

  /// Null for a todo created offline; Supabase generates it (gen_random_uuid()).
  final String? id;

  /// Owner of the todo (Supabase auth user id)
  final String? userId;
  final String title;
  final String? description;
  final bool isCompleted;
  final int priority;
  final DateTime? dueDate;
  final String? category;

  /// Null for a new todo; Supabase sets them (now()).
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Local-only: identifies a todo created offline until Supabase gives it an [id]
  final String? localId;

  /// Local-only: pending change to push on the next sync
  final SyncAction syncAction;

  const TodoModel({
    this.id,
    this.userId,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = priorityLow,
    this.dueDate,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.localId,
    this.syncAction = SyncAction.none,
  });

  /// Stable key for lists / lookups (server id, or local id while offline)
  String get key => id ?? localId!;

  bool get isPendingSync => syncAction != SyncAction.none;

  /// Supabase / GetStorage Map -> TodoModel
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false,
      priority: json['priority'] as int? ?? priorityLow,
      dueDate: _parseDate(json['due_date']),
      category: json['category'] as String?,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      localId: json['local_id'] as String?,
      syncAction: SyncAction.values.byName(json['sync_action'] as String? ?? SyncAction.none.name),
    );
  }

  /// TodoModel -> Map for GetStorage (includes the local sync fields)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'priority': priority,
      'due_date': dueDate?.toUtc().toIso8601String(),
      'category': category,
      if (createdAt != null) 'created_at': createdAt!.toUtc().toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toUtc().toIso8601String(),
      if (localId != null) 'local_id': localId,
      'sync_action': syncAction.name,
    };
  }

  TodoModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    bool? isCompleted,
    int? priority,
    DateTime? dueDate,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? localId,
    SyncAction? syncAction,
  }) {
    return TodoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      localId: localId ?? this.localId,
      syncAction: syncAction ?? this.syncAction,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.parse(value as String).toLocal();
  }

  // Helper getters for UI presentation

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year && dueDate!.month == now.month && dueDate!.day == now.day;
  }

  String get dueText {
    if (isCompleted) return 'Done';
    if (dueDate == null) return 'No due date';
    if (isDueToday) return 'Today';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    final diff = due.difference(today).inDays;
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';

    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${weekdays[due.weekday - 1]}, ${due.day} ${months[due.month - 1]}';
  }

  static String labelForPriority(int priority) {
    switch (priority) {
      case priorityHigh:
        return 'High';
      case priorityMedium:
        return 'Medium';
      default:
        return 'Low';
    }
  }

  String get priorityLabel => labelForPriority(priority);

  Color get priorityBgColor {
    switch (priority) {
      case priorityHigh:
        return AppColors.priorityHighBg;
      case priorityMedium:
        return AppColors.priorityMedBg;
      default:
        return AppColors.priorityLowBg;
    }
  }

  Color get priorityTextColor {
    switch (priority) {
      case priorityHigh:
        return AppColors.priorityHighText;
      case priorityMedium:
        return AppColors.priorityMedText;
      default:
        return AppColors.priorityLowText;
    }
  }

  Color get tagBgColor {
    switch (category?.toLowerCase()) {
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
    switch (category?.toLowerCase()) {
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
