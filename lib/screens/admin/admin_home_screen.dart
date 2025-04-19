import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _DashboardTile(
        icon: Icons.directions_car,
        label: 'Manage Cars',
        onTap: () => Navigator.pushNamed(context, '/manageCars'),
      ),
      _DashboardTile(
        icon: Icons.receipt_long,
        label: 'Manage Requests',
        onTap: () => Navigator.pushNamed(context, '/manageRequests'),
      ),
      _DashboardTile(
        icon: Icons.person,
        label: 'Profile',
        onTap: () => Navigator.pushNamed(context, '/profile'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: GridView.count(
            crossAxisCount: 1, // Use 2 if you want two tiles side by side
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 2.8,
            shrinkWrap: true,
            children: tiles,
          ),
        ),
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: Colors.indigo.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Icon(icon, size: 36, color: Colors.indigo),
              const SizedBox(width: 20),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
