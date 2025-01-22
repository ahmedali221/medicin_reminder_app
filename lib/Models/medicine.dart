import 'dart:typed_data';
import 'dart:convert';

class Medicine {
  int? id;
  String name;
  String type;
  String dosage;
  List<String> times; // Changed to a list of times
  String frequency;
  String startDate;
  String endDate;
  String notes;
  Uint8List? image;

  Medicine({
    this.id,
    required this.name,
    required this.type,
    required this.dosage,
    required this.times, // Updated to accept a list of times
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.notes,
    this.image,
  });
  Medicine copyWith({
    int? id,
    String? name,
    String? type,
    String? dosage,
    List<String>? times,
    String? frequency,
    String? startDate,
    String? endDate,
    String? notes,
    Uint8List? image,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      dosage: dosage ?? this.dosage,
      times: times ?? this.times,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      image: image ?? this.image,
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'dosage': dosage,
      'times': jsonEncode(times), // Serialize the list to a JSON string
      'frequency': frequency,
      'startDate': startDate,
      'endDate': endDate,
      'notes': notes,
      'image': image,
    };
  }

  // Create from Map
  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      dosage: map['dosage'],
      times: List<String>.from(
          jsonDecode(map['times'])), // Deserialize the JSON string to a list
      frequency: map['frequency'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      notes: map['notes'],
      image: map['image'],
    );
  }

  // Validate Medicine
  bool isValid() {
    return name.isNotEmpty && dosage.isNotEmpty && times.isNotEmpty;
  }

  // Parse Time
  List<DateTime?> get scheduledTimes {
    return times.map((time) {
      try {
        final now = DateTime.now();
        if (time.contains("AM") || time.contains("PM")) {
          final timeParts = time.split(' ');
          final period = timeParts[1];
          final hourMinute = timeParts[0].split(':');
          var hour = int.parse(hourMinute[0]);
          final minute = int.parse(hourMinute[1]);

          if (period == "PM" && hour != 12) hour += 12;
          if (period == "AM" && hour == 12) hour = 0;

          return DateTime(now.year, now.month, now.day, hour, minute);
        } else {
          final timeParts = time.split(':');
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          return DateTime(now.year, now.month, now.day, hour, minute);
        }
      } catch (e) {
        print("Failed to parse time: $e");
        return null;
      }
    }).toList();
  }

  // Get Next Reminder Time
  List<DateTime?> getNextReminderTimes() {
    final scheduledTimes = this.scheduledTimes;
    if (scheduledTimes.isEmpty) return [];

    switch (frequency.toLowerCase()) {
      case "once a day":
        return scheduledTimes;
      case "twice a day":
        return scheduledTimes
            .map((time) => time?.add(const Duration(hours: 12)))
            .toList();
      case "thrice a day":
        return scheduledTimes
            .map((time) => time?.add(const Duration(hours: 8)))
            .toList();
      default:
        return [];
    }
  }

  // Convert Image to Base64
  String? get imageBase64 {
    return image != null ? base64Encode(image!) : null;
  }

  // Set Image from Base64
  set imageBase64(String? base64) {
    image = base64 != null ? base64Decode(base64) : null;
  }

  // Equality and Hashing
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Medicine && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
