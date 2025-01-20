import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clinicapp/Views/Auth/loginPage.dart';
import 'package:clinicapp/Views/homepage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    'resource://drawable/notification_icon', // Path to your small icon
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic notifications',
        importance: NotificationImportance.High,
        defaultColor: Colors.blue,
        ledColor: Colors.white,
      ),
    ],
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // General App Theme
        colorScheme: ColorScheme.light(
          primary:
              Colors.blue.shade800, // Primary color (e.g., AppBar, buttons)

          surface: Colors.white, // Surface color (e.g., cards, dialogs)
          onPrimary: Colors.white, // Text/icon color on primary
          onSecondary: Colors.black, // Text/icon color on secondary
          onBackground: Colors.black, // Text color on background
          onSurface: Colors.black, // Text color on surface
        ),
        useMaterial3: true, // Enable Material 3 design (optional)

        // Typography
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),
        ),
        fontFamily: 'Cera Pro', // Custom font family

        // AppBar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // AppBar text/icon color
          elevation: 4, // AppBar shadow
          centerTitle: true, // Center the title
          titleTextStyle: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        // ElevatedButton Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            iconColor: Colors.white,
            backgroundColor: Colors.blue.shade800, // Button background color
            foregroundColor: Colors.white, // Button text/icon color
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
          ),
        ),

        // TextField Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true, // Fill the background of the input field
          fillColor: Colors.grey.shade100, // Light background color
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderSide: BorderSide.none, // No border
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none, // No border when enabled
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue.shade800, // Border color when focused
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          labelStyle: TextStyle(
            color: Colors.grey.shade600, // Label color
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade500, // Hint text color
          ),
        ),

        // Card Theme
        cardTheme: CardTheme(
          elevation: 2, // Card shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          margin: const EdgeInsets.all(8),
        ),

        // Icon Theme
        iconTheme: const IconThemeData(
          color: Colors.white, // Default icon color
        ),

        // FloatingActionButton Theme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue, // FAB background color
          foregroundColor: Colors.white, // FAB icon color
          elevation: 4, // FAB shadow
        ),

        // SnackBar Theme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.blue.shade800, // SnackBar background color
          contentTextStyle: const TextStyle(
            color: Colors.white, // SnackBar text color
          ),
          behavior: SnackBarBehavior.floating, // Floating SnackBar
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
        ),

        // Divider Theme
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade300, // Divider color
          thickness: 1, // Divider thickness
          space: 16, // Space around the divider
        ),
      ),
      home: LoginPage(),
    );
  }
}
