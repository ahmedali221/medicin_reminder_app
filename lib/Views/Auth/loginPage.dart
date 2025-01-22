import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Controllers/userController.dart';
import '../../Utils/Database/database.dart';
import '../../Models/user.dart';
import '../../Utils/Custom Widgets/richText.dart';
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
          const SnackBar(content: const Text('Invalid username or password')),
        );
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/medLogo.png",
                height: 100,
              ),

              // Username Field
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.black), // Label color
                ),
                style: const TextStyle(color: Colors.black), // Input text color
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
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black), // Label color
                ),
                style: const TextStyle(color: Colors.black), // Input text color
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
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF1565C0), // Button background color
                  foregroundColor: Colors.white, // Button text color
                ),
                child: const Text('Login'),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     var response = await http.get(
              //       Uri.parse(
              //           "https://odphp.health.gov/myhealthfinder/api/v3/topicsearch.json?TopicId=527"),
              //     );
              //     if (response.statusCode == 200) {
              //       Map<String, dynamic> jsonResponse =
              //           json.decode(response.body);
              //       var resource =
              //           jsonResponse['Result']['Resources']['Resource'];

              //       print(resource);
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.blueAccent, // Button background color
              //     foregroundColor: Colors.white, // Button text color
              //   ),
              //   child: const Text('Get Api Data'),
              // ),

              // Signup Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: RichTextButton(
                  normalText: 'Don\'t have an account? ',
                  clickableText: 'Signup',
                  onPressed: () {
                    // Clear the form fields before navigating
                    _usernameController.clear();
                    _passwordController.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupPage(),
                      ),
                    );
                  },
                  normalTextColor: Colors.black, // Adjust as needed
                  clickableTextColor:
                      const Color(0xFF1565C0), // Adjust as needed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
