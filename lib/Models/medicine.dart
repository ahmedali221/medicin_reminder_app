import 'dart:typed_data';

class Medicine {
  int? id;
  String name;
  String type;
  String dosage;
  String time;
  String frequency;
  String startDate;
  String endDate;
  String notes;
  Uint8List? image; // Add this field

  Medicine(
      {this.id,
      required this.name,
      required this.type,
      required this.dosage,
      required this.time,
      required this.frequency,
      required this.startDate,
      required this.endDate,
      required this.notes,
      this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'dosage': dosage,
      'time': time,
      'frequency': frequency,
      'startDate': startDate,
      'endDate': endDate,
      'notes': notes,
      'image': image, // Add this field
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      dosage: map['dosage'],
      time: map['time'],
      frequency: map['frequency'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      notes: map['notes'],
      image: map['image'], // Add this field
    );
  }
}
