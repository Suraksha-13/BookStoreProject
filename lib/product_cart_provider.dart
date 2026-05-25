import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/shop_service.dart';

class ProductCartProvider extends InheritedWidget {
  final List<Product> cart;
  final bool isCartLoading;
  final Function(Product) addToCart;
  final Function(Product) removeFromCart;
  final Function() clearCart;
  final Function() refreshCart;

  const ProductCartProvider({
    super.key,
    required this.cart,
    required this.isCartLoading,
    required this.addToCart,
    required this.removeFromCart,
    required this.clearCart,
    required this.refreshCart,
    required super.child,
  });

  static ProductCartProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProductCartProvider>()!;
  }

  @override
  bool updateShouldNotify(ProductCartProvider oldWidget) {
    return oldWidget.cart != cart || oldWidget.isCartLoading != isCartLoading;
  }
}

class ProductCartStore extends StatefulWidget {
  final Widget child;
  const ProductCartStore({super.key, required this.child});

  @override
  State<ProductCartStore> createState() => _ProductCartStoreState();
}

class _ProductCartStoreState extends State<ProductCartStore> {
  List<Product> _cart = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadCartData();
  }

  Future<void> loadCartData() async {
    setState(() => _isLoading = true);
    final serverCart = await ShopService.fetchCart();
    setState(() {
      _cart = serverCart;
      _isLoading = false;
    });
  }

  void _add(Product product) async {
    final success = await ShopService.addItem(product.id);
    if (success) await loadCartData();
  }

  void _remove(Product product) async {
    final success = await ShopService.removeItem(product.id);
    if (success) await loadCartData();
  }

  void _clear() async {
    final success = await ShopService.purgeCart();
    if (success) setState(() => _cart.clear());
  }

  @override
  Widget build(BuildContext context) {
    return ProductCartProvider(
      cart: _cart,
      isCartLoading: _isLoading,
      addToCart: _add,
      removeFromCart: _remove,
      clearCart: _clear,
      refreshCart: loadCartData,
      child: widget.child,
    );
  }
}