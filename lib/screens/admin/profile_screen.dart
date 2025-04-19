import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture or initial if no profile image
            CircleAvatar(
              radius: 50,
              backgroundImage: currentUser?.photoURL != null
                  ? NetworkImage(currentUser!.photoURL!)
                  : null,
              backgroundColor: Colors.blue,
              child: currentUser?.photoURL == null
                  ? Text(
                currentUser?.displayName?.substring(0, 1) ?? 'A',
                style: const TextStyle(fontSize: 40, color: Colors.white),
              )
                  : null,
            ),
            const SizedBox(height: 20),
            // Display name
            Text(
              'Name: ${currentUser?.displayName ?? 'Admin Name'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            // Email
            Text(
              'Email: ${currentUser?.email ?? 'admin@example.com'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Logout button
            ElevatedButton(
              onPressed: () async {
                // Confirm before logging out
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Log Out'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Log Out'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/adminLogin');
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
