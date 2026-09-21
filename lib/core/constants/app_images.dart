/// Application Image & Icon Assets
///
/// Store all your static asset paths here (images, icons, svgs, animations).
///
/// HOW TO USE:
/// 1. Place your image files in `assets/images/` or `assets/icons/`.
/// 2. Declare them in your `pubspec.yaml` under `flutter.assets`.
/// 3. Reference them in widgets using `AppImages.appLogo`, etc.
class AppImages {
  // Private constructor to prevent direct instantiation
  AppImages._();

  // Base paths
  static const String _baseImages = 'assets/images/';
  static const String _baseIcons = 'assets/icons/';

  // Placeholder images
  static const String appLogo = '${_baseImages}app_logo.png';
  static const String splashLogo = '${_baseImages}splash_logo.png';
  static const String placeholder = '${_baseImages}placeholder.png';
  static const String userPlaceholder = '${_baseImages}user_placeholder.png';

  // Placeholder icons
  static const String homeIcon = '${_baseIcons}ic_home.png';
  static const String profileIcon = '${_baseIcons}ic_profile.png';
  static const String settingsIcon = '${_baseIcons}ic_settings.png';
}
