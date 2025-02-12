import 'dart:convert';

class User {
  int? id;
  String name;
  String? photo; // Photo can be a file path or a URL

  User({
    this.id,
    required this.name,
    this.photo,
  });

  // Convert a User into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
    };
  }

  // Convert User object to JSON
  String toJson() {
    return '{"name": "$name", "photo": "$photo"}';
  }

  // Create User object from JSON
  factory User.fromJson(String json) {
    final Map<String, dynamic> data =
        Map<String, dynamic>.from(jsonDecode(json));
    return User(
      name: data['name'],
      photo: data['photo'],
    );
  }
  // Extract a User from a Map.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      photo: map['photo'],
    );
  }

  // Create a copy of the User object with updated fields
  User copyWith({
    int? id,
    String? name,
    String? photo,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
    );
  }

  // Override toString for easier debugging
  @override
  String toString() {
    return 'User(id: $id, name: $name, photo: $photo)';
  }

  // Override == and hashCode to compare User objects based on their id
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
