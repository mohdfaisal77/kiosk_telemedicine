import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/firebase_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/app_controller.dart';
import '../controllers/inactivity_controller.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = MethodChannel("kiosk_channel");

  final FirebaseController firebaseController = Get.find<FirebaseController>();
  final AuthController authController = Get.find<AuthController>();
  final AppController appController = Get.find<AppController>();
  final InactivityController inactivityController = Get.find<InactivityController>();

  @override
  void initState() {
    super.initState();
    enableKioskMode();
  }

  void enableKioskMode() async {
    try {
      await platform.invokeMethod("startKiosk");
    } on PlatformException catch (e) {
      print("Failed to start kiosk mode: '${e.message}'.");
    }
  }

  // Reset inactivity timer on any user interaction
  void _onUserInteraction() {
    inactivityController.resetInactivityTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _onUserInteraction(),
      onPointerMove: (_) => _onUserInteraction(),
      onPointerUp: (_) => _onUserInteraction(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.medical_services),
              SizedBox(width: 8),
              Text('Kiosk Home'),
            ],
          ),
          backgroundColor: Get.theme.appBarTheme.backgroundColor,
          actions: [
            // Firebase status indicator
            Obx(() => Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              decoration: BoxDecoration(
                color: firebaseController.isFirebaseConnected.value
                    ? Colors.green.withOpacity(0.15)
                    : Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: firebaseController.isFirebaseConnected.value
                      ? Colors.green.shade600
                      : Colors.red.shade600,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    firebaseController.isFirebaseConnected.value
                        ? Icons.cloud_done
                        : Icons.cloud_off,
                    size: 16,
                    color: firebaseController.isFirebaseConnected.value
                        ? Colors.green.shade600
                        : Colors.red.shade600,
                  ),
                  SizedBox(width: 4),
                  Text(
                    firebaseController.isFirebaseConnected.value ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: firebaseController.isFirebaseConnected.value
                          ? Colors.green.shade600
                          : Colors.red.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )),

            // Theme toggle
            Obx(() => IconButton(
              onPressed: () {
                appController.toggleTheme();
                _onUserInteraction();
              },
              icon: Icon(
                appController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              tooltip: appController.isDarkMode.value
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
            )),

            // Logout button
            IconButton(
              onPressed: () {
                _showLogoutDialog();
                _onUserInteraction();
              },
              icon: Icon(Icons.logout),
              tooltip: 'Logout',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.waving_hand,
                        size: 48,
                        color: Get.theme.colorScheme.primary,
                      ),
                      SizedBox(height: 12),
                      Obx(() => Text(
                        'Welcome, ${authController.username.value}!',
                        style: Get.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.primary,
                        ),
                      )),
                      SizedBox(height: 8),
                      Text(
                        'What would you like to do today?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Main action buttons
              _buildActionButton(
                icon: Icons.calendar_today,
                title: 'Book Appointment',
                subtitle: 'Schedule a consultation with a doctor',
                onPressed: () {
                  firebaseController.bookAppointment();
                  _onUserInteraction();
                },
                color: Get.theme.colorScheme.primary,
              ),

              SizedBox(height: 16),

              _buildActionButton(
                icon: Icons.person_search,
                title: 'Check Doctor Status',
                subtitle: 'See if doctors are available',
                onPressed: () {
                  firebaseController.checkDoctorStatus();
                  _onUserInteraction();
                },
                color: Get.theme.colorScheme.secondary,
              ),

              SizedBox(height: 24),

              // System status section
              Text(
                'System Status',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),

              SizedBox(height: 16),

              // Firebase connection test button
              _buildActionButton(
                icon: Icons.wifi_tethering,
                title: 'Test Firebase Connection',
                subtitle: 'Verify system connectivity',
                onPressed: () {
                  firebaseController.showTestDialog();
                  _onUserInteraction();
                },
                color: Colors.blue,
              ),

              SizedBox(height: 16),

              // Firebase status card
              Obx(() => Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: firebaseController.isFirebaseConnected.value
                    ? Get.theme.colorScheme.primaryContainer
                    : Get.theme.colorScheme.errorContainer,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        firebaseController.isFirebaseConnected.value
                            ? Icons.check_circle
                            : Icons.error,
                        color: firebaseController.isFirebaseConnected.value
                            ? Get.theme.colorScheme.primary
                            : Get.theme.colorScheme.error,
                        size: 32,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              firebaseController.isFirebaseConnected.value
                                  ? 'Firebase Connected'
                                  : 'Firebase Disconnected',
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: firebaseController.isFirebaseConnected.value
                                    ? Get.theme.colorScheme.onPrimaryContainer
                                    : Get.theme.colorScheme.onErrorContainer,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              firebaseController.isFirebaseConnected.value
                                  ? 'All systems operational'
                                  : 'Please check your connection',
                              style: Get.textTheme.bodyMedium?.copyWith(
                                color: firebaseController.isFirebaseConnected.value
                                    ? Get.theme.colorScheme.onPrimaryContainer.withOpacity(0.7)
                                    : Get.theme.colorScheme.onErrorContainer.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      color: Get.theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Get.theme.dialogBackgroundColor,
        title: Row(
          children: [
            Icon(Icons.logout, color: Get.theme.colorScheme.primary),
            SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(color: Get.theme.colorScheme.onSurface),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Get.theme.colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Get.theme.colorScheme.primary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              inactivityController.autoLockApp();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.colorScheme.primary,
              foregroundColor: Get.theme.colorScheme.onPrimary,
            ),
            child: Text(
              'Logout',
              style: TextStyle(color: Get.theme.colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }}