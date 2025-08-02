import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static final _db = FirebaseDatabase.instance.ref();

  static void logAction(String action) async {
    try {
      await _db.child("actions").push().set({
        "timestamp": DateTime.now().toIso8601String(),
        "action": action
      });
      print(" Action logged successfully: $action");
    } catch (e) {
      print(" Error logging action: $e");
    }
  }

  // Simplified method using get() instead of stream
  static Future<String> getDoctorStatusOnce() async {
    try {
      print(" Attempting to read doctor/status from Firebase...");

      // First check if Firebase is connected
      bool isConnected = await testFirebaseConnection();
      if (!isConnected) {
        throw Exception("Firebase connection failed");
      }

      final snapshot = await _db.child("doctor/status").get();

      print(" Snapshot exists: ${snapshot.exists}");
      print(" Snapshot value: ${snapshot.value}");

      if (snapshot.exists && snapshot.value != null) {
        String status = snapshot.value.toString().toLowerCase();
        print(" Successfully got status: $status");

        // Validate status
        if (status == 'online' || status == 'offline' || status == 'busy') {
          return status;
        } else {
          print(" Invalid status value: $status, defaulting to offline");
          return "offline";
        }
      } else {
        print(" No data found at doctor/status path");

        // Try to create the path with default value
        await _db.child("doctor/status").set("offline");
        print(" Created doctor/status with default value 'offline'");

        return "offline";
      }
    } catch (e) {
      print(" Error getting doctor status: $e");
      throw Exception("Failed to get doctor status: $e");
    }
  }

  // Test method to verify Firebase connection
  static Future<bool> testFirebaseConnection() async {
    try {
      print(" Testing Firebase connection...");

      // Test write
      String testValue = "test_${DateTime.now().millisecondsSinceEpoch}";
      await _db.child("connection_test").set(testValue);
      print(" Write test successful");

      // Test read
      final snapshot = await _db.child("connection_test").get();
      print(" Read test successful. Value: ${snapshot.value}");

      // Cleanup
      await _db.child("connection_test").remove();
      print(" Cleanup successful");

      return true;
    } catch (e) {
      print(" Firebase connection test failed: $e");
      return false;
    }
  }

  // Stream version for real-time updates (optional)
  static Stream<String> getDoctorStatus() {
    print("Starting Firebase stream for doctor/status");

    return _db.child("doctor/status").onValue.map((event) {
      print(" Firebase event received");
      print(" Event type: ${event.type}");
      print(" Snapshot exists: ${event.snapshot.exists}");
      print(" Snapshot value: ${event.snapshot.value}");

      if (event.snapshot.exists && event.snapshot.value != null) {
        final value = event.snapshot.value.toString();
        print("Stream returning status: $value");
        return value;
      }

      print(" Stream returning offline (no data)");
      return "offline";
    }).handleError((error) {
      print("Firebase stream error: $error");
      throw error;
    });
  }
  static Future<void> setDoctorStatus(String status) async {
    try {
      await _db.child("doctor/status").set(status);
      print("Doctor status set to: $status");
    } catch (e) {
      print("Error setting doctor status: $e");
      throw Exception("Failed to set doctor status: $e");
    }
  }
  // Additional utility methods for GetX integration
  static Future<void> updateDoctorStatus(String status) async {
    try {
      await _db.child("doctor/status").set(status);
      print("Doctor status updated to: $status");
    } catch (e) {
      print("Error updating doctor status: $e");
      throw Exception("Failed to update doctor status: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> getRecentActions({int limit = 10}) async {
    try {
      final snapshot = await _db
          .child("actions")
          .orderByChild("timestamp")
          .limitToLast(limit)
          .get();

      if (snapshot.exists && snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> actions = [];

        data.forEach((key, value) {
          actions.add({
            'id': key,
            'timestamp': value['timestamp'],
            'action': value['action'],
          });
        });

        // Sort by timestamp (most recent first)
        actions.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

        return actions;
      }

      return [];
    } catch (e) {
      print("Error getting recent actions: $e");
      throw Exception("Failed to get recent actions: $e");
    }
  }
}