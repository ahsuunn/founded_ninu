import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/services/auth_provider.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/LabeledTextField.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/rowlogo.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

final formKeyProvider = Provider<GlobalKey<FormState>>(
  (ref) => GlobalKey<FormState>(),
);

class SigninPage extends ConsumerWidget {
  SigninPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = ref.watch(formKeyProvider); // Get the form key
    bool submitForm() {
      if (formKey.currentState!.validate()) {
        return true;
      }
      return false;
    }

    final double textFieldWidth = MediaQuery.of(context).size.width * 0.75;
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Rowlogo(
                      logoHeight: 100,
                      logoWidth: 100,
                      fontSize: 82,
                      textTopPadding: 10,
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
                      hintText: "Masukkan email anda",
                      controller: emailController,
                    ),
                    const SizedBox(height: 12),
                    LabeledTextField(
                      width: textFieldWidth,
                      label: "Password",
                      hintText: "Masukkan kata sandi",
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
                          if (submitForm()) {
                            if (success && context.mounted) {
                              context.go('/home/Guest');
                            }
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
                          onTap: () => context.goNamed('signup1'),
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
            ),
          ],
        ),
      ),
    );
  }
}
