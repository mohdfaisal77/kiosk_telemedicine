import 'package:get/get.dart';

class AuthController extends GetxController {
  final isLoggedIn = false.obs;
  final username = ''.obs;

  // Valid credentials
  static const String validUsername = 'admin';
  static const String validPassword = '1234';

  bool login(String username, String password) {
    if (username == validUsername && password == validPassword) {
      isLoggedIn.value = true;
      this.username.value = username;

      Get.snackbar(
        'Success',
        'Login successful!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
        colorText: Get.theme.colorScheme.primary,
      );

      return true;
    } else {
      Get.snackbar(
        'Error',
        'Invalid credentials',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );

      return false;
    }
  }

  void logout() {
    isLoggedIn.value = false;
    username.value = '';

    Get.snackbar(
      'Logged Out',
      'You have been logged out',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.1),
      colorText: Get.theme.colorScheme.secondary,
    );
  }
}