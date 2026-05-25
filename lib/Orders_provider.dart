import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../services/order_service.dart';

class OrderProvider extends InheritedWidget {
  final List<Order> orders;
  final bool isLoading;
  final Function(List<Product>) placeOrder;
  final Function(int orderId) approveOrder;
  final Function(int orderId) rejectOrder;
  final Function() refreshOrders;

  const OrderProvider({
    super.key,
    required this.orders,
    required this.isLoading,
    required this.placeOrder,
    required this.approveOrder,
    required this.rejectOrder,
    required this.refreshOrders,
    required super.child,
  });

  static OrderProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<OrderProvider>()!;
  }

  @override
  bool updateShouldNotify(OrderProvider oldWidget) {
    return oldWidget.orders != orders || oldWidget.isLoading != isLoading;
  }
}

class OrderStore extends StatefulWidget {
  final Widget child;
  const OrderStore({super.key, required this.child});

  @override
  State<OrderStore> createState() => _OrderStoreState();
}

class _OrderStoreState extends State<OrderStore> {
  List<Order> _orders = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    setState(() => _isLoading = true);
    final data = await OrderService.fetchOrders();
    setState(() {
      _orders = data;
      _isLoading = false;
    });
  }

  void _place(List<Product> items) async {
    final success = await OrderService.placeOrder(items);
    if (success) await loadOrders();
  }

  void _approve(int oId) async {
    final success = await OrderService.updateStatus(oId, "approved");
    if (success) await loadOrders();
  }

  void _reject(int oId) async {
    final success = await OrderService.updateStatus(oId, "rejected");
    if (success) await loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return OrderProvider(
      orders: _orders,
      isLoading: _isLoading,
      placeOrder: _place,
      approveOrder: _approve,
      rejectOrder: _reject,
      refreshOrders: loadOrders,
      child: widget.child,
    );
  }
}