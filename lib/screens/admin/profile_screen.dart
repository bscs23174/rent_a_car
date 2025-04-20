import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isUpdating = false;
  bool _isDarkMode = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _passwordStrength = "";
  String _passwordError = "";
  Color _strengthColor = Colors.black;
  String _strengthEmoji = "";

  @override
  void initState() {
    super.initState();
  }

  // Toggle Dark Mode
  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
      // Here you can implement logic to persist theme preference (e.g., using SharedPreferences)
      if (_isDarkMode) {
        ThemeMode.dark;
      } else {
        ThemeMode.light;
      }
    });
  }

  // Password validation and strength feedback
  String _getPasswordStrength(String password) {
    if (password.length < 8) {
      setState(() {
        _strengthColor = Colors.red;
        _strengthEmoji = "😞";
        _passwordStrength = "Weak";
      });
    } else if (RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(password)) {
      setState(() {
        _strengthColor = Colors.green;
        _strengthEmoji = "💪";
        _passwordStrength = "Strong";
      });
    } else {
      setState(() {
        _strengthColor = Colors.orange;
        _strengthEmoji = "😐";
        _passwordStrength = "Medium";
      });
    }
    return _passwordStrength;
  }

  // Check for minimum password length
  bool _isPasswordValid(String password) {
    if (password.length < 8) {
      setState(() {
        _passwordError = "Password must be at least 8 characters.";
      });
      return false;
    }
    setState(() {
      _passwordError = "";
    });
    return true;
  }

  // Update Password
  Future<void> _updatePassword() async {
    if (_isUpdating) return; // Prevent multiple updates at once
    setState(() {
      _isUpdating = true;
    });

    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (!_isPasswordValid(newPassword)) {
      setState(() {
        _isUpdating = false;
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _isUpdating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      // Reauthenticate the user
      final AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: currentPassword,
      );

      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.updatePassword(newPassword);
      setState(() {
        _isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow for smooth blending
        actions: [
          // Dark Mode Toggle
          Switch(
            value: _isDarkMode,
            onChanged: _toggleTheme,
            activeColor: Colors.white,
            inactiveThumbColor: Colors.blueAccent,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFe0f7fa), Color(0xFFffffff)], // Consistent gradient
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView( // This ensures that the screen is scrollable when the keyboard opens
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
                // Nice welcome message
                Text(
                  'Welcome, ${currentUser?.displayName ?? 'Admin'}!👋',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Email
                Text(
                  'Email: ${currentUser?.email ?? 'admin@example.com'}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                // Current Password Field for Password Change
                TextField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // New Password Field
                TextField(
                  controller: _newPasswordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  onChanged: (password) {
                    setState(() {
                      _getPasswordStrength(password);
                    });
                  },
                ),
                const SizedBox(height: 10),
                // Password strength indicator
                Text(
                  '$_strengthEmoji $_passwordStrength',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _strengthColor,
                  ),
                ),
                const SizedBox(height: 10),
                // Show password error if password is too short
                Text(
                  _passwordError,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
                const SizedBox(height: 10),
                // Confirm New Password Field
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Update Password Button
                _isUpdating
                    ? const Center(child: CircularProgressIndicator())
                    : OutlinedButton(
                  onPressed: _updatePassword,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                  ),
                  child: const Text(
                    'Update Password',
                    style: TextStyle(color: Colors.red),
                  ),
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
        ),
      ),
    );
  }
}
