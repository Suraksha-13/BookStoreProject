import 'package:flutter/material.dart';
import '../product_cart_provider.dart';
import '../Orders_provider.dart';
import '../mainscreen.dart';
import '../models/product_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ProductCartProvider.of(context).refreshCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = ProductCartProvider.of(context);
    final orderProvider = OrderProvider.of(context);

    double total = cartProvider.cart.fold(
      0.0,
          (sum, item) => sum + (item.price * item.quantity),
    );

    return MainScaffold(
      currentIndex: 2,
      body: cartProvider.isCartLoading
          ? const Center(child: CircularProgressIndicator())
          : cartProvider.cart.isEmpty
          ? const Center(
        child: Text(
          "Your shopping cart is empty",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.cart.length,
              itemBuilder: (context, index) {
                final book = cartProvider.cart[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          book.image,
                          width: 50,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                      title: Text(
                        book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          "\$${book.price.toStringAsFixed(2)} x ${book.quantity}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                            onPressed: () async {
                              await cartProvider.removeFromCart(book);
                            },
                          ),
                          Text(
                            "${book.quantity}",
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                            onPressed: () async {
                              await cartProvider.addToCart(book);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                )
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Amount:",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "\$${total.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        final cartSnapshot = List<Product>.from(cartProvider.cart);

                        orderProvider.placeOrder(cartSnapshot);
                        cartProvider.clearCart();
                        await cartProvider.refreshCart();

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Order placed successfully!"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Proceed to Checkout",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}