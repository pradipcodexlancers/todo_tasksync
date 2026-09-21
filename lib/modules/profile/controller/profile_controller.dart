import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_utils.dart';
import '../models/profile_model.dart';

/// Profile Controller
///
/// Manages user profile information, settings actions, and logout flow.
class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rxn<ProfileModel> profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  /// Load user profile details
  Future<void> loadUserProfile() async {
    isLoading.value = true;

    // Simulate API fetch delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Populate mock profile data
    profile.value = const ProfileModel(
      id: 'USR-1001',
      fullName: 'John Doe',
      email: 'john.doe@example.com',
      phoneNumber: '+1 234 567 8900',
      bio: 'Mobile App Developer & Flutter enthusiast.',
    );

    isLoading.value = false;
  }

  /// Handle logout action
  Future<void> logout() async {
    // Clear stored session tokens if using StorageService:
    // final storage = Get.find<StorageService>();
    // await storage.clearAll();

    AppUtils.showSuccessSnackbar(message: 'Logged out successfully');

    // Navigate back to Login and clear route stack
    Get.offAllNamed(AppRoutes.login);
  }
}
