import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';

/// Home Controller
///
/// Manages state for the Home Dashboard screen.
/// Demonstrates reactive variables (.obs), lifecycle methods,
/// and navigation between screens.
class HomeController extends GetxController {
  // Reactive loading state
  final RxBool isLoading = false.obs;

  // Reactive state example: Counter
  final RxInt counter = 0.obs;

  // Reactive list of banners
  final RxList<BannerModel> banners = <BannerModel>[].obs;

  // Reactive list of categories
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Called immediately after the controller is allocated in memory
    loadDashboardData();
  }

  /// Fetch or initialize dashboard sample data
  Future<void> loadDashboardData() async {
    isLoading.value = true;

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Populate sample categories
    categories.assignAll([
      const CategoryModel(id: '1', name: 'Trending', icon: 'trending_up'),
      const CategoryModel(id: '2', name: 'Offers', icon: 'local_offer'),
      const CategoryModel(id: '3', name: 'Events', icon: 'event'),
      const CategoryModel(id: '4', name: 'Support', icon: 'help_outline'),
    ]);

    // Populate sample banners
    banners.assignAll([
      const BannerModel(
        id: '1',
        title: 'Get Started with GetX Architecture',
        imageUrl: 'https://picsum.photos/400/200',
      ),
      const BannerModel(
        id: '2',
        title: 'Scalable & Clean Flutter Codebase',
        imageUrl: 'https://picsum.photos/400/201',
      ),
    ]);

    isLoading.value = false;
  }

  /// Increment reactive counter
  void incrementCounter() {
    counter.value++;
  }

  /// Decrement reactive counter
  void decrementCounter() {
    if (counter.value > 0) {
      counter.value--;
    }
  }

  /// Navigate to Profile Screen
  void goToProfile() {
    Get.toNamed(AppRoutes.profile);
  }
}
