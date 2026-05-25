import 'package:flutter/material.dart';
import '../Orders_provider.dart';
import '../services/shop_service.dart';
import '../models/product_model.dart';
import 'AdminScaf.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _refreshDashboardData();
  }

  void _refreshDashboardData() {
    setState(() {
      _productsFuture = ShopService.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = OrderProvider.of(context);
    final orders = orderProvider.orders;

    final int totalOrders = orders.length;
    final int pending = orders.where((o) => o.status.toLowerCase() == "pending").length;
    final int approved = orders.where((o) => o.status.toLowerCase() == "approved").length;

    return AdminMainScaffold(
      currentIndex: 0,
      body: RefreshIndicator(
        onRefresh: () async {
          orderProvider.refreshOrders(); // Refreshes orders pipeline state
          _refreshDashboardData();       // Refreshes catalog list items state
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Overview Dashboard",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Real-time monitoring metrics and inventory status",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              // FutureBuilder loads product length metrics from database context dynamically
              FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  final int booksCount = snapshot.hasData ? snapshot.data!.length : 0;
                  final bool isCatalogLoading = snapshot.connectionState == ConnectionState.waiting;

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.15,
                    children: [
                      _buildDashboardCard(
                        title: "Total Orders",
                        count: totalOrders.toString(),
                        color: Colors.blue.shade700,
                        backgroundColor: Colors.blue.shade50,
                        icon: Icons.shopping_basket_outlined,
                      ),
                      _buildDashboardCard(
                        title: "Pending Sync",
                        count: pending.toString(),
                        color: Colors.orange.shade800,
                        backgroundColor: Colors.orange.shade50,
                        icon: Icons.hourglass_empty_rounded,
                      ),
                      _buildDashboardCard(
                        title: "Approved Batches",
                        count: approved.toString(),
                        color: Colors.green.shade700,
                        backgroundColor: Colors.green.shade50,
                        icon: Icons.check_circle_outline_rounded,
                      ),
                      _buildDashboardCard(
                        title: "Books Cataloged",
                        count: booksCount.toString(),
                        color: Colors.purple.shade700,
                        backgroundColor: Colors.purple.shade50,
                        icon: Icons.auto_stories_outlined,
                        isLoading: isCatalogLoading,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String count,
    required Color color,
    required Color backgroundColor,
    required IconData icon,
    bool isLoading = false,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.15), width: 1.5),
      ),
      color: backgroundColor.withOpacity(0.6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 26, color: color),
            ),
            const Spacer(),
            isLoading
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            )
                : Text(
              count,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
