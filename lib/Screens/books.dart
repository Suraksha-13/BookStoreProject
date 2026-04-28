import 'package:flutter/material.dart';
import '../product_cart_provider.dart';
import '../mainscreen.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final List<Product> books = [
    Product(
      id: "1",
      title: "The Rich Dad",
      image: "https://covers.openlibrary.org/b/id/5546156-L.jpg",
      price: 12.99,
    ),
    Product(
      id: "2",
      title: "Think and Grow Rich",
      image: "https://covers.openlibrary.org/b/id/8231996-L.jpg",
      price: 10.50,
    ),
    Product(
      id: "3",
      title: "Atomic Habits",
      image: "https://covers.openlibrary.org/b/id/11153270-L.jpg",
      price: 15.00,
    ),
    Product(
      id: "4",
      title: "How to Win Friends",
      image: "https://covers.openlibrary.org/b/id/8084616-L.jpg",
      price: 9.99,
    ),
    Product(
      id: "5",
      title: "Deep Work",
      image: "https://covers.openlibrary.org/b/id/8228691-L.jpg",
      price: 14.25,
    ),
    Product(
      id: "6",
      title: "The Alchemist",
      image: "https://covers.openlibrary.org/b/id/10594761-L.jpg",
      price: 11.75,
    ),
    Product(
      id: "7",
      title: "Zero to One",
      image: "https://covers.openlibrary.org/b/id/8370226-L.jpg",
      price: 16.40,
    ),
  ];

  List<Product> filtered = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filtered = List.from(books);
  }

  void search(String value) {
    setState(() {
      filtered = books
          .where((b) =>
          b.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ProductCartProvider.of(context);

    return MainScaffold(
      currentIndex: 1,
      body: SafeArea(
        child: Column(
          children: [


            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: searchController,
                onChanged: search,
                decoration: InputDecoration(
                  hintText: "Search books...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),


            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: filtered.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.58,
                ),
                itemBuilder: (context, index) {
                  final book = filtered[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [


                        Expanded(
                          flex: 6,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              book.image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) =>
                              const Icon(Icons.broken_image),
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),


                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            book.title,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),

                        const SizedBox(height: 2),


                        Text(
                          "\$${book.price}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),

                        const SizedBox(height: 4),


                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: SizedBox(
                            width: double.infinity,
                            height: 32,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                provider.addToCart(book);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Added to cart"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              child: const Text("Add"),
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}