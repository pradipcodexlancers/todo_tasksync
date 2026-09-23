import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../modules/tasks/models/todo_model.dart';

/// Local Storage Service (GetStorage)
///
/// Only responsible for saving, reading and clearing todos on the device.
class LocalStorageService extends GetxService {
  static const String keyTodos = 'todos';

  late final GetStorage _box;

  /// Initialize GetStorage. Called once before `runApp()`.
  Future<LocalStorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  /// Save the given todos locally (replaces the previous list)
  Future<void> saveTodos(List<TodoModel> todos) async {
    await _box.write(keyTodos, todos.map((todo) => todo.toJson()).toList());
  }

  /// Read all locally saved todos (empty list if nothing is saved)
  List<TodoModel> getTodos() {
    final data = _box.read<List<dynamic>>(keyTodos);
    if (data == null) return [];

    return data.map((item) => TodoModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }

  /// Remove all locally saved todos
  Future<void> clearTodos() async {
    await _box.remove(keyTodos);
  }
}
