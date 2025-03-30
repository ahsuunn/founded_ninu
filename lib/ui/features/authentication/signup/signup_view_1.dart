import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/authentication/signup/state/signup_provider.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/checkbox.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/phonenumber_textfield.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/rowlogo.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/signup_textfield.dart';
import 'package:go_router/go_router.dart';

class FirstSignupPage extends ConsumerWidget {
  const FirstSignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double textFieldWidth = MediaQuery.of(context).size.width * 0.75;
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
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
                      "Create your account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SignupTextfield(
                      label: "Username",
                      width: textFieldWidth,
                      hintText: "Masukkan username anda",
                      controller: usernameController,
                      onChanged:
                          (value) => ref
                              .read(signupProvider.notifier)
                              .updateUsername(value),
                    ),
                    SignupTextfield(
                      label: "Email",
                      width: textFieldWidth,
                      hintText: "Masukkan Email anda",
                      controller: emailController,
                      onChanged:
                          (value) => ref
                              .read(signupProvider.notifier)
                              .updateEmail(value),
                    ),
                    PhonenumberTextfield(
                      label: "No Telp",
                      width: textFieldWidth,
                      hintText: "8xxxxxxxxxx",
                      controller: phoneController,
                      onChanged:
                          (value) => ref
                              .read(signupProvider.notifier)
                              .updatePhone(value),
                    ),
                    SignupTextfield(
                      label: "Kata sandi",
                      isPassword: true,
                      width: textFieldWidth,
                      hintText: "Masukkan kata sandi",
                      controller: passwordController,
                      onChanged:
                          (value) => ref
                              .read(signupProvider.notifier)
                              .updatePhone(value),
                    ),
                    SignupTextfield(
                      label: "Konfirmasi ulang kata sandi",
                      isPassword: true,
                      width: textFieldWidth,
                      hintText: "Masukkan kata sandi",
                      controller: confirmPasswordController,
                      onChanged:
                          (value) => ref
                              .read(signupProvider.notifier)
                              .updatePhone(value),
                    ),
                    SizedBox(
                      width: textFieldWidth,
                      height: 50,
                      child: Row(
                        children: [
                          MyCheckbox(),
                          Expanded(
                            child: Text(
                              "Saya telah membaca dan menyetujui Ketentuan Umum dan Kebijakan Privasi",
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
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

                        onPressed: () {
                          // bool success = await authService.signIn(
                          //   emailController.text,
                          //   passwordController.text,
                          // );

                          if (context.mounted) {
                            context.goNamed('signup2');
                          }
                        },
                        child: Text(
                          "Buat Akun",
                          style: TextStyle(
                            color: colorScheme.tertiary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sudah punya akun? ",
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () => context.goNamed('signin'),
                          child: Text(
                            "Sign in",
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
