import 'package:get/get.dart';
import '../controller/home_controller.dart';

/// Home Binding
///
/// Lazily injects [HomeController] when the user navigates to the Home route.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
