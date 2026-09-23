import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../modules/auth/binding/auth_binding.dart';
import '../../modules/auth/view/login_page.dart';
import '../../modules/auth/view/signup_page.dart';
import '../../modules/tasks/binding/task_binding.dart';
import '../../modules/tasks/view/tasks_screen.dart';

/// Named Route Constants
abstract class AppRoutes {
  /// Logged-in users (existing session) go to tasks, others to login
  static String get initial => Supabase.instance.client.auth.currentSession != null ? tasks : login;

  static const String login = '/login';
  static const String signup = '/signup';
  static const String tasks = '/tasks';
}

/// App Route Page Declarations
class AppPages {
  AppPages._();

  static final List<GetPage> routes = [
    GetPage(name: AppRoutes.login, page: () => const LoginPage(), binding: LoginBinding(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.signup, page: () => const SignupPage(), binding: SignupBinding(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.tasks, page: () => const TasksScreen(), binding: TaskBinding(), transition: Transition.fadeIn),
  ];
}
