import 'package:flutter/material.dart';
import 'product_cart_provider.dart';

class Order {
  final List<Product> items;
  String status;

  Order({
    required this.items,
    this.status = "pending",
  });

  Order copyWith({List<Product>? items, String? status}) {
    return Order(
      items: items ?? this.items,
      status: status ?? this.status,
    );
  }
}

class OrderProvider extends InheritedWidget {
  final List<Order> orders;

  final Function(List<Product>) placeOrder;
  final Function(int index) approveOrder;
  final Function(int index) rejectOrder;

  const OrderProvider({
    super.key,
    required this.orders,
    required this.placeOrder,
    required this.approveOrder,
    required this.rejectOrder,
    required super.child,
  });

  static OrderProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<OrderProvider>()!;
  }

  @override
  bool updateShouldNotify(OrderProvider oldWidget) {
    return oldWidget.orders != orders;
  }
}

class OrderStore extends StatefulWidget {
  final Widget child;

  const OrderStore({super.key, required this.child});

  @override
  State<OrderStore> createState() => _OrderStoreState();
}

class _OrderStoreState extends State<OrderStore> {
  final List<Order> _orders = [];

  void _placeOrder(List<Product> items) {
    setState(() {
      _orders.add(Order(items: items));
    });
  }

  void _approve(int index) {
    setState(() {
      _orders[index].status = "approved";
    });
  }

  void _reject(int index) {
    setState(() {
      _orders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrderProvider(
      orders: _orders,
      placeOrder: _placeOrder,
      approveOrder: _approve,
      rejectOrder: _reject,
      child: widget.child,
    );
  }
}