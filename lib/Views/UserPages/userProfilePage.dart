import 'dart:io'; // Import for File class
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Controllers/userController.dart';

// UserProfilePage
class UserProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 15,
            children: [
              // Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: user.photo != null
                      ? FileImage(File(user.photo!)) // Load image from file
                      : null, // Fallback if no photo is available
                  child: user.photo == null
                      ? const Icon(Icons.person, size: 60) // Fallback icon
                      : null,
                ),
              ),
              // User Information in ListTiles
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person,
                          color: const Color(0xFF1565C0)),
                      title: const Text('Name'),
                      subtitle: Text(
                        user.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.alternate_email,
                          color: const Color(0xFF1565C0)),
                      title: const Text('Username'),
                      subtitle: Text(
                        user.username,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.email,
                          color: const Color(0xFF1565C0)),
                      title: const Text('Email'),
                      subtitle: Text(
                        user.email,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.phone,
                          color: const Color(0xFF1565C0)),
                      title: const Text('Phone Number'),
                      subtitle: Text(
                        user.phoneNumber,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              // Edit Profile Button
              ElevatedButton(
                onPressed: () {
                  // Show an alert dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog.adaptive(
                        icon: const Icon(Icons.info_outline,
                            color: Color(0xFF1565C0), size: 40),
                        title: const Text('Coming Soon'),
                        content: const Text(
                            'Editing the profile will be available in a future update. Stay tuned!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
