import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../product_cart_provider.dart';
import '../services/shop_service.dart';
import '../mainscreen.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List<Product> _catalog = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    loadCatalog();
  }

  Future<void> loadCatalog() async {
    setState(() => _loading = true);
    final data = await ShopService.fetchProducts();
    setState(() {
      _catalog = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartStore = ProductCartProvider.of(context);

    return MainScaffold(
      currentIndex: 0,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _catalog.isEmpty
          ? const Center(child: Text("No Books Available inside Database"))
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: _catalog.length,
        itemBuilder: (context, idx) {
          final b = _catalog[idx];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    b.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (c, e, s) => const Center(
                        child: Icon(Icons.broken_image, size: 40)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text("\$${b.price.toStringAsFixed(2)}"),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Await complete database transaction sequence
                            await cartStore.addToCart(b);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added "${b.title}" to cart!'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          child: const Text("Add to Cart"),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}