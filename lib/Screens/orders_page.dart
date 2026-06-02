import 'package:flutter/material.dart';
import '../Orders_provider.dart';
import '../mainscreen.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    // Forces data fetch immediately when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OrderProvider.of(context).refreshOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = OrderProvider.of(context);

    return MainScaffold(
      currentIndex: 1,
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.orders.isEmpty
          ? const Center(child: Text("No orders yet"))
          : RefreshIndicator(
        onRefresh: () async => provider.refreshOrders(),
        child: ListView.builder(
          itemCount: provider.orders.length,
          itemBuilder: (context, index) {
            final order = provider.orders[index];
            final isApproved = order.status == "approved";
            final isRejected = order.status == "rejected";

            Color statusColor = Colors.orange;
            if (isApproved) statusColor = Colors.green;
            if (isRejected) statusColor = Colors.red;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ExpansionTile(
                title: Text("Order ID: #${order.id}"),
                subtitle: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order.status.toUpperCase(),
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                    const Spacer(),
                    Text("Total: \$${order.totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                children: [
                  ...order.items.map((item) => ListTile(
                    leading: item.image.isNotEmpty
                        ? Image.network(
                      item.image,
                      width: 40,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag),
                    )
                        : const Icon(Icons.shopping_bag),
                    title: Text(item.title),
                    subtitle: Text("Qty: ${item.quantity}"),
                    trailing: Text("\$${(item.price * item.quantity).toStringAsFixed(2)}"),
                  )),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Status: ${order.status.toUpperCase()}",
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}