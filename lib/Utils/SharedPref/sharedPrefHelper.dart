import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _nameKey = 'name';
  static const String _photoUrlKey = 'photoUrl';

  // Save login state
  static Future<void> saveLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  // Save user data
  static Future<void> saveUserData(
      String username, String name, String photoUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_nameKey, name);
    await prefs.setString(_photoUrlKey, photoUrl);
  }

  // Clear user data (on logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_photoUrlKey);
  }

  // Check if the user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get user data
  static Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString(_usernameKey) ?? '',
      'name': prefs.getString(_nameKey) ?? '',
      'photoUrl': prefs.getString(_photoUrlKey) ?? '',
    };
  }
}
