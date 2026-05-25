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
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;

  bool isLoading = false;
  bool _obscurePassword = true; // Handles dynamic visibility toggling

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

    final emailText = emailController.text.trim();
    if (emailText.isEmpty) {
      emailError = "Email is required";
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailText)) {
      emailError = "Please enter a valid email address";
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
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
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
          content: Text("New admin profile created successfully!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
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
          behavior: SnackBarBehavior.floating,
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER BRANDING BLOCK ---
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.supervisor_account_rounded,
                              size: 44,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Create Admin Account",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Provision new system privileges securely",
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --- CARD CONTENT INPUT WRAPPER ---
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Username Input Field
                            TextField(
                              controller: nameController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: "Username",
                                errorText: nameError,
                                prefixIcon: const Icon(Icons.person_add_alt_1_outlined, size: 22),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Email Input Field
                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: "Email Address",
                                errorText: emailError,
                                prefixIcon: const Icon(Icons.email_outlined, size: 22),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Password Input Field
                            TextField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => addAdmin(),
                              decoration: InputDecoration(
                                labelText: "Password",
                                errorText: passwordError,
                                prefixIcon: const Icon(Icons.admin_panel_settings_outlined, size: 22),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- INTERACTIVE SYSTEM SUBMIT TRIGGER ---
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : addAdmin,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          "Register Admin Privileges",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}