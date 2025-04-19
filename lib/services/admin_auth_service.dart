import 'package:firebase_auth/firebase_auth.dart';

class AdminAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Login failed: ${e.message}');
      throw Exception(e.message);  // Rethrow error for better error handling
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out failed: $e');
    }
  }

  User? get currentUser => _auth.currentUser;
}
