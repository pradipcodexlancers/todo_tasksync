import 'package:get/get.dart';
import '../models/task_model.dart';

/// Task Controller
///
/// Manages reactive state for the tasks list, active filter,
/// bottom navigation bar, and task status toggles.
class TaskController extends GetxController {
  // Reactive list of tasks
  final RxList<TaskModel> tasks = <TaskModel>[].obs;

  // Active filter tab: 'All', 'Today', 'Pending', 'High Priority'
  final RxString selectedFilter = 'All'.obs;

  // Active bottom navigation index: 0 = Tasks, 1 = Completed, 2 = Settings
  final RxInt selectedNavIndex = 0.obs;

  // Sync state indication
  final RxBool isSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleTasks();
  }

  /// Initialize tasks exactly as depicted in the reference design
  void _loadSampleTasks() {
    tasks.assignAll([
      const TaskModel(
        id: '1',
        title: 'Complete Flutter Project',
        subtitle: 'Finish offline sync implementation',
        isCompleted: false,
        priority: TaskPriority.high,
        tag: 'Work',
        dueText: 'Today',
        syncStatus: TaskSyncStatus.pendingSync,
      ),
      const TaskModel(
        id: '2',
        title: 'Review design system tokens',
        subtitle: 'Audit spacing, radius and color scale across screens',
        isCompleted: false,
        priority: TaskPriority.medium,
        tag: 'Study',
        dueText: 'Tomorrow',
        syncStatus: TaskSyncStatus.none,
      ),
      const TaskModel(
        id: '3',
        title: 'Book dentist appointment',
        subtitle: 'Personal errand',
        isCompleted: true,
        priority: TaskPriority.low,
        tag: 'Personal',
        dueText: 'Done · 10:32 AM',
        syncStatus: TaskSyncStatus.none,
      ),
      const TaskModel(
        id: '4',
        title: 'Prepare sync demo slides',
        subtitle: 'Show offline -> Supabase -> cache flow',
        isCompleted: false,
        priority: TaskPriority.high,
        tag: 'Work',
        dueText: 'Fri, 14 Mar',
        syncStatus: TaskSyncStatus.none,
      ),
    ]);
  }

  /// Reset to initial demo tasks
  void resetSampleTasks() {
    _loadSampleTasks();
  }

  /// Clear all completed tasks
  void clearCompletedTasks() {
    tasks.removeWhere((t) => t.isCompleted);
  }

  /// Filtered tasks computed property
  List<TaskModel> get filteredTasks {
    // If user selected 'Completed' bottom navigation tab
    if (selectedNavIndex.value == 1) {
      return tasks.where((t) => t.isCompleted).toList();
    }

    switch (selectedFilter.value) {
      case 'Today':
        return tasks.where((t) => t.dueText.toLowerCase().contains('today')).toList();
      case 'Pending':
        return tasks.where((t) => !t.isCompleted).toList();
      case 'High Priority':
        return tasks.where((t) => t.priority == TaskPriority.high).toList();
      case 'All':
      default:
        return tasks;
    }
  }

  /// Toggle task completed status
  void toggleTask(String id) {
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = tasks[index];
      final newStatus = !task.isCompleted;
      tasks[index] = task.copyWith(
        isCompleted: newStatus,
        dueText: newStatus ? 'Done · just now' : 'Today',
      );
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

  /// Add a new task to the list
  void addTask({
    required String title,
    required String subtitle,
    required TaskPriority priority,
    required String tag,
    required String dueText,
  }) {
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      subtitle: subtitle,
      priority: priority,
      tag: tag,
      dueText: dueText,
      syncStatus: TaskSyncStatus.pendingSync,
    );
    tasks.insert(0, newTask);
  }

  /// Sort tasks by priority (High -> Medium -> Low)
  void sortByPriority() {
    tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));
  }

  /// Simulate manual sync
  Future<void> triggerSync() async {
    isSyncing.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isSyncing.value = false;
  }
}
