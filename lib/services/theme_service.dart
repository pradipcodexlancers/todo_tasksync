import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/app_colors.dart';
import 'storage_service.dart';

/// Theme Service
///
/// Holds the light / dark choice, saves it in SharedPreferences
/// ([StorageService]) and restores it on app start.
class ThemeService extends GetxService {
  final StorageService _storage = Get.find<StorageService>();

  final isDark = false.obs;

  ThemeMode get themeMode => isDark.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    isDark.value = _storage.read<bool>(StorageService.keyThemeMode) ?? false;
    AppColors.isDark = isDark.value;
  }

  Future<void> setDarkMode(bool dark) async {
    isDark.value = dark;
    AppColors.isDark = dark;
    Get.changeThemeMode(themeMode);
    // AppColors are read directly by widgets (not via Theme.of), so rebuild
    // the whole tree to pick up the new colors
    await Get.forceAppUpdate();
    await _storage.write(StorageService.keyThemeMode, dark);
  }
}
