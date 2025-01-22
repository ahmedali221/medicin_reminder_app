import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/user.dart';

import '../Utils/Database/userDatabaseHelper.dart';
import 'medicineController.dart'; // Import your user database helper

class UserNotifier extends StateNotifier<User?> {
  UserNotifier(this.ref) : super(null);

  final Ref ref; // Ref to access other providers

  Future<void> SetUser(User user) async {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier(ref);
});
