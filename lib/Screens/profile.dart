import 'package:flutter/material.dart';
import '../UserProvider.dart';
import '../mainscreen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = UserProvider.of(context);
    final user = provider.user;

    return MainScaffold(
      currentIndex: 2,
      body: SafeArea(
        child: user == null
            ? const Center(child: Text("No user logged in"))
            : Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const SizedBox(height: 20),

              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Name"),
                subtitle: Text(user.username),
              ),

              ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                subtitle: Text(user.email),
              ),

              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text("Password"),
                subtitle: Text("*" * user.password.length),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: user.role == "admin"
                      ? Colors.red
                      : Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user.role.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),

                  onPressed: () {

                    provider.logout();

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                          (route) => false,
                    );
                  },

                  child: const Text("Logout"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}