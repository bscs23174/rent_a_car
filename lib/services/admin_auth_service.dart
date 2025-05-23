import 'package:firebase_auth/firebase_auth.dart';

class AdminAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Signs in using email and password.
  /// Returns [User] on success or throws [Exception] with error message.
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Log and rethrow Firebase-specific auth error
      print('[AdminAuthService] Login failed: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      // Catch any other unforeseen errors
      print('[AdminAuthService] Unexpected error during sign-in: $e');
      throw Exception('Unexpected error occurred');
    }
  }

  /// Signs out the currently logged-in user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('[AdminAuthService] Sign out failed: $e');
    }
  }

  /// Returns the currently signed-in user or null.
  User? get currentUser => _auth.currentUser;
}
