import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Get current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 🔹 Sign up (Returns `true` on success, `false` on failure)
  Future<bool> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true; // Success
    } catch (e) {
      return false; // Failure
    }
  }

  // 🔹 Log in (Returns `true` on success, `false` on failure)
  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true; // Success
    } catch (e) {
      return false; // Failure
    }
  }

  // 🔹 Log out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
