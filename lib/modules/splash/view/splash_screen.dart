import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/common_loader.dart';
import '../controller/splash_controller.dart';

/// Splash Screen View
///
/// Uses [GetView<SplashController>] to access the controller directly
/// without needing [Get.find()].
class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Icon
            Icon(Icons.bolt_rounded, size: 80, color: AppColors.textLight),
            SizedBox(height: 16),
            // App Name
            Text(AppStrings.appName, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textLight, letterSpacing: 0.5)),
            SizedBox(height: 8),
            // Tagline
            Text(AppStrings.appTagline, style: TextStyle(fontSize: 14, color: Colors.white70)),
            SizedBox(height: 48),
            // Loading indicator
            CommonLoader(color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }
}
