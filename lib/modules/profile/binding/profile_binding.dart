import 'package:get/get.dart';
import '../controller/profile_controller.dart';

/// Profile Binding
///
/// Lazily injects [ProfileController] when the Profile route is visited.
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
