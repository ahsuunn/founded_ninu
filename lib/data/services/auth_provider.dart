import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:founded_ninu/data/services/auth_services.dart';

// 🔹 Provides an instance of AuthService
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// 🔹 Provides auth state (current user)
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});
