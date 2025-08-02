import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/theme_config.dart';
import 'firebase_options.dart';
import 'controllers/app_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/firebase_controller.dart';
import 'controllers/inactivity_controller.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize controllers
  Get.put(AppController());
  Get.put(AuthController());
  Get.put(FirebaseController());
  Get.put(InactivityController());

  runApp(KioskApp());
}

class KioskApp extends StatelessWidget {
  final AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      title: 'Telemedicine Kiosk',
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: appController.themeMode.value,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    ));
  }
}