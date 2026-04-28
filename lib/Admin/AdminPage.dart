import 'package:flutter/material.dart';
import '../Orders_provider.dart';
import 'AdminScaf.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = OrderProvider.of(context);

    final orders = orderProvider.orders;

    final totalOrders = orders.length;

    final pending = orders.where((o) => o.status == "pending").length;
    final approved = orders.where((o) => o.status == "approved").length;

    const totalBooksAvailable = 7;

    return AdminMainScaffold(
      currentIndex: 0,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [

                  dashboardCard(
                    title: "Total Orders",
                    count: totalOrders,
                    color: Colors.blue,
                    icon: Icons.shopping_cart,
                  ),

                  dashboardCard(
                    title: "Pending",
                    count: pending,
                    color: Colors.orange,
                    icon: Icons.hourglass_empty,
                  ),

                  dashboardCard(
                    title: "Approved",
                    count: approved,
                    color: Colors.green,
                    icon: Icons.check_circle,
                  ),

                  dashboardCard(
                    title: "Books Available",
                    count: totalBooksAvailable,
                    color: Colors.purple,
                    icon: Icons.menu_book,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 35, color: color),

          const SizedBox(height: 10),

          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}