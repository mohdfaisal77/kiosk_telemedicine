import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../screens/login_screen.dart';

class InactivityController extends GetxController {
  Timer? _inactivityTimer;
  final int inactivityDuration = 120; // 2 minutes in seconds
  final remainingTime = 0.obs;
  final isWarningShown = false.obs;

  Timer? _countdownTimer;
  final int warningDuration = 30; // 30 seconds warning

  @override
  void onInit() {
    super.onInit();
    startInactivityTimer();
  }

  @override
  void onClose() {
    _inactivityTimer?.cancel();
    _countdownTimer?.cancel();
    super.onClose();
  }

  void startInactivityTimer() {
    _inactivityTimer?.cancel();
    _countdownTimer?.cancel();
    isWarningShown.value = false;

    _inactivityTimer = Timer(Duration(seconds: inactivityDuration - warningDuration), () {
      showInactivityWarning();
    });
  }

  void resetInactivityTimer() {
    if (Get.find<AuthController>().isLoggedIn.value) {
      startInactivityTimer();
    }
  }

  void showInactivityWarning() {
    if (isWarningShown.value) return;

    isWarningShown.value = true;
    remainingTime.value = warningDuration;

    // Start countdown
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      remainingTime.value--;

      if (remainingTime.value <= 0) {
        timer.cancel();
        autoLockApp();
      }
    });

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent closing with back button
        child: AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Get.theme.colorScheme.primary),
              SizedBox(width: 10),
              Text("Inactivity Warning"),
            ],
          ),
          content: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("You will be logged out due to inactivity in:"),
              SizedBox(height: 10),
              Text(
                "${remainingTime.value} seconds",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 10),
              Text("Tap 'Stay Logged In' to continue your session."),
            ],
          )),
          actions: [
            TextButton(
              onPressed: () {
                _countdownTimer?.cancel();
                Get.back();
                isWarningShown.value = false;
                resetInactivityTimer();
              },
              child: Text("Stay Logged In"),
            ),
            TextButton(
              onPressed: () {
                _countdownTimer?.cancel();
                Get.back();
                autoLockApp();
              },
              child: Text("Logout Now"),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void autoLockApp() {
    _inactivityTimer?.cancel();
    _countdownTimer?.cancel();
    isWarningShown.value = false;

    // Logout user
    Get.find<AuthController>().logout();

    // Navigate to login screen
    Get.offAll(() => LoginScreen());
  }

  void stopInactivityTimer() {
    _inactivityTimer?.cancel();
    _countdownTimer?.cancel();
    isWarningShown.value = false;
  }
}