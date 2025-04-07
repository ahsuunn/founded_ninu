import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';

class PhonenumberTextfield extends StatelessWidget {
  final Function(String) onChanged;
  final String label;
  final String hintText;
  final double width;
  final TextEditingController controller;
  final bool isPassword;

  const PhonenumberTextfield({
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
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Tolong masukkan $label";
                    }
                    return null;
                  },
                  onChanged: onChanged,
                  controller: controller,
                  obscureText: isPassword,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFD9D9D9),
                    hintText: hintText,
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0x80D9D9D9)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.onTertiary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10),
      ],
    );
  }
}
