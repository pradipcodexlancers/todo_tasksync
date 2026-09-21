/// Application String Constants
///
/// Centralized place for all static text labels, error messages,
/// and titles used in the app. This makes future localization/multi-language
/// support much simpler to implement.
class AppStrings {
  // Private constructor to prevent direct instantiation
  AppStrings._();

  // General App Info
  static const String appName = 'GetX Boilerplate';
  static const String appTagline = 'Clean Architecture with GetX';

  // Common Button Labels
  static const String continueText = 'Continue';
  static const String submit = 'Submit';
  static const String cancel = 'Cancel';
  static const String retry = 'Retry';
  static const String save = 'Save';
  static const String delete = 'Delete';

  // Authentication Strings
  static const String loginTitle = 'Welcome Back!';
  static const String loginSubtitle = 'Sign in with your credentials to continue';
  static const String registerTitle = 'Create an Account';
  static const String registerSubtitle = 'Join us and start exploring today';
  static const String email = 'Email Address';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String login = 'Log In';
  static const String register = 'Sign Up';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String forgotPassword = 'Forgot Password?';

  // Home Strings
  static const String homeTitle = 'Home Dashboard';
  static const String welcomeMessage = 'Welcome to your GetX Boilerplate!';
  static const String counterExample = 'Reactive Counter Example:';
  static const String categories = 'Categories';
  static const String banners = 'Featured Banners';

  // Profile Strings
  static const String profileTitle = 'My Profile';
  static const String editProfile = 'Edit Profile';
  static const String settings = 'Settings';
  static const String logout = 'Log Out';
  static const String logoutConfirm = 'Are you sure you want to log out?';

  // Validation Messages
  static const String fieldRequired = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';

  // Network & Error Strings
  static const String networkError = 'Please check your internet connection';
  static const String somethingWentWrong = 'Something went wrong. Please try again';
  static const String serverError = 'Server error occurred. Please try later';
}
