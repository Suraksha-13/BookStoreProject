import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import '../models/product_model.dart';
import 'user_service.dart';

class ShopService {
  static const Map<String, String> _headers = {"Content-Type": "application/json"};

  static Future<List<Product>> fetchProducts() async {
    try {
      final res = await http.get(Uri.parse("${ApiConfig.baseUrl}/shop/products"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data['products'] as List).map((p) => Product.fromJson(p)).toList();
      }
      return [];
    } catch (_) { return []; }
  }

  static Future<List<Product>> fetchCart() async {
    try {
      final uId = await AuthService.getActiveUserId();
      if (uId == null) return [];
      final res = await http.post(Uri.parse("${ApiConfig.baseUrl}/shop/cart"), headers: _headers, body: jsonEncode({"userId": uId}));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data['cart'] as List).map((p) => Product.fromJson(p)).toList();
      }
      return [];
    } catch (_) { return []; }
  }

  static Future<bool> addItem(int pId) async {
    try {
      final uId = await AuthService.getActiveUserId();
      final res = await http.post(Uri.parse("${ApiConfig.baseUrl}/shop/cart/add"), headers: _headers, body: jsonEncode({"userId": uId, "product_id": pId}));
      return jsonDecode(res.body)["success"] == true;
    } catch (_) { return false; }
  }

  static Future<bool> removeItem(int pId) async {
    try {
      final uId = await AuthService.getActiveUserId();
      final res = await http.post(Uri.parse("${ApiConfig.baseUrl}/shop/cart/remove"), headers: _headers, body: jsonEncode({"userId": uId, "product_id": pId}));
      return jsonDecode(res.body)["success"] == true;
    } catch (_) { return false; }
  }

  static Future<bool> purgeCart() async {
    try {
      final uId = await AuthService.getActiveUserId();
      final res = await http.post(Uri.parse("${ApiConfig.baseUrl}/shop/cart/clear"), headers: _headers, body: jsonEncode({"userId": uId}));
      return jsonDecode(res.body)["success"] == true;
    } catch (_) { return false; }
  }
}