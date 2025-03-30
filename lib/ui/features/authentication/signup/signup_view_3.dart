import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/authentication/signup/state/birthdate_provider.dart';
import 'package:founded_ninu/ui/features/authentication/signup/state/provider.dart';
import 'package:founded_ninu/ui/features/authentication/signup/state/signup_provider.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/birthdate_picker.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/enum_picker.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/gender_picker.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/signup_textfield.dart';
import 'package:go_router/go_router.dart';

final formKeyProvider = Provider<GlobalKey<FormState>>(
  (ref) => GlobalKey<FormState>(),
);

enum Hospitals { X, Y, Z }

class ThirdSignupPage extends ConsumerStatefulWidget {
  const ThirdSignupPage({super.key});

  @override
  ConsumerState<ThirdSignupPage> createState() => _ThirdSignupPageState();
}

class _ThirdSignupPageState extends ConsumerState<ThirdSignupPage> {
  final _fullnameController = TextEditingController();
  final _nikController = TextEditingController();
  final _medicalHistoryController = TextEditingController();

  @override
  void dispose() {
    _fullnameController.dispose();
    _nikController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = ref.watch(formKeyProvider); // Get the form key
    final selectedHospital = ref.watch(hospitalProvider);
    final String? role = ref.watch(roleProvider);
    final username = ref.watch(signupProvider).username;
    bool submitForm() {
      if (formKey.currentState!.validate()) {
        return true;
      }
      return false;
    }

    final double textFieldWidth = MediaQuery.of(context).size.width * 0.75;

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
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  width: textFieldWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        (role == "Pasien")
                            ? "Biodata Pasien"
                            : "Biodata Petugas Medis",
                        style: TextStyle(fontSize: 24),
                      ),

                      SizedBox(width: 8),
                      Icon(
                        (role == "Pasien")
                            ? Icons.face
                            : Icons.medical_services_outlined,
                        size: 32,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                SignupTextfield(
                  label: "Nama Lengkap",
                  width: textFieldWidth,
                  hintText: "Masukkan nama lengkap anda",
                  controller: _fullnameController,
                  onChanged:
                      (value) => ref
                          .read(signupProvider.notifier)
                          .updateFullName(value),
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
                      GenderPicker(
                        onGenderSelected: (Gender gender) {
                          ref
                              .read(signupProvider.notifier)
                              .updateGender(gender.name);
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
                  controller: _nikController,
                  onChanged:
                      (value) =>
                          ref.read(signupProvider.notifier).updateKtp(value),
                ),
                (role == "Pasien")
                    ? SignupTextfield(
                      label: "Riwayat Penyakit",
                      width: textFieldWidth,
                      hintText: "Masukkan Riwayat Penyakit",
                      controller: _medicalHistoryController,
                      onChanged:
                          (value) => ref
                              .read(signupProvider.notifier)
                              .updateMedicalHistory(value),
                    )
                    : EnumPicker<Hospitals>(
                      title: "Hospital",
                      selectedValue: selectedHospital,
                      values: Hospitals.values,
                      onSelected: (Hospitals value) {
                        ref.read(hospitalProvider.notifier).state = value;
                      },
                    ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
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
                        if (submitForm()) {
                          String username = ref.watch(signupProvider).email;
                          String password = ref.watch(signupProvider).password;
                          print(username);
                          print(password);

                          final notifier = ref.read(signupProvider.notifier);
                          String? errorMessage = await notifier.signUp();

                          if (!context.mounted) return;
                          if (errorMessage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sign-up successful!')),
                            );
                            context.go("/home/$username"); // Navigate to home
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)),
                            );
                          }
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
      ),
    );
  }
}
