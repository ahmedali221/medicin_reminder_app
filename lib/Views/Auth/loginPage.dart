import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Controllers/userController.dart';
import '../../Database/database.dart';
import '../../Models/user.dart';
import '../homepage.dart';
import 'signUpPage.dart';

class LoginPage extends ConsumerStatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Fetch user from the database
      User? user = await DatabaseHelper().getUser(_usernameController.text);

      // Check if the user exists and the password is correct
      if (user != null && user.password == _passwordController.text) {
        // Update the user state in Riverpod
        ref.read(userProvider.notifier).setUser(user);

        // Navigate to ReminderListScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReminderListScreen(),
          ),
        );
      } else {
        // Show error message if login fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              Text(
                'Welcome To Medicine',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              // Username Field
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              // Login Button
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              // Signup Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text('Don\'t have an account? Signup'),
              ),

              ElevatedButton(
                onPressed: () async {
                  try {
                    await AwesomeNotifications()
                        .requestPermissionToSendNotifications();
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text("Request Permission"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await AwesomeNotifications().createNotification(
                    content: NotificationContent(
                      id: 1,
                      channelKey: 'basic_channel',
                      title: 'Test Title',
                      body: 'Test Body',
                      notificationLayout: NotificationLayout.Default,
                    ),
                  );
                },
                child: Text("Notify"),
              ),
              ElevatedButton(onPressed: () {}, child: Text("Schedule")),
            ],
          ),
        ),
      ),
    );
  }
}
