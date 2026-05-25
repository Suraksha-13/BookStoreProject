import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'active_user_id';

  // --- PRIVATE STORAGE HELPERS ---
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> _saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  // --- PUBLIC GETTERS FOR SESSION MANAGEMENT ---
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // This is what ShopService and OrderService use dynamically to get the ID
  static Future<int?> getActiveUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  // Clear everything on logout
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
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
        // Save the JWT token if present
        if (data.containsKey("token")) {
          await _saveToken(data["token"]);
        }

        // Extract and save the User ID from the inner user object safely
        if (data.containsKey("user") && data["user"] != null) {
          final int? userId = int.tryParse(data["user"]["id"]?.toString() ?? '');
          if (userId != null) {
            await _saveUserId(userId);
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
        // Save the JWT token if present
        if (data.containsKey("token")) {
          await _saveToken(data["token"]);
        }

        // Extract and save the newly generated User ID from the backend register response
        if (data.containsKey("user") && data["user"] != null) {
          final int? userId = int.tryParse(data["user"]["id"]?.toString() ?? '');
          if (userId != null) {
            await _saveUserId(userId);
          }
        }
      }

      return data;
    } catch (e) {
      return {"success": false, "message": "Could not connect to database server: $e"};
    }
  }
}