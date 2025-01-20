import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MedicineFormHelper {
  // Function to pick an image from gallery or camera
  static Future<Uint8List?> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final option = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a Photo'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
        ],
      ),
    );

    if (option != null) {
      final pickedFile = await picker.pickImage(source: option);
      if (pickedFile != null) {
        return await File(pickedFile.path).readAsBytes();
      }
    }
    return null;
  }

  // Function to select a start date
  static Future<DateTime?> selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    return pickedDate;
  }

  // Function to select an end date
  static Future<DateTime?> selectEndDate(
      BuildContext context, DateTime startDate) async {
    if (startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a start date first'),
        ),
      );
      return null;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: DateTime(2100),
    );
    return pickedDate;
  }

  // Function to select a time
  static Future<TimeOfDay?> selectTime(
      BuildContext context, TimeOfDay initialTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    return pickedTime;
  }

  // Function to generate default times based on the number of frequencies
  static List<TimeOfDay> generateTimes(int numberOfFrequencies) {
    return List.generate(
      numberOfFrequencies,
      (index) => TimeOfDay(hour: 8 + index, minute: 0), // Default times
    );
  }
}
