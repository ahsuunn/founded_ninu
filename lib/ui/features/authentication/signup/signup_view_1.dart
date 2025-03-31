import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/authentication/signup/state/signup_provider.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/checkbox.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/phonenumber_textfield.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/rowlogo.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/signup_textfield.dart';
import 'package:go_router/go_router.dart';

final formKeyProvider = Provider<GlobalKey<FormState>>(
  (ref) => GlobalKey<FormState>(),
);

class FirstSignupPage extends ConsumerStatefulWidget {
  const FirstSignupPage({super.key});

  @override
  ConsumerState<FirstSignupPage> createState() => _FirstSignupPageState();
}

class _FirstSignupPageState extends ConsumerState<FirstSignupPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double textFieldWidth = MediaQuery.of(context).size.width * 0.75;
    final formKey = ref.watch(formKeyProvider); // Get the form key
    bool submitForm() {
      if (formKey.currentState!.validate()) {
        return true;
      }
      return false;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height:
              MediaQuery.of(context).size.height, // Takes full screen height

          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      controller: _usernameController,
                      onChanged:
                          (value) => ref
                              .read(signupProvider.notifier)
                              .updateUsername(value),
                    ),
                    SignupTextfield(
                      label: "Email",
                      width: textFieldWidth,
                      hintText: "Masukkan Email anda",
                      controller: _emailController,
                      onChanged:
                          (value) => ref
                              .read(signupProvider.notifier)
                              .updateEmail(value),
                    ),
                    PhonenumberTextfield(
                      label: "No Telp",
                      width: textFieldWidth,
                      hintText: "8xxxxxxxxxx",
                      controller: _phoneController,
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
                      controller: _passwordController,
                      onChanged:
                          (value) => ref
                              .read(signupProvider.notifier)
                              .updatePassword(value),
                    ),
                    SignupTextfield(
                      label: "Konfirmasi ulang kata sandi",
                      isPassword: true,
                      width: textFieldWidth,
                      hintText: "Masukkan kata sandi",
                      controller: _confirmPasswordController,
                      onChanged:
                          (value) => ref
                              .read(signupProvider.notifier)
                              .updatePassword(value),
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
                          if (context.mounted && submitForm()) {
                            context.pushNamed('signup2');
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
          ),
        ),
      ),
    );
  }
}
