class Product {
  final int id;
  final String title;
  final String image;
  final double price;
  final int quantity;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      title: json['title']?.toString() ?? '',
      image: json['image_url']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "quantity": quantity,
  };
}