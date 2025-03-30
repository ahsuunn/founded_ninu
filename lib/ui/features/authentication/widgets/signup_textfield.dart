import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';

class SignupTextfield extends StatelessWidget {
  final Function(String) onChanged;

  final String label;
  final String hintText;
  final double width;
  final TextEditingController controller;
  final bool isPassword;
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password tidak boleh kosong"; // "Password cannot be empty"
    }
    if (value.length < 8) {
      return "Minimal 8 karakter"; // "At least 8 characters"
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Harus mengandung huruf kapital (A-Z)"; // "Must contain an uppercase letter"
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Harus mengandung huruf kecil (a-z)"; // "Must contain a lowercase letter"
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return "Harus mengandung angka (0-9)"; // "Must contain a number"
    }
    return null; // ✅ Valid password
  }

  const SignupTextfield({
    super.key,
    required this.label,
    required this.width,
    required this.controller,
    this.hintText = '',
    this.isPassword = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: width,
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Tolong masukkan $label";
              }
              if (isPassword) {
                validatePassword(value);
              }
              return null;
            },
            onChanged: onChanged,
            controller: controller,
            obscureText: isPassword,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFD9D9D9),
              hintText: hintText,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0x80D9D9D9)),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.onTertiary),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
            ),
          ),
        ),
        isPassword
            ? Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                width: width,
                child: Text(
                  "Minimal 8 karakter termasuk kapital (A-Z),huruf kecil (a-z) dan angka (0-9)",
                  softWrap: true,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            )
            : SizedBox(),
        SizedBox(height: 10),
      ],
    );
  }
}
