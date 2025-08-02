import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  // Theme management
  final themeMode = ThemeMode.system.obs;
  final isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't initialize theme here - do it after the app starts
  }

  @override
  void onReady() {
    super.onReady();
    // Initialize theme after the app is ready
    _updateThemeMode();
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
      isDarkMode.value = true;
    } else {
      themeMode.value = ThemeMode.light;
      isDarkMode.value = false;
    }
    Get.changeThemeMode(themeMode.value);
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    isDarkMode.value = mode == ThemeMode.dark;
    Get.changeThemeMode(mode);
  }

  void _updateThemeMode() {
    try {
      if (Get.context != null) {
        final brightness = MediaQuery.of(Get.context!).platformBrightness;
        if (themeMode.value == ThemeMode.system) {
          isDarkMode.value = brightness == Brightness.dark;
        }
      } else {
        // Fallback to light mode if context is not available
        isDarkMode.value = false;
      }
    } catch (e) {
      // Fallback to light mode on any error
      isDarkMode.value = false;
      print('Error updating theme mode: $e');
    }
  }
}