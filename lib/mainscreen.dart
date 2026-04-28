import 'package:flutter/material.dart';
import 'product_cart_provider.dart';
import 'UserProvider.dart';

class MainScaffold extends StatefulWidget {
  final Widget body;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.body,
    this.currentIndex = 0,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/books');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  void _logout(BuildContext context) {
    final userProvider = UserProvider.of(context);


    userProvider.logoutUser();


    final cartProvider = ProductCartProvider.of(context);
    cartProvider.clearCart();


    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = ProductCartProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Book Store",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, size: 30),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              if (cartProvider.cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartProvider.cart.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 20),

            ListTile(
              title: const Text("Home"),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/home'),
            ),

            ListTile(
              title: const Text("Books"),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/books'),
            ),

            ListTile(
              title: const Text("Cart"),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/cart'),
            ),

            ListTile(
              title: const Text("Orders"),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/userOrders'),
            ),

            const Divider(),


            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout, color: Colors.red),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),

      body: widget.body,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}