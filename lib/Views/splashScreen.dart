import 'package:MedTime/Views/Auth/signUpPage.dart';
import 'package:MedTime/Views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import the Lottie package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Controllers/userController.dart';
import '../Utils/Helper Functions/functions.dart';
import '../notificatioPage.dart'; // Import Riverpod for state management

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4), // Total duration for the animation
      vsync: this,
    );

    // Start the animation
    _controller.forward();

    // Check user data and navigate after the splash screen duration
    Future.delayed(const Duration(seconds: 5), () async {
      await checkUserData();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> checkUserData() async {
    final user = await fetchUserData();
    final ref = ProviderContainer().read(userProvider.notifier);

    if (user != null) {
      // Set the user data in the provider
      ref.SetUser(user);
    }

    // Navigate to the appropriate screen
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            user != null ? const NotificationPermissionPage() : SignupPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Fade transition
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration:
            const Duration(milliseconds: 1000), // Transition duration
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Lottie.asset(
        'assets/2.json', // Replace with your Lottie animation file path
        controller: _controller,
        width: double.infinity, // Full width
        height: double.infinity, // Full height
        fit: BoxFit.fill, // Scale to cover the entire screen
        onLoaded: (composition) {
          // Configure the AnimationController with the duration of the Lottie file
          _controller
            ..duration = composition.duration
            ..forward();
        },
      ),
    );
  }
}
