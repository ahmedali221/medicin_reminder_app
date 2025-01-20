import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../Database/database.dart';
import '../../Models/user.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
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
        photo: _photo?.path, // Save the file path or URL
      );
      await DatabaseHelper().insertUser(newUser);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registered successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 15,
            children: [
              // CircleAvatar for the photo
              Center(
                child: GestureDetector(
                  onTap: _pickPhoto, // Allow tapping to pick a photo
                  child: Stack(
                    alignment: Alignment
                        .bottomRight, // Position the + icon at the bottom-right
                    children: [
                      CircleAvatar(
                        radius: 50, // Size of the CircleAvatar
                        backgroundImage: _photo != null
                            ? FileImage(_photo!) // Display the selected photo
                            : null, // No photo selected
                        child: _photo == null
                            ? Icon(Icons.person,
                                size: 50, color: Colors.white) // Default icon
                            : null,
                      ),
                      // + Icon
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 191, 201,
                              209), // Background color of the + icon
                          shape: BoxShape.circle, // Make the container circular
                        ),
                        padding: EdgeInsets.all(6), // Padding around the + icon
                        child: Icon(
                          Icons.add, // + icon
                          size: 20, // Size of the + icon
                          color: Colors.white, // Color of the + icon
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
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
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
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

              ElevatedButton(
                onPressed: _signup,
                child: Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
