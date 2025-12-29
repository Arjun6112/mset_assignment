import 'package:flutter_test/flutter_test.dart';
import 'package:mset_assignment/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
      SharedPreferences.setMockInitialValues({});
    });

    test('should login successfully with valid credentials', () async {
      final result = await authService.login('testuser', 'password123');
      expect(result, true);
    });

    test('should fail login with empty username', () async {
      final result = await authService.login('', 'password123');
      expect(result, false);
    });

    test('should fail login with empty password', () async {
      final result = await authService.login('testuser', '');
      expect(result, false);
    });

    test('should store token after successful login', () async {
      await authService.login('testuser', 'password123');
      final token = await authService.getToken();
      expect(token, 'abc123');
    });

    test('should return true for isLoggedIn after login', () async {
      await authService.login('testuser', 'password123');
      final isLoggedIn = await authService.isLoggedIn();
      expect(isLoggedIn, true);
    });

    test('should return false for isLoggedIn before login', () async {
      final isLoggedIn = await authService.isLoggedIn();
      expect(isLoggedIn, false);
    });

    test('should clear token on logout', () async {
      await authService.login('testuser', 'password123');
      await authService.logout();
      final token = await authService.getToken();
      expect(token, null);
    });

    test('should return false for isLoggedIn after logout', () async {
      await authService.login('testuser', 'password123');
      await authService.logout();
      final isLoggedIn = await authService.isLoggedIn();
      expect(isLoggedIn, false);
    });
  });
}
