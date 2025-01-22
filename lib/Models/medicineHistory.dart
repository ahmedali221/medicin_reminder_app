import 'dart:typed_data';

import 'package:MedTime/Models/medicine.dart';

// Simplified MedicineHistory class that only tracks the status and timestamp
class MedicineHistory {
  final int? id;
  final Medicine medicine; // Reference to the Medicine object
  final String status; // e.g., "Taken", "Skipped", "Snoozed"
  final DateTime timestamp; // Timestamp of the action

  MedicineHistory({
    this.id,
    required this.medicine,
    required this.status,
    required this.timestamp,
  });

  // Convert MedicineHistory object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineId': medicine.id, // Store only the medicine ID in the history
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create MedicineHistory object from Map
  factory MedicineHistory.fromMap(Map<String, dynamic> map, Medicine medicine) {
    return MedicineHistory(
      id: map['id'],
      medicine: medicine, // Pass the complete Medicine object
      status: map['status'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
