import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/services/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SigninPage extends ConsumerWidget {
  SigninPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset("assets/logo.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "NINU",
                          style: TextStyle(
                            fontFamily: 'DinNextW1G',
                            fontSize: 82,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Login to your account",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  ElevatedButton(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
