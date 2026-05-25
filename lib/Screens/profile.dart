import 'package:flutter/material.dart';
import '../UserProvider.dart';
import '../mainscreen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = UserProvider.of(context);
    final user = provider.user;

    // Determine role badge color scheme dynamically
    final bool isAdmin = user?.role.toLowerCase() == "admin";
    final Color badgeColor = isAdmin ? Colors.red : Colors.blue;

    return MainScaffold(
      currentIndex: 3, // FIXED: Set to 3 to avoid conflicting with your Cart page highlighting
      body: SafeArea(
        child: user == null
            ? const Center(
          child: Text(
            "No active user session found.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // --- AVATAR PRESENTATION LAYER ---
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Icon(
                          Icons.account_circle,
                          size: 110,
                          color: Theme.of(context).primaryColor
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: badgeColor.withOpacity(0.3), width: 1),
                      ),
                      child: Text(
                        user.role.toUpperCase(),
                        style: TextStyle(
                            color: badgeColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- ACCOUNT DETAILS GROUP PANEL ---
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person_outline, color: Theme.of(context).primaryColor),
                        title: const Text("Username", style: TextStyle(fontSize: 13, color: Colors.grey)),
                        subtitle: Text(
                            user.username,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: Icon(Icons.email_outlined, color: Theme.of(context).primaryColor),
                        title: const Text("Email Address", style: TextStyle(fontSize: 13, color: Colors.grey)),
                        subtitle: Text(
                            user.email,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
                        title: const Text("Password security", style: TextStyle(fontSize: 13, color: Colors.grey)),
                        subtitle: Text(
                            "•" * (user.password.length > 12 ? 12 : user.password.length),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // --- DESTRUCTIVE ACCOUNT INTERACTION CONTROL ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red.shade700,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.red.shade200, width: 1)
                    ),
                  ),
                  onPressed: () {
                    // Flush authentication state tokens inside context manager memory
                    provider.logout();

                    // Wipe route stack history completely back down to gateway root
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                          (route) => false,
                    );
                  },
                  label: const Text(
                    "Log Out Session",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}