import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../Utils/Database/database.dart';
import '../../Models/user.dart';
import '../../Utils/Custom Widgets/richText.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(); // New controller
  final _phoneNumberController = TextEditingController(); // New controller
  File? _photo;

  Future<void> _pickPhoto() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
      });
    }
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      User newUser = User(
        username: _usernameController.text,
        password: _passwordController.text,
        name: _nameController.text,
        email: _emailController.text, // New field
        phoneNumber: _phoneNumberController.text, // New field
        photo: _photo?.path, // Save the file path or URL
      );
      await DatabaseHelper().insertUser(newUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User registered successfully!')),
      );
      Navigator.pop(context);
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
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/medLogo.png",
                width: 200,
              ),
              const Text(
                'Create Your New Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1565C0),
                ),
              ),
              // CircleAvatar for the photo
              Center(
                child: GestureDetector(
                  onTap: _pickPhoto, // Allow tapping to pick a photo
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _photo != null
                            ? FileImage(_photo!) // Display the selected photo
                            : null, // No photo selected
                        child: _photo == null
                            ? const Icon(Icons.person,
                                size: 50, color: Colors.white) // Default icon
                            : null,
                      ),
                      // + Icon
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 191, 201, 209),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress, // Email input type
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone, // Phone input type
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _signup,
                child: const Text('Signup'),
              ),
              RichTextButton(
                normalText: 'Already have an account? ',
                clickableText: 'Login',
                onPressed: () {
                  Navigator.pop(context); // Navigate back to the login page
                },
                normalTextColor: Colors.black,
                clickableTextColor: const Color(0xFF1565C0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
