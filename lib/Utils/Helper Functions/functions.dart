// Helper function to format the date
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../Models/user.dart';

String formatDate(String dateString) {
  try {
    final DateTime date = DateTime.parse(dateString);
    return DateFormat('MMM dd, yyyy').format(date);
  } catch (e) {
    return dateString; // Return the original string if parsing fails
  }
}

// Helper method to determine the correct image provider
ImageProvider getImageProvider(String? url) {
  if (url == null || url.isEmpty) {
    return const AssetImage(
        'assets/placeholder.jpg'); // Default placeholder image
  } else if (url.startsWith('http') || url.startsWith('https')) {
    return NetworkImage(url); // Network image
  } else {
    return FileImage(File(url)); // Local file image
  }
}

String formatDosage(String dosage, String type) {
  switch (type.toLowerCase()) {
    case 'pills':
      return '$dosage pills';
    case 'syrup':
      return '$dosage ml';
    case 'injection':
      return '$dosage mg';
    default:
      return dosage; // Fallback if type is unknown
  }
}

Future<User?> fetchUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userName = prefs.getString('userName');
  String? userPhoto = prefs.getString('userPhoto');

  if (userName != null) {
    return User(name: userName, photo: userPhoto);
  }
  return null;
}
