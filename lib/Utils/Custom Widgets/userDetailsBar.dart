import 'package:flutter/material.dart';
import 'dart:io';

import '../Helper Functions/functions.dart';

class UserDetailsBar extends StatelessWidget {
  final String userName;
  final String userPhotoUrl; // This can be a URL or a local file path
  final VoidCallback onSearchPressed;
  final BuildContext context; // Add context to access Scaffold

  const UserDetailsBar({
    Key? key,
    required this.userName,
    required this.userPhotoUrl,
    required this.onSearchPressed,
    required this.context, // Pass context from the parent widget
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Icon to open the drawer
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ), // Hamburger menu icon
          ),
          // User Photo
          // CircleAvatar(
          //   radius: screenWidth * 0.08, // Responsive radius
          //   backgroundImage: getImageProvider(userPhotoUrl), // Load image
          //   child: userPhotoUrl.isEmpty
          //       ? Icon(
          //           Icons.person, // Default icon if no photo is available
          //           size: screenWidth * 0.08, // Responsive icon size
          //           color: Colors.grey,
          //         )
          //       : null,
          // ),

          // User Name and Text
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Image.asset(
                    "assets/medLogo.png",
                    height: 30, // Adjusted height
                    width: 50, // Adjusted width
                  ),
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
}
