import 'package:get/get.dart';

import '../../modules/auth/binding/auth_binding.dart';
import '../../modules/auth/view/login_screen.dart';
import '../../modules/auth/view/register_screen.dart';
import '../../modules/home/binding/home_binding.dart';
import '../../modules/home/view/home_screen.dart';
import '../../modules/profile/binding/profile_binding.dart';
import '../../modules/profile/view/profile_screen.dart';
import '../../modules/splash/binding/splash_binding.dart';
import '../../modules/splash/view/splash_screen.dart';

/// Named Route Constants
///
/// Use these static string constants when navigating with GetX:
/// e.g. `Get.toNamed(AppRoutes.home)` or `Get.offAllNamed(AppRoutes.login)`
abstract class AppRoutes {
  static const String initial = splash;

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
}

/// App Route Page Declarations
///
/// Connects each named route string to its Widget View and dependency [Bindings].
/// Pass `AppPages.routes` directly to `getPages` in `GetMaterialApp`.
class AppPages {
  // Private constructor to prevent direct instantiation
  AppPages._();

  static final List<GetPage> routes = [
    // Splash Route
    GetPage(name: AppRoutes.splash, page: () => SplashScreen(), binding: SplashBinding()),

    // Auth Routes
    GetPage(name: AppRoutes.login, page: () => const LoginScreen(), binding: AuthBinding(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen(), binding: AuthBinding(), transition: Transition.rightToLeft),

    // Home Route
    GetPage(name: AppRoutes.home, page: () => const HomeScreen(), binding: HomeBinding(), transition: Transition.fadeIn),

    // Profile Route
    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen(), binding: ProfileBinding(), transition: Transition.rightToLeft),
  ];
}
