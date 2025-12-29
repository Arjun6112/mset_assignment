import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'github_token';
  static const String _dummyToken = 'abc123'; // Simulated token

  // Save the simulated token
  Future<bool> login(String username, String password) async {
    // Simulate login validation (dummy credentials)
    if (username.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, _dummyToken);
      return true;
    }
    return false;
  }

  // Retrieve the stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Logout and clear token
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
