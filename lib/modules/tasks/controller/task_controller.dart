import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/error_handler.dart';
import '../../../services/local_storage_service.dart';
import '../../../services/storage_service.dart';
import '../../../services/todo_service.dart';
import '../models/todo_model.dart';

/// Task Controller
///
/// Offline-first todo state:
/// 1. Every add / update / delete is applied to the list and saved in GetStorage
///    first, marked with a pending [SyncAction].
/// 2. [syncTodos] pushes the pending changes to Supabase and then replaces the
///    local list with the fresh server data (pending flags are gone after that).
/// 3. When there is no internet the changes stay pending and are pushed
///    automatically as soon as the device is back online.
class TaskController extends GetxController {
  final TodoService _todoService = Get.find<TodoService>();
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  final StorageService _storage = Get.find<StorageService>();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // All todos, including the ones waiting to be deleted on the server
  final RxList<TodoModel> _todos = <TodoModel>[].obs;

  // Active filter tab: 'All', 'Today', 'Pending', 'High Priority'
  final RxString selectedFilter = 'All'.obs;

  // Active bottom navigation index: 0 = Tasks, 1 = Completed, 2 = Settings
  final RxInt selectedNavIndex = 0.obs;

  // Sync / network state
  final RxBool isLoading = false.obs;
  final RxBool isSyncing = false.obs;
  final RxBool isOnline = true.obs;

  // Set when a sync is requested while another one is running
  bool _syncRequested = false;

  /// Todos visible in the UI (pending deletes are hidden)
  List<TodoModel> get tasks => _todos.where((t) => t.syncAction != SyncAction.delete).toList();

  int get pendingSyncCount => _todos.where((t) => t.isPendingSync).length;

