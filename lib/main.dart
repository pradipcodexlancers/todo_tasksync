import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/constants/app_strings.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'services/storage_service.dart';

/// Entry point of the application
Future<void> main() async {
  // Ensure Flutter engine bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize global long-running services before launching the app
  await _initServices();

  runApp(const MyApp());
}

/// Initialize GetX Services (Global Singletons)
Future<void> _initServices() async {
  // Storage Service initialization
  await Get.putAsync<StorageService>(() => StorageService().init());
}

/// Root Application Widget using GetMaterialApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Application Title
      title: AppStrings.appName,

      // Light & Dark Themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Navigation & Routing via GetPages
      initialRoute: AppRoutes.initial,
      getPages: AppPages.routes,

      // UI Config
      debugShowCheckedModeBanner: false,
    );
  }
}
