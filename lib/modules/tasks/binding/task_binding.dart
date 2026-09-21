import 'package:get/get.dart';
import '../controller/task_controller.dart';

/// Task Binding
///
/// Lazily injects [TaskController] into memory when navigating to the Tasks module.
class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskController>(() => TaskController());
  }
}
