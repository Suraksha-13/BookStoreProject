import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import 'user_service.dart';

class OrderService {
  static const Map<String, String> _headers = {"Content-Type": "application/json"};

  static Future<List<Order>> fetchOrders() async {
    try {
      final uId = await AuthService.getActiveUserId();
      if (uId == null) return [];

      // FIXED: Removed extra /api since ApiConfig.baseUrl handles it
      final res = await http.post(
          Uri.parse("${ApiConfig.baseUrl}/orders/my-orders"),
          headers: _headers,
          body: jsonEncode({"userId": uId})
      );

      if (res.statusCode == 200) {
        return (jsonDecode(res.body)['orders'] as List).map((o) => Order.fromJson(o)).toList();
      }
      return [];
    } catch (_) { return []; }
  }

  static Future<List<Order>> fetchAllAdminOrders() async {
    try {
      // FIXED: Removed extra /api so it maps to /api/orders/admin-all seamlessly
      final targetUrl = "${ApiConfig.baseUrl}/orders/admin-all";
      print("[Flutter Network] Requesting Admin Logs from: $targetUrl");

      final res = await http.get(Uri.parse(targetUrl), headers: _headers);
      print("[Flutter Network] Admin Status Code: ${res.statusCode}");
      print("[Flutter Network] Admin Raw Payload Response: ${res.body}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(res.body);
        if (decoded['success'] == true && decoded['orders'] != null) {
          return (decoded['orders'] as List).map((o) => Order.fromJson(o)).toList();
        }
      }
      return [];
    } catch (e) {
      print("[Flutter Error] Failed fetching global admin records: $e");
      return [];
    }
  }

  static Future<bool> placeOrder(List<Product> items) async {
    try {
      final uId = await AuthService.getActiveUserId();
      double total = items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

      // FIXED: Cleared duplicate path matching config specifications
      final res = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/orders/place"),
        headers: _headers,
        body: jsonEncode({"userId": uId, "total_price": total, "items": items.map((i) => i.toJson()).toList()}),
      );
      return jsonDecode(res.body)["success"] == true;
    } catch (_) { return false; }
  }

  static Future<bool> updateStatus(int orderId, String status) async {
    try {
      // FIXED: Cleared duplicate path matching config specifications
      final res = await http.post(
          Uri.parse("${ApiConfig.baseUrl}/orders/update-status"),
          headers: _headers,
          body: jsonEncode({"orderId": orderId, "status": status})
      );
      return jsonDecode(res.body)["success"] == true;
    } catch (_) { return false; }
  }
}