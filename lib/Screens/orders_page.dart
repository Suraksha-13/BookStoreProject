import 'package:flutter/material.dart';
import '../Orders_provider.dart';
import '../mainscreen.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = OrderProvider.of(context);

    return MainScaffold(
      currentIndex: 1,
      body: provider.orders.isEmpty
          ? const Center(child: Text("No orders yet"))
          : ListView.builder(
        itemCount: provider.orders.length,
        itemBuilder: (context, index) {
          final order = provider.orders[index];

          final isApproved = order.status == "approved";

          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 6),
            child: ExpansionTile(
              title: Text("Order #${index + 1}"),


              subtitle: Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isApproved
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isApproved ? "APPROVED" : "PENDING",
                  style: TextStyle(
                    color: isApproved
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),


              children: [
                ...order.items.map((item) {
                  return ListTile(
                    leading: Image.network(
                      item.image,
                      width: 40,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item.title),
                    trailing: Text("\$${item.price}"),
                  );
                }),

                const Divider(),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Status: ${order.status.toUpperCase()}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isApproved
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}