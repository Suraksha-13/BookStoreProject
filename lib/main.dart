import 'package:flutter/material.dart';

import 'package:bookstore/Screens/HomePage.dart';
import 'package:bookstore/authentication/login.dart';
import './authentication/Signup.dart';
import './Screens/books.dart';
import 'UserProvider.dart';
import 'product_cart_provider.dart';

import './Screens/cartpage.dart';
import './Screens/profile.dart';

import './Admin/AdminPage.dart';
import './Admin/orders.dart';
import './Admin/adminProfile.dart';
import './Admin/addAdmin.dart';
import './Admin/AddBook.dart';

import './Screens/orders_page.dart';

import 'Orders_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UserStore(
      child: ProductCartStore(
        child: OrderStore(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,

            initialRoute: '/',

            routes: {
              '/': (context) => const LoginPage(),
              '/home': (context) => const HomePage(),
              '/signup': (context) => const SignupPage(),

              '/books': (context) => const BooksPage(),
              '/cart': (context) => const CartPage(),
              '/profile': (context) => const ProfilePage(),
              '/admin': (context) => const AdminHomePage(),
              '/admin_orders': (context) => const AdminOrdersPage(),
              '/admin_profile': (context) => const AdminProfilePage(),
              '/admin_add': (context) => const AddAdminPage(),
              '/addBook': (context) => const AdminAddBookPage(),

              '/userOrders': (context) => const OrdersPage(),
            },

            title: 'Bookstore App',

            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
              ),
            ),
          ),
        ),
      ),
    );
  }
}