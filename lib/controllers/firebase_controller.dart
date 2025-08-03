import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/firebase_service.dart';

class FirebaseController extends GetxController {
  final isFirebaseConnected = false.obs;
  final doctorStatus = 'offline'.obs;
  final isLoadingStatus = false.obs;
  final isTestingConnection = false.obs;

  @override
  void onInit() {
    super.onInit();
    testConnection();
  }

  Future<void> testConnection() async {
    isTestingConnection.value = true;

    try {
      bool result = await FirebaseService.testFirebaseConnection();
      isFirebaseConnected.value = result;

      if (result) {
        Get.snackbar(
          'Success',
          'Firebase connected successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
          colorText: Get.theme.colorScheme.primary,
        );
      } else {
        Get.snackbar(
          'Error',
          'Firebase connection failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
          colorText: Get.theme.colorScheme.error,
        );
      }
    } catch (e) {
      isFirebaseConnected.value = false;
      Get.snackbar(
        'Error',
        'Firebase test failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
    } finally {
      isTestingConnection.value = false;
    }
  }

  // UPDATE firebase_controller.dart - REPLACE bookAppointment method:

  Future<void> bookAppointment() async {
    try {
      // Show loading dialog
      Get.dialog(
        AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Checking availability..."),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      // First check Firebase connection
      if (!isFirebaseConnected.value) {
        Get.back(); // Close loading dialog

        Get.dialog(
          AlertDialog(
            title: Row(
              children: [
                Icon(Icons.cloud_off, color: Colors.red),
                SizedBox(width: 10),
                Text("Connection Error"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off, size: 64, color: Colors.red.shade300),
                SizedBox(height: 16),
                Text(
                  "Firebase connection failed",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "Please wait for a few minutes and try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "System is temporarily offline",
                          style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text("OK"),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  testConnection(); // Retry connection
                },
                child: Text("Retry Connection"),
              ),
            ],
          ),
        );
        return;
      }

      // Check doctor status
      String doctorCurrentStatus;
      try {
        doctorCurrentStatus = await FirebaseService.getDoctorStatusOnce();
      } catch (e) {
        Get.back(); // Close loading dialog

        Get.dialog(
          AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error, color: Colors.orange),
                SizedBox(width: 10),
                Text("Status Check Failed"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_off, size: 64, color: Colors.orange.shade300),
                SizedBox(height: 16),
                Text(
                  "Unable to check doctor availability",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "Please wait for a few minutes and try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text("OK"),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  bookAppointment(); // Retry booking
                },
                child: Text("Try Again"),
              ),
            ],
          ),
        );
        return;
      }

      Get.back(); // Close loading dialog

      // Check if doctor is offline
      if (doctorCurrentStatus == 'offline') {
        Get.dialog(
          AlertDialog(
            title: Row(
              children: [
                Icon(Icons.person_off, color: Colors.orange),
                SizedBox(width: 10),
                Text("Doctor Offline"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule, size: 64, color: Colors.orange.shade300),
                SizedBox(height: 16),
                Text(
                  "Doctor is currently offline",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "Please try booking when the doctor is available.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Doctor status: ${doctorCurrentStatus.toUpperCase()}",
                          style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text("OK"),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  checkDoctorStatus(); // Check status again
                },
                child: Text("Check Status"),
              ),
            ],
          ),
        );
        return;
      }

      // Doctor is online - proceed with booking
      FirebaseService.logAction("Appointment Booked - Doctor Status: $doctorCurrentStatus");

      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 0),
              Text("Booking Successful",style: TextStyle(fontSize: 14),),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_available, size: 64, color: Colors.green.shade300),
              SizedBox(height: 16),
              Text(
                "Appointment booked successfully!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                "The doctor is currently ${doctorCurrentStatus.toUpperCase()}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "You will be contacted shortly",
                        style: TextStyle(color: Colors.green.shade700, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("OK"),
            ),
          ],
        ),
      );

    } catch (e) {
      // Close any open dialogs
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text("Booking Failed"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              SizedBox(height: 16),
              Text(
                "Failed to book appointment",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                "Error: $e",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("OK"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                bookAppointment(); // Retry
              },
              child: Text("Try Again"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> checkDoctorStatus() async {
    isLoadingStatus.value = true;

    // Show loading dialog immediately
    Get.dialog(
      AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Checking doctor status..."),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    try {
      String status = await FirebaseService.getDoctorStatusOnce();
      doctorStatus.value = status;

      // Close loading dialog
      Get.back();

      // Show status dialog
      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              Icon(
                status == 'online' ? Icons.check_circle : Icons.error,
                color: status == 'online' ? Colors.green : Colors.orange,
              ),
              SizedBox(width: 10),
              Text("Doctor Status"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Doctor is currently: $status",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: status == 'online'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: status == 'online' ? Colors.green : Colors.orange,
                  ),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: status == 'online' ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                checkDoctorStatus(); // Refresh
              },
              child: Text("Refresh"),
            ),
          ],
        ),
      );

    } catch (e) {
      // Close loading dialog
      Get.back();

      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text("Error"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Failed to get doctor status:"),
              SizedBox(height: 8),
              Text(
                "$e",
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 16),
              Text("Possible solutions:"),
              Text("• Check internet connection"),
              Text("• Verify Firebase setup"),
              Text("• Ensure 'doctor/status' exists in database"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                testConnection(); // Test Firebase connection
              },
              child: Text("Test Connection"),
            ),
          ],
        ),
      );
    } finally {
      isLoadingStatus.value = false;
    }
  }

  Future<void> showTestDialog() async {
    Get.dialog(
      AlertDialog(
        content: Obx(() => Row(
          children: [
            if (isTestingConnection.value) CircularProgressIndicator(),
            SizedBox(width: 20),
            Text(isTestingConnection.value ? "Testing Firebase..." : "Test Complete"),
          ],
        )),
      ),
      barrierDismissible: false,
    );

    await testConnection();

    Get.back(); // Close loading dialog

    Get.dialog(
      AlertDialog(
        title: Text("Firebase Test"),
        content: Text(isFirebaseConnected.value
            ? " Firebase is working!"
            : " Firebase test failed"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}