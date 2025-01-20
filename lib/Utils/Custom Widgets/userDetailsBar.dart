import 'package:flutter/material.dart';
import 'dart:io';

class UserDetailsBar extends StatelessWidget {
  final String userName;
  final String userPhotoUrl; // This can be a URL or a local file path
  final VoidCallback onSearchPressed;

  const UserDetailsBar({
    Key? key,
    required this.userName,
    required this.userPhotoUrl,
    required this.onSearchPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // User Photo
          CircleAvatar(
            radius: screenWidth * 0.08, // Responsive radius
            backgroundImage: _getImageProvider(userPhotoUrl), // Load image
            child: userPhotoUrl.isEmpty
                ? Icon(
                    Icons.person, // Default icon if no photo is available
                    size: screenWidth * 0.08, // Responsive icon size
                    color: Colors.grey,
                  )
                : null,
          ),
          const SizedBox(width: 16), // Add spacing between avatar and text
          // User Name and Text
          Expanded(
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Hello, ", // "Hello" part
                        style: TextStyle(
                          fontSize: screenWidth * 0.04, // Responsive font size
                          fontWeight: FontWeight.normal,
                          color: Colors.blue[900],
                        ),
                      ),
                      TextSpan(
                        text: userName, // User name part
                        style: TextStyle(
                          fontSize: screenWidth * 0.045, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.waving_hand_outlined,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16), // Add spacing before the settings icon
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.black,
            onPressed: onSearchPressed,
          ),
        ],
      ),
    );
  }

  // Helper method to determine the correct image provider
  ImageProvider _getImageProvider(String url) {
    if (url.isEmpty) {
      return const AssetImage('assets/placeholder.png');
    } else if (url.startsWith('http') || url.startsWith('https')) {
      return NetworkImage(url);
    } else {
      return FileImage(File(url));
    }
  }
}
