import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/authentication/signup/state/birthdate_provider.dart';
import 'package:founded_ninu/ui/features/authentication/signup/state/role_provider.dart';
import 'package:founded_ninu/ui/features/authentication/signup/state/signup_provider.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/birthdate_picker.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/gender_picker.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/signup_textfield.dart';
import 'package:go_router/go_router.dart';

class ThirdSignupPage extends ConsumerWidget {
  const ThirdSignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double textFieldWidth = MediaQuery.of(context).size.width * 0.75;
    final String? role = ref.watch(roleProvider);
    DateTime? birthdate = ref.watch(birthdateProvider);

    final TextEditingController fullnameController = TextEditingController();
    final TextEditingController nikController = TextEditingController();
    final TextEditingController medicalhistoryController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Prevents Flutter from adding the default back button
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () => context.pop(), // Custom back button behavior
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: textFieldWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Biodata Pasien", style: TextStyle(fontSize: 24)),
                    SizedBox(width: 8),
                    Icon(Icons.face, size: 32),
                  ],
                ),
              ),
              SizedBox(height: 16),
              SignupTextfield(
                label: "Nama Lengkap",
                width: textFieldWidth,
                hintText: "Masukkan nama lengkap anda",
                controller: fullnameController,
                onChanged:
                    (value) =>
                        ref.read(signupProvider.notifier).updateFullName(value),
              ),
              SizedBox(
                width: textFieldWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, bottom: 4),
                      child: Text(
                        "Tanggal Lahir",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    BirthDatePicker(
                      onDateSelected: (DateTime date) {
                        ref.read(birthdateProvider.notifier).state = date;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              SignupTextfield(
                label: "No KTP",
                width: textFieldWidth,
                hintText: "Masukkan NIK",
                controller: nikController,
                onChanged:
                    (value) =>
                        ref.read(signupProvider.notifier).updateKtp(value),
              ),
              SignupTextfield(
                label: "Riwayat Penyakit",
                width: textFieldWidth,
                hintText: "Masukkan Riwayat Penyakit",
                controller: medicalhistoryController,
                onChanged:
                    (value) => ref
                        .read(signupProvider.notifier)
                        .updateMedicalHistory(value),
              ),

              SizedBox(
                width: textFieldWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, bottom: 4),
                      child: Text(
                        "Jenis Kelamin",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    GenderPicker(),
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
                  Text("Sudah punya akun? ", style: TextStyle(fontSize: 16)),
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
    );
  }
}
