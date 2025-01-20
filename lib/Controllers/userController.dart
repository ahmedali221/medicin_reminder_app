import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Models/user.dart';

// Define the UserNotifier class to manage user state
class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null); // Initial state is null (no user logged in)

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