  @override
  void onInit() {
    super.onInit();
    // Show cached todos instantly (works offline), then sync with Supabase
    _todos.assignAll(_localStorage.getTodos());
    isLoading.value = _todos.isEmpty;
    _listenConnectivity();
    syncTodos();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  void _listenConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      final wasOnline = isOnline.value;
      isOnline.value = !results.contains(ConnectivityResult.none);
      // Back online -> push offline changes automatically
      if (!wasOnline && isOnline.value) syncTodos();
    });
  }

  /// Filtered tasks computed property
  List<TodoModel> get filteredTasks {
    final visible = tasks;

    // If user selected 'Completed' bottom navigation tab
    if (selectedNavIndex.value == 1) {
      return visible.where((t) => t.isCompleted).toList();
    }

    switch (selectedFilter.value) {
      case 'Today':
        return visible.where((t) => t.isDueToday).toList();
      case 'Pending':
        return visible.where((t) => !t.isCompleted).toList();
      case 'High Priority':
        return visible.where((t) => t.priority == TodoModel.priorityHigh).toList();
      case 'All':
      default:
        return visible;
    }
  }

  /// Change active filter
  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  /// Change active bottom navigation tab
  void setNavIndex(int index) {
    selectedNavIndex.value = index;
  }

  // ---------------------------------------------------------------------------
  // CRUD (local first, then sync)
  // ---------------------------------------------------------------------------

  /// Add a new todo
  Future<void> addTask({
    required String title,
    String? description,
    required int priority,
    String? category,
    DateTime? dueDate,
  }) async {
    final todo = TodoModel(
      localId: 'local_${DateTime.now().microsecondsSinceEpoch}',
      userId: _storage.userId,
      title: title,
      description: description,
      priority: priority,
      category: category,
      dueDate: dueDate,
      createdAt: DateTime.now(),
      syncAction: SyncAction.create,
    );
    _todos.insert(0, todo);
    await _saveLocally();
    syncTodos();
  }

  /// Save an edited todo
  Future<void> updateTask(TodoModel updated) async {
    final index = _todos.indexWhere((t) => t.key == updated.key);
    if (index == -1) return;

    // A todo that never reached the server is still a "create"
    final action = _todos[index].syncAction == SyncAction.create ? SyncAction.create : SyncAction.update;
    _todos[index] = updated.copyWith(syncAction: action, updatedAt: DateTime.now());
    await _saveLocally();
    syncTodos();
  }

  /// Toggle task completed status
  Future<void> toggleTask(String key) async {
    final todo = _todos.firstWhereOrNull((t) => t.key == key);
    if (todo == null) return;
    await updateTask(todo.copyWith(isCompleted: !todo.isCompleted));
  }

  /// Delete a todo
  Future<void> deleteTask(String key) async {
    _markDeleted(key);
    await _saveLocally();
    syncTodos();
  }

  /// Delete all completed todos
  Future<void> clearCompletedTasks() async {
    for (final todo in tasks.where((t) => t.isCompleted)) {
      _markDeleted(todo.key);
    }
    await _saveLocally();
    syncTodos();
  }

  void _markDeleted(String key) {
    final index = _todos.indexWhere((t) => t.key == key);
    if (index == -1) return;

    // Never reached the server -> just drop it locally
    if (_todos[index].id == null) {
      _todos.removeAt(index);
    } else {
      _todos[index] = _todos[index].copyWith(syncAction: SyncAction.delete);
    }
  }

  /// Sort tasks by priority (High -> Medium -> Low)
  void sortByPriority() {
    _todos.sort((a, b) => b.priority.compareTo(a.priority));
  }

  // ---------------------------------------------------------------------------
  // Sync
  // ---------------------------------------------------------------------------

  /// Push pending changes to Supabase, then reload todos from the server
  Future<void> syncTodos() async {
    if (isSyncing.value) {
      _syncRequested = true;
      return;
    }

    isSyncing.value = true;
    try {
      await _pushPendingChanges();

      final serverTodos = await _todoService.getMyTodos();

      // Keep changes made while this sync was running, server data for the rest
      final pending = _todos.where((t) => t.isPendingSync).toList();
      final pendingIds = pending.map((t) => t.id).whereType<String>().toSet();
      _todos.assignAll([
        ...pending,
        ...serverTodos.where((t) => !pendingIds.contains(t.id)),
      ]);
      await _saveLocally();
      isOnline.value = true;
    } on PostgrestException catch (e) {
      AppErrorHandler.show(e, title: 'Sync failed');
    } catch (_) {
      // No internet: changes stay pending and are pushed when back online
      isOnline.value = false;
    } finally {
      isSyncing.value = false;
      isLoading.value = false;
    }

    if (_syncRequested) {
      _syncRequested = false;
      await syncTodos();
    }
  }

  /// Push every pending change one by one, saving progress after each call so
  /// a connection drop in the middle never sends the same change twice.
  Future<void> _pushPendingChanges() async {
    final pending = _todos.where((t) => t.isPendingSync).toList();

    for (final todo in pending) {
      try {
        switch (todo.syncAction) {
          case SyncAction.create:
            final created = await _todoService.createTodo(todo);
            _replace(todo.key, created);
          case SyncAction.update:
            final updated = await _todoService.updateTodo(todo);
            _replace(todo.key, updated);
          case SyncAction.delete:
            await _todoService.deleteTodo(todo.id!);
            _todos.removeWhere((t) => t.key == todo.key);
          case SyncAction.none:
            break;
        }
      } on PostgrestException catch (e) {
        // Server rejected this change: drop it, the server copy wins on reload
        _todos.removeWhere((t) => t.key == todo.key);
        AppErrorHandler.show(e, title: 'Could not sync "${todo.title}"');
      }
      await _saveLocally();
    }
  }

  void _replace(String key, TodoModel serverTodo) {
    final index = _todos.indexWhere((t) => t.key == key);
    if (index != -1) _todos[index] = serverTodo;
  }

  Future<void> _saveLocally() => _localStorage.saveTodos(_todos);
}
