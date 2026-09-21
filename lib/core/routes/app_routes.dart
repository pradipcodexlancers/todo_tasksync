import 'package:get/get.dart';
import '../../modules/tasks/binding/task_binding.dart';
import '../../modules/tasks/view/tasks_screen.dart';

/// Named Route Constants
abstract class AppRoutes {
  static const String initial = tasks;
  static const String tasks = '/tasks';
}

/// App Route Page Declarations
class AppPages {
  AppPages._();

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.tasks,
      page: () => const TasksScreen(),
      binding: TaskBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
