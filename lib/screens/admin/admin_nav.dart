import 'package:flutter/material.dart';
import 'admin_home_screen.dart';
import 'manage_cars_screen.dart';
import 'manage_requests_screen.dart';

class AdminNavScreen extends StatefulWidget {
  const AdminNavScreen({super.key});

  @override
  State<AdminNavScreen> createState() => _AdminNavScreenState();
}

class _AdminNavScreenState extends State<AdminNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AdminHomeScreen(),
    const ManageCarsScreen(),
    const ManageRequestsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_filled_outlined),
              label: 'Cars',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Requests',
            ),
          ],
        ),
      ),
    );
  }
}
