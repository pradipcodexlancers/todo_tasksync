import 'package:get/get.dart';
import '../controller/login_controller.dart';
import '../controller/signup_controller.dart';

/// Auth Bindings
///
/// Each page gets its own controller so that leaving one page
/// never disposes the controller of the next one.
class LoginBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<LoginController>(() => LoginController());
}

class SignupBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<SignupController>(() => SignupController());
}
