import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String image;
  final double price;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
  });
}

class ProductCartProvider extends InheritedWidget {
  final List<Product> cart;

  final Function(Product) addToCart;
  final Function(Product) removeFromCart;
  final Function() clearCart;

  const ProductCartProvider({
    super.key,
    required this.cart,
    required this.addToCart,
    required this.removeFromCart,
    required this.clearCart,
    required super.child,
  });

  static ProductCartProvider of(BuildContext context) {
    final provider =
    context.dependOnInheritedWidgetOfExactType<ProductCartProvider>();

    if (provider == null) {
      throw FlutterError("ProductCartProvider not found");
    }

    return provider;
  }

  @override
  bool updateShouldNotify(ProductCartProvider oldWidget) {
    return oldWidget.cart != cart;
  }
}

class ProductCartStore extends StatefulWidget {
  final Widget child;

  const ProductCartStore({super.key, required this.child});

  @override
  State<ProductCartStore> createState() => _ProductCartStoreState();
}

class _ProductCartStoreState extends State<ProductCartStore> {
  final List<Product> _cart = [];

  void _add(Product product) {
    setState(() {
      _cart.add(product);
    });
  }

  void _remove(Product product) {
    setState(() {
      _cart.removeWhere((item) => item.id == product.id);
    });
  }

  void _clear() {
    setState(() {
      _cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProductCartProvider(
      cart: _cart,
      addToCart: _add,
      removeFromCart: _remove,
      clearCart: _clear,
      child: widget.child,
    );
  }
}