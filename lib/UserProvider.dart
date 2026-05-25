import 'package:flutter/material.dart';
import 'services/user_service.dart'; // Pointing explicitly to your updated AuthService
import 'models/user_model.dart';

class UserProvider extends InheritedWidget {
  final UserModel? user;
  final void Function(UserModel) setUser;
  final VoidCallback logout;

  const UserProvider({
    super.key,
    required this.user,
    required this.setUser,
    required this.logout,
    required super.child,
  });

  static UserProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<UserProvider>();
    assert(provider != null, "UserProvider not found in widget tree. Make sure to wrap MaterialApp in UserStore.");
    return provider!;
  }

  @override
  bool updateShouldNotify(UserProvider oldWidget) {
    return oldWidget.user != user;
  }
}

class UserStore extends StatefulWidget {
  final Widget child;
  const UserStore({super.key, required this.child});

  @override
  State<UserStore> createState() => _UserStoreState();
}

class _UserStoreState extends State<UserStore> {
  UserModel? user;

  void setUser(UserModel newUser) {
    setState(() {
      user = newUser;
    });
  }

  void logout() async {
    // CRITICAL UPDATE: Clears both jwt_token AND active_user_id cleanly from SharedPreferences
    await AuthService.clearSession();

    setState(() {
      user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserProvider(
      user: user,
      setUser: setUser,
      logout: logout,
      child: widget.child,
    );
  }
}