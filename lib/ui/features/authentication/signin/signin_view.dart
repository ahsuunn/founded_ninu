import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/services/auth_provider.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/authentication/signin/widgets/LabeledTextField.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SigninPage extends ConsumerWidget {
  SigninPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double textFieldWidth = MediaQuery.of(context).size.width * 0.75;
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
                    "Sign in to your account",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 12),
                  LabeledTextField(
                    width: textFieldWidth,
                    label: "Email",
                    hintText: "Enter your email",
                    controller: emailController,
                  ),
                  const SizedBox(height: 12),
                  LabeledTextField(
                    width: textFieldWidth,
                    label: "Password",
                    hintText: "Enter your password",
                    controller: passwordController,
                    isPassword: true,
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: textFieldWidth,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: colorScheme.primary,
                      ),

                      onPressed: () async {
                        bool success = await authService.signIn(
                          emailController.text,
                          passwordController.text,
                        );

                        if (success && context.mounted) {
                          context.go('/home/Guest');
                        }
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: colorScheme.tertiary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun? ",
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () => context.goNamed('signup'),
                        child: Text(
                          "Daftar",
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
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
