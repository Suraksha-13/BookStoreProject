import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'active_user_id';
  static const String _userRoleKey = 'active_user_role'; // 🔥 Added role key

  // --- PRIVATE STORAGE HELPERS ---
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> _saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  // 🔥 Added helper to save user role
  static Future<void> _saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role);
  }

  // --- PUBLIC GETTERS FOR SESSION MANAGEMENT ---
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<int?> getActiveUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  // 🔥 Added getter to check if user is admin or regular user
  static Future<String?> getActiveUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  // Clear everything on logout
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userRoleKey); // 🔥 Clear role on logout
  }

  // --- AUTHENTICATION OPERATIONS ---

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/auth/login");
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      ).timeout(const Duration(seconds: 10));

      final Map<String, dynamic> data = jsonDecode(res.body);

      if (data["success"] == true) {
        if (data.containsKey("token")) {
          await _saveToken(data["token"]);
        }

        if (data.containsKey("user") && data["user"] != null) {
          final int? userId = int.tryParse(data["user"]["id"]?.toString() ?? '');
          if (userId != null) {
            await _saveUserId(userId);
          }

          // 🔥 Save user role (handles data keys named 'role' or 'role_name')
          final String? role = data["user"]["role"]?.toString() ?? data["user"]["role_name"]?.toString();
          if (role != null) {
            await _saveUserRole(role);
          }
        }
      }

      return data;
    } catch (e) {
      return {"success": false, "message": "Login failed: $e"};
    }
  }

  static Future<Map<String, dynamic>> register(UserModel user) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/auth/signup");

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      ).timeout(const Duration(seconds: 10));

      final Map<String, dynamic> data = jsonDecode(res.body);

      if (data["success"] == true) {
        if (data.containsKey("token")) {
          await _saveToken(data["token"]);
        }

        if (data.containsKey("user") && data["user"] != null) {
          final int? userId = int.tryParse(data["user"]["id"]?.toString() ?? '');
          if (userId != null) {
            await _saveUserId(userId);
          }

          // 🔥 Save user role upon successful signup
          final String? role = data["user"]["role"]?.toString() ?? data["user"]["role_name"]?.toString();
          if (role != null) {
            await _saveUserRole(role);
          }
        }
      }

      return data;
    } catch (e) {
      return {"success": false, "message": "Could not connect to database server: $e"};
    }
  }
}