import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:MedTime/Views/homepage.dart'; // Import your ReminderListScreen

class NotificationPermissionPage extends StatefulWidget {
  const NotificationPermissionPage({super.key});

  @override
  _NotificationPermissionPageState createState() =>
      _NotificationPermissionPageState();
}

class _NotificationPermissionPageState extends State<NotificationPermissionPage>
    with WidgetsBindingObserver {
  // Add WidgetsBindingObserver
  bool _isLoading = true;
  bool _isNotificationAllowed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Register the observer
    _checkNotificationPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove the observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Listen for app lifecycle changes
    if (state == AppLifecycleState.resumed) {
      // When the app resumes, recheck notification permissions
      _checkNotificationPermission();
    }
  }

  Future<void> _checkNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    setState(() {
      _isNotificationAllowed = isAllowed;
      _isLoading = false;
    });

    if (isAllowed) {
      // If notifications are allowed, initialize and navigate
      _initializeNotificationsAndNavigate();
    } else {
      // If notifications are not allowed, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable notifications to continue.'),
        ),
      );
    }
  }

  Future<void> _requestNotificationPermission() async {
    bool userAllowed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enable Notifications'),
          content: const Text(
              'To receive reminders, please enable notifications for this app.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Open app settings to allow the user to enable notifications
                await AwesomeNotifications()
                    .requestPermissionToSendNotifications();
                Navigator.of(context).pop(true);
              },
              child: const Text('Enable'),
            ),
          ],
        );
      },
    );

    if (userAllowed) {
      // Recheck permissions after the user returns from settings
      _checkNotificationPermission();
    }
  }

  Future<void> _initializeNotificationsAndNavigate() async {
    // Initialize AwesomeNotifications
    AwesomeNotifications().initialize(
      'resource://drawable/icon', // Path to your small icon
      [
        NotificationChannel(
          channelKey: 'reminder_channel',
          channelName: 'Reminder Notifications',
          channelDescription: 'Notification channel for reminder notifications',
          importance: NotificationImportance.Max,
        ),
      ],
    );

    // Initialize WorkManager
    Workmanager().initialize(callbackDispatcher);

    // Navigate to the ReminderListScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ReminderListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _isNotificationAllowed
                ? const Text('Notifications are enabled. Initializing...')
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Please enable notifications to continue.'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _requestNotificationPermission,
                        child: const Text('Enable Notifications'),
                      ),
                    ],
                  ),
      ),
    );
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Extract data passed from the task
    final id = inputData?['id'] ?? 1;
    final title = inputData?['title'] ?? 'Reminder';
    final body = inputData?['body'] ?? 'Time to take your medicine!';

    // Display the notification using Awesome Notifications
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'reminder_channel', // Ensure this matches your channel key
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );

    // Return true to indicate the task was successful
    return Future.value(true);
  });
}
