import 'package:get/get.dart';
import '../controller/splash_controller.dart';

/// Splash Binding
///
/// Binds [SplashController] to the splash route lifecycle.
/// Dependencies are created only when the route is loaded and
/// disposed automatically when leaving the route.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
