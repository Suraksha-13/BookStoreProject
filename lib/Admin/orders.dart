import 'package:flutter/material.dart';
import '../Orders_provider.dart';
import 'AdminScaf.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  @override
  void initState() {
    super.initState();
    // FIXED: Explicitly commands your state platform store to fetch via Admin routes on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OrderProvider.of(context).refreshOrders(isAdmin: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = OrderProvider.of(context);

    return AdminMainScaffold(
      currentIndex: 1,
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.orders.isEmpty
          ? const Center(child: Text("No Orders Available", style: TextStyle(fontSize: 16)))
          : RefreshIndicator(
        // FIXED: Added refresh hook support to easily reload logs inside admin workspace
        onRefresh: () async => provider.refreshOrders(isAdmin: true),
        child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: provider.orders.length,
          itemBuilder: (context, index) {
            final order = provider.orders[index];
            final isApproved = order.status == "approved";
            final isRejected = order.status == "rejected";

            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Order #${order.id}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isApproved
                                ? Colors.green.withOpacity(0.2)
                                : (isRejected ? Colors.red.withOpacity(0.2) : Colors.orange.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                              order.status.toUpperCase(),
                              style: TextStyle(
                                  color: isApproved ? Colors.green : (isRejected ? Colors.red : Colors.orange),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              )
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text("Items: ${order.items.length}", style: const TextStyle(fontSize: 14, color: Colors.black54)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: isApproved ? null : () => provider.approveOrder(order.id),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text("Approve"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: isRejected ? null : () => provider.rejectOrder(order.id),
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text("Reject"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}