import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../utils/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isUpdating = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String _passwordStrength = "";
  String _passwordError = "";
  Color _strengthColor = Colors.black;
  String _strengthEmoji = "";

  String _getPasswordStrength(String password) {
    if (password.length < 8) {
      _setPasswordFeedback("Weak", Colors.red, "😞");
    } else if (RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>])').hasMatch(password)) {
      _setPasswordFeedback("Strong", Colors.green, "💪");
    } else {
      _setPasswordFeedback("Medium", Colors.orange, "😐");
    }
    return _passwordStrength;
  }

  void _setPasswordFeedback(String strength, Color color, String emoji) {
    setState(() {
      _passwordStrength = strength;
      _strengthColor = color;
      _strengthEmoji = emoji;
    });
  }

  bool _isPasswordValid(String password) {
    if (password.length < 8) {
      setState(() => _passwordError = "Password must be at least 8 characters.");
      return false;
    }
    setState(() => _passwordError = "");
    return true;
  }

  Future<void> _updatePassword() async {
    if (_isUpdating) return;
    setState(() => _isUpdating = true);

    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (!_isPasswordValid(newPassword)) {
      setState(() => _isUpdating = false);
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() => _isUpdating = false);
      _showSnackBar('Passwords do not match');
      return;
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: currentPassword,
      );
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.updatePassword(newPassword);
      _showSnackBar('Password updated successfully');
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    }

    setState(() => _isUpdating = false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Log Out')),
        ],
      ),
    );
    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      if (mounted) Navigator.pushReplacementNamed(context, '/adminLogin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(value),
            activeColor: Colors.white,
            inactiveThumbColor: Colors.blueAccent,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: themeProvider.isDarkMode
                ? [Colors.grey[900]!, Colors.black]
                : [Color(0xFFe0f7fa), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text(
                  'Welcome, ${currentUser?.displayName ?? 'Admin'}! 👋',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (currentUser != null && !currentUser!.emailVerified)
                  Text(
                    '⚠️ Email not verified',
                    style: TextStyle(color: Colors.red[400], fontSize: 14),
                  ),
                const SizedBox(height: 10),
                Text('Email: ${currentUser?.email ?? 'admin@example.com'}',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                TextField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _newPasswordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  onChanged: _getPasswordStrength,
                ),
                const SizedBox(height: 10),
                Text('$_strengthEmoji $_passwordStrength',
                    style: TextStyle(color: _strengthColor, fontWeight: FontWeight.bold)),
                if (_passwordError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(_passwordError,
                        style: const TextStyle(color: Colors.red, fontSize: 14)),
                  ),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon:
                      Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _isUpdating
                    ? const Center(child: CircularProgressIndicator())
                    : OutlinedButton(
                  onPressed: _updatePassword,
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                  child: const Text('Update Password', style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleLogout,
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
