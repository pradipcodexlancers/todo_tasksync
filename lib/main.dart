import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_strings.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/local_storage_service.dart';
import 'services/storage_service.dart';
import 'services/todo_service.dart';

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
  // Load local .env and initialize Supabase
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(url: dotenv.env['SUPABASE_URL']!, publishableKey: dotenv.env['SUPABASE_ANON_KEY']!);

  // Storage Service initialization
  await Get.putAsync<StorageService>(() => StorageService().init());

  // Local Storage Service (GetStorage) for todos
  await Get.putAsync<LocalStorageService>(() => LocalStorageService().init());

  // Auth Service (Supabase session, login, logout)
  Get.put<AuthService>(AuthService(), permanent: true);

  // Todo Service (Supabase RPC: get / create / update / delete todos)
  Get.put<TodoService>(TodoService(), permanent: true);
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
