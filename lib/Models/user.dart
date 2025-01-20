class User {
  int? id;
  String username;
  String password;
  String name;
  String? photo; // Photo can be a file path or a URL

  User({
    this.id,
    required this.username,
    required this.password,
    required this.name,
    this.photo,
  });

  // Convert a User into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
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
      photo: map['photo'],
    );
  }
}
