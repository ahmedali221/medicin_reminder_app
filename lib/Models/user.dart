class User {
  int? id;
  String username;
  String password;
  String name;
  String email; // New field
  String phoneNumber; // New field
  String? photo; // Photo can be a file path or a URL

  User({
    this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.email, // New field
    required this.phoneNumber, // New field
    this.photo,
  });

  // Convert a User into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'email': email, // New field
      'phoneNumber': phoneNumber, // New field
      'photo': photo,
    };
  }

  // Extract a User from a Map.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      name: map['name'],
      email: map['email'], // New field
      phoneNumber: map['phoneNumber'], // New field
      photo: map['photo'],
    );
  }

  // Validate required fields
  bool isValid() {
    return username.isNotEmpty &&
        password.isNotEmpty &&
        name.isNotEmpty &&
        email.isNotEmpty &&
        phoneNumber.isNotEmpty;
  }

  // Create a copy of the User object with updated fields
  User copyWith({
    int? id,
    String? username,
    String? password,
    String? name,
    String? email,
    String? phoneNumber,
    String? photo,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photo: photo ?? this.photo,
    );
  }

  // Override toString for easier debugging
  @override
  String toString() {
    return 'User(id: $id, username: $username, password: $password, name: $name, email: $email, phoneNumber: $phoneNumber, photo: $photo)';
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
