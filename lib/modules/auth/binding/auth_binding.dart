import 'package:get/get.dart';
import '../controller/login_controller.dart';
import '../controller/register_controller.dart';

/// Auth Binding
///
/// Injects authentication dependencies lazily.
/// [LoginController] and [RegisterController] will only be instantiated
/// when requested by their respective screens.
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
