import 'package:flutter/material.dart';
import '../UserProvider.dart';
import '../models/user_model.dart';
import '../services/user_service.dart'; // Points to your AuthService
import '../Admin/AdminScaf.dart';

class AddAdminPage extends StatefulWidget {
  const AddAdminPage({super.key});

  @override
  State<AddAdminPage> createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;
  bool isLoading = false; // Tracks whether the network call is processing

  /// Validates inputs locally before hitting the database endpoint
  bool validateInputs() {
    setState(() {
      nameError = null;
      emailError = null;
      passwordError = null;
    });

    bool isValid = true;

    if (nameController.text.trim().isEmpty) {
      nameError = "Username is required";
      isValid = false;
    }

    if (emailController.text.trim().isEmpty) {
      emailError = "Email is required";
      isValid = false;
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError = "Password is required";
      isValid = false;
    } else if (passwordController.text.trim().length < 6) {
      passwordError = "Password must be at least 6 characters";
      isValid = false;
    }

    return isValid;
  }

  /// Sends the new admin details to your Node.js/Express backend asynchronously
  void addAdmin() async {
    if (!validateInputs()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fix errors before continuing"),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Create the UserModel bundle explicitly setting the role parameter to 'admin'
    final newAdmin = UserModel(
      username: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      role: "admin", // 🔥 Explicitly passing 'admin' role privileges
    );

    // Hit the database using your centralized AuthService
    final response = await AuthService.register(newAdmin);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (response["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("New admin created successfully"),
          backgroundColor: Colors.green,
        ),
      );

      // Clean out input text field controllers upon successful creation entry
      nameController.clear();
      emailController.clear();
      passwordController.clear();
    } else {
      // Show backend validation or duplicate email errors
      final errorMsg = response["message"] ?? "Failed to create admin profile.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminMainScaffold(
      currentIndex: 3,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Create New Admin",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Username Input
                  TextField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Username",
                      errorText: nameError,
                      prefixIcon: const Icon(Icons.person_add_alt_1_outlined),
                      border: const OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Email Input
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Email",
                      errorText: emailError,
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: const OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Password Input
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => addAdmin(),
                    decoration: InputDecoration(
                      labelText: "Password",
                      errorText: passwordError,
                      prefixIcon: const Icon(Icons.admin_panel_settings_outlined),
                      border: const OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Asymmetric submission block with an interactive loading guard
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : addAdmin,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blueAccent,
                        ),
                      )
                          : const Text(
                        "Create Admin",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}