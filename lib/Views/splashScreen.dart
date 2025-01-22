import 'package:MedTime/Views/Auth/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import the Lottie package

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
      duration: const Duration(seconds: 3), // Total duration for the animation
      vsync: this,
    );

    // Start the animation
    _controller.forward();

    // Navigate to the main screen after the splash screen duration
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
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
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Full width
        height: double.infinity, // Full height

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation (Full Screen)
              Expanded(
                child: Lottie.asset(
                  'assets/2.json', // Replace with your Lottie animation file path
                  controller: _controller,
                  fit: BoxFit.cover, // Scale to cover the entire screen
                  onLoaded: (composition) {
                    // Configure the AnimationController with the duration of the Lottie file
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
