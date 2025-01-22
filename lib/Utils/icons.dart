import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

// Map to associate medicine types with icons
final Map<String, IconData> medicineTypeIcons = {
  'Pills': HugeIcons.strokeRoundedMedicine01, // Default pill icon
  'Syrup': HugeIcons.strokeRoundedMedicineSyrup, // Syrup icon (a drink)
  'Injection':
      HugeIcons.strokeRoundedInjection, // Injection icon (medical syringe)
};
