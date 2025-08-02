import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/app_controller.dart';
import '../controllers/inactivity_controller.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final AppController appController = Get.find<AppController>();
  final InactivityController inactivityController = Get.find<InactivityController>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Stop inactivity timer on login screen
    inactivityController.stopInactivityTimer();

    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Get.theme.colorScheme.primary.withOpacity(0.1),
              Get.theme.colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                color: Get.theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Back',
                                  style: Get.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Get.theme.colorScheme.primary,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Please sign in to continue',
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),

                            // Theme toggle button
                            Obx(() => IconButton(
                              onPressed: appController.toggleTheme,
                              icon: Icon(
                                appController.isDarkMode.value
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                                color: Get.theme.colorScheme.primary,
                              ),
                              tooltip: appController.isDarkMode.value
                                  ? 'Switch to Light Mode'
                                  : 'Switch to Dark Mode',
                            )),
                          ],
                        ),

                        SizedBox(height: 32),

                        // Username field
                        TextFormField(
                          controller: usernameController,
                          style: TextStyle(color: Get.theme.colorScheme.onSurface),
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Get.theme.colorScheme.onSurface.withOpacity(0.7)),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Get.theme.colorScheme.outline),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Get.theme.colorScheme.outline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Get.theme.colorScheme.primary, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter username';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 16),

                        // Password field
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          style: TextStyle(color: Get.theme.colorScheme.onSurface),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Get.theme.colorScheme.onSurface.withOpacity(0.7)),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Get.theme.colorScheme.outline),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Get.theme.colorScheme.outline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Get.theme.colorScheme.primary, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 24),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Get.theme.colorScheme.primary,
                              foregroundColor: Get.theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Get.theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        // Hint text
                        Text(
                          'Default: admin / 1234',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    if (formKey.currentState!.validate()) {
      bool success = authController.login(
        usernameController.text,
        passwordController.text,
      );

      if (success) {
        // Start inactivity timer after successful login
        inactivityController.startInactivityTimer();

        // Navigate to home screen
        Get.off(() => HomeScreen());
      }
    }
  }
}