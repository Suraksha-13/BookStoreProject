import 'package:flutter/material.dart';
import '../product_cart_provider.dart';
import '../Orders_provider.dart';
import '../mainscreen.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = ProductCartProvider.of(context);
    final orderProvider = OrderProvider.of(context);

    double total = cartProvider.cart.fold(
      0,
          (sum, item) => sum + item.price,
    );

    return MainScaffold(
      currentIndex: 2,
      body: cartProvider.cart.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.cart.length,
              itemBuilder: (context, index) {
                final book = cartProvider.cart[index];

                return ListTile(
                  leading: Image.network(book.image, width: 50),
                  title: Text(book.title),
                  subtitle: Text("\$${book.price}"),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text("Total: \$${total.toStringAsFixed(2)}"),

                ElevatedButton(
                  onPressed: () {
                    orderProvider.placeOrder(cartProvider.cart);
                    cartProvider.clearCart();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Order placed"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text("Buy Now"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}