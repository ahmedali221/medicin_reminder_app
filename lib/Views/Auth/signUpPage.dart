import 'package:MedTime/Views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../Controllers/medicineController.dart';
import '../../Controllers/userController.dart';
import '../../Utils/Database/database.dart';
import '../../Models/user.dart';
import '../../Utils/Custom Widgets/richText.dart';
import '../../Utils/Database/databaseHelper.dart';
import '../../Utils/Database/userDatabaseHelper.dart';

class SignupPage extends ConsumerStatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _photo;
  String? _photoError; // To store photo error message

  Future<void> _pickPhoto() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
        _photoError = null; // Clear error when photo is selected
      });
    }
  }

  Future<void> _signup() async {
    if (_photo == null) {
      setState(() {
        _photoError = "Please select a photo";
      });
      return; // Stop signup process if no photo
    }

    if (_formKey.currentState!.validate()) {
      User newUser = User(
        name: _nameController.text,
        photo: _photo?.path,
      );

      final databaseInstance = ref.read(databaseInstanceProvider);
      final userDbHelper = UserDatabaseHelper(databaseInstance);

      await userDbHelper.insertUser(newUser);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameController.text);
      await prefs.setString('userPhoto', _photo!.path);

      await ref.read(userProvider.notifier).SetUser(newUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User registered successfully!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ReminderListScreen()),
      );
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
                'Enter Your Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: _pickPhoto,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            _photo != null ? FileImage(_photo!) : null,
                        child: _photo == null
                            ? const Icon(Icons.person,
                                size: 50, color: Colors.white)
                            : null,
                      ),
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
              if (_photoError !=
                  null) // Show error message if photo is not selected
                Text(
                  _photoError!,
                  style: const TextStyle(color: Colors.red),
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
              ElevatedButton(
                onPressed: _signup,
                child: const Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
