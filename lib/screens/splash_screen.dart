import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate to login screen after 2 seconds
    Timer(Duration(seconds: 2), () {
      Get.off(() => LoginScreen());
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Get.theme.colorScheme.primary,
              Get.theme.colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon/Logo
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Get.theme.shadowColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.medical_services,
                  size: 60,
                  color: Get.theme.colorScheme.primary,
                ),
              ),

              SizedBox(height: 30),

              // App Title
              Text(
                'Telemedicine Kiosk',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.onPrimary,
                ),
              ),

              SizedBox(height: 10),

              Text(
                'Healthcare at your fingertips',
                style: TextStyle(
                  fontSize: 16,
                  color: Get.theme.colorScheme.onPrimary.withOpacity(0.8),
                ),
              ),

              SizedBox(height: 50),

              // Loading indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Get.theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}