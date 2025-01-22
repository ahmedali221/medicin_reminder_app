// import 'dart:typed_data';

// class MedicineHistory {
//   final int? id;
//   final int medicineId; // ID of the associated medicine
//   final String medicationName; // Name of the medicine
//   final String type; // Dosage of the medicine
//   final String dosage; // Dosage of the medicine
//   final String status; // e.g., "Taken", "Skipped", "Snoozed"
//   final DateTime timestamp; // Timestamp of the action
//   Uint8List? image; // Add this field

//   MedicineHistory({
//     this.id,
//     required this.dosage,
//     required this.type,
//     required this.medicineId,
//     required this.medicationName,
//     required this.status,
//     required this.timestamp,
//     this.image,
//   });

//   // Convert a MedicineHistory object into a Map
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'medicineId': medicineId,
//       'medicationName': medicationName,
//       'status': status,
//       'dosage': dosage,
//       'type': type,
//       'timestamp': timestamp.toIso8601String(),
//       'image': image, // Add this field
//     };
//   }

//   // Extract a MedicineHistory object from a Map
//   factory MedicineHistory.fromMap(Map<String, dynamic> map) {
//     return MedicineHistory(
//       id: map['id'],
//       type: map['type'],
//       medicineId: map['medicineId'],
//       medicationName: map['medicationName'],
//       dosage: map['dosage'],
//       status: map['status'],
//       timestamp: DateTime.parse(map['timestamp']),
//       image: map['image'], // Add this field
//     );
//   }
// }
