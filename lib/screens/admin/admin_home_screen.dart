import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTile(
              icon: Icons.directions_car,
              label: 'Manage Cars',
              onTap: () {
                Navigator.pushNamed(context, '/manageCars');
              },
            ),
            const SizedBox(height: 16),
            _buildTile(
              icon: Icons.receipt_long,
              label: 'Manage Requests',
              onTap: () {
                Navigator.pushNamed(context, '/manageRequests');
              },
            ),
            const SizedBox(height: 16),
            _buildTile(
              icon: Icons.person,
              label: 'Profile',
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.indigo.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.indigo),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
