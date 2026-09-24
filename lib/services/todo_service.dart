import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../modules/tasks/models/todo_model.dart';
import 'storage_service.dart';

/// Todo Service (Supabase)
///
/// Calls the Postgres functions created in Supabase:
/// `get_my_todos`, `create_todo`, `update_todo`, `delete_todo`.
/// Row Level Security still applies because they are `security invoker`.
class TodoService extends GetxService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final StorageService _storage = Get.find<StorageService>();

  /// Logged-in user id, saved in SharedPreferences at login
  String get _userId => _storage.userId!;

  /// All todos of the logged-in user (newest first)
  Future<List<TodoModel>> getMyTodos() async {
    final data = await _supabase.rpc('get_my_todos') as List<dynamic>;
    return data.map((row) => TodoModel.fromJson(Map<String, dynamic>.from(row as Map))).toList();
  }

  /// Insert a todo and return the saved row (with id / timestamps)
  Future<TodoModel> createTodo(TodoModel todo) async {
    final data = await _supabase.rpc(
      'create_todo',
      params: {
        'p_user_id': todo.userId ?? _userId,
        'p_title': todo.title,
        'p_description': todo.description,
        'p_is_completed': todo.isCompleted,
        'p_priority': todo.priority,
        'p_due_date': todo.dueDate?.toUtc().toIso8601String(),
        'p_category': todo.category,
      },
    );
    return TodoModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  /// Update a todo (null fields are kept as they are by `update_todo`)
  Future<TodoModel> updateTodo(TodoModel todo) async {
    final data = await _supabase.rpc(
      'update_todo',
      params: {
        'p_id': todo.id,
        'p_user_id': todo.userId ?? _userId,
        'p_title': todo.title,
        'p_description': todo.description,
        'p_is_completed': todo.isCompleted,
        'p_priority': todo.priority,
        'p_due_date': todo.dueDate?.toUtc().toIso8601String(),
        'p_category': todo.category,
      },
    );
    final row = Map<String, dynamic>.from(data as Map);
    // `update_todo` returns an all-null row when the todo no longer exists
    if (row['id'] == null) {
      throw const PostgrestException(message: 'This task no longer exists.');
    }
    return TodoModel.fromJson(row);
  }

  /// Delete a todo, returns false if no row was deleted
  Future<bool> deleteTodo(String id) async {
    final data = await _supabase.rpc(
      'delete_todo',
      params: {'p_id': id, 'p_user_id': _userId},
    );
    return data as bool;
  }
}
