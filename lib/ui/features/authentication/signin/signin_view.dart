import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/services/auth_provider.dart';
import 'package:go_router/go_router.dart';

class SigninPage extends ConsumerWidget {
  SigninPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            bool success = await authService.signIn(
              "user@example.com",
              "password123",
            );

            if (success && context.mounted) {
              context.go('/home/Guest');
            }
          },
          child: Text("Sign In"),
        ),
      ),
    );
  }
}
