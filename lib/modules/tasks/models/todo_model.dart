/// Todo Data Model
/// Priority :
/// 1 = Low
/// 2 = Medium
/// 3 = High
/// Represents a row of the Supabase `todos` table and the GetStorage cache.
class TodoModel {
  /// Null for a new todo; Supabase generates it (gen_random_uuid()).
  final String? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final int priority;
  final DateTime? dueDate;
  final String? category;

  /// Null for a new todo; Supabase sets them (now()).
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TodoModel({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = 1,
    this.dueDate,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  /// Supabase / GetStorage Map -> TodoModel
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false,
      priority: json['priority'] as int? ?? 1,
      dueDate: _parseDate(json['due_date']),
      category: json['category'] as String?,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  /// TodoModel -> Map for Supabase / GetStorage.
  /// `id`, `created_at` and `updated_at` are omitted while null so that
  /// Supabase can apply its column defaults on insert.
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'priority': priority,
      'due_date': dueDate?.toUtc().toIso8601String(),
      'category': category,
      if (createdAt != null) 'created_at': createdAt!.toUtc().toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toUtc().toIso8601String(),
    };
  }

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    int? priority,
    DateTime? dueDate,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.parse(value as String).toLocal();
  }
}
