import 'product_model.dart';

class Order {
  final int id;
  final List<Product> items;
  final double totalPrice;
  String status;

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    this.status = "pending",
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int? ?? 0,
      status: json['status']?.toString() ?? 'pending',
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0.0') ?? 0.0,
      items: (json['items'] as List? ?? [])
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }
}