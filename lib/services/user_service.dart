import '../models/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService{


  static Future<void> _saveToken(String token) async{

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> clearToken() async{

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');

  }


  static Future<Map<String, dynamic>> login(String email, String password) async{

    try{

      final url = Uri.parse("${ApiConfig.baseUrl}/auth/login");
      final res = await http.post(
        url,
        headers: {"Content-Type" : "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      ).timeout(const Duration(seconds: 10));

      final Map<String, dynamic> data = jsonDecode(res.body);

      if(data["success"] == true && data.containsKey("token")){
        await _saveToken(data["token"]);
      }

      return data;

    } catch(e){
      return {"success": false, "message": "Login failed: $e"};
    }

  }


}

