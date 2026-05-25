import 'package:flutter/material.dart';
import '../UserProvider.dart';
import 'AdminScaf.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  void _logout(BuildContext context) {
    final provider = UserProvider.of(context);
    provider.logout();


    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = UserProvider.of(context).user;

    return AdminMainScaffold(
      currentIndex: 3,
      body: user == null
          ? const Center(child: Text("No admin logged in"))
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.admin_panel_settings, size: 60),
            const SizedBox(height: 10),

            Text(
              user.username,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Text(user.email),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _logout(context),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}