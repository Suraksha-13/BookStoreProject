import 'package:flutter/material.dart';
import '../UserProvider.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import './loginAppBar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool isLoading = false;

  bool validate() {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    bool valid = true;

    if (emailController.text.trim().isEmpty) {
      emailError = "Email is required";
      valid = false;
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError = "Password is required";
      valid = false;
    }

    return valid;
  }

  void login() async {
    if (!validate()) return;

    setState(() {
      isLoading = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final response = await AuthService.login(email, password);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (response["success"] == true && response.containsKey("user")) {
      try {
        final userProvider = UserProvider.of(context);

        // This parsing operation is now safe against null values
        UserModel loggedInUser = UserModel.fromJson(response["user"]);

        userProvider.setUser(loggedInUser);

        if (loggedInUser.role == "admin") {
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        // Catch block helps pinpoint data shape problems during local dev
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Data parsing error: $e"),
            backgroundColor: Colors.orangeAccent,
          ),
        );
      }
    } else {
      final errorMsg = response["message"] ?? "Invalid credentials";
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Email",
                      errorText: emailError,
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => login(),
                    decoration: InputDecoration(
                      labelText: "Password",
                      errorText: passwordError,
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.blueAccent,
                        ),
                      )
                          : const Text(
                        "Login",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text("Don't have an account? Signup"),
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