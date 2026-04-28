import 'package:flutter/material.dart';

class AdminMainScaffold extends StatefulWidget {
  final Widget body;
  final int currentIndex;

  const AdminMainScaffold({
    super.key,
    required this.body,
    this.currentIndex = 0,
  });

  @override
  State<AdminMainScaffold> createState() => _AdminMainScaffoldState();
}

class _AdminMainScaffoldState extends State<AdminMainScaffold> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _navigate(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/admin');
        break;

      case 1:
        Navigator.pushReplacementNamed(context, '/admin_orders');
        break;

      case 2:
        Navigator.pushReplacementNamed(context, '/admin_add');
        break;

      case 3:
        Navigator.pushReplacementNamed(context, '/admin_profile');
        break;
    }
  }

  void _openRoute(String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.redAccent,


        automaticallyImplyLeading: false,


        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),


      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.redAccent),
              child: Text(
                "Admin Menu",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () => _openRoute('/admin'),
            ),

            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text("Orders"),
              onTap: () => _openRoute('/admin_orders'),
            ),

            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text("Add Book"),
              onTap: () => _openRoute('/addBook'),
            ),

            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text("Add Admin"),
              onTap: () => _openRoute('/admin_add'),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () => _openRoute('/admin_profile'),
            ),
          ],
        ),
      ),

      body: widget.body,


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigate,
        selectedItemColor: Colors.redAccent,
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Admin",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}