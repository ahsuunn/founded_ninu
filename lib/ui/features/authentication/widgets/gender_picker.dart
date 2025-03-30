import 'package:flutter/material.dart';

enum Gender { laki, perempuan }

class GenderPicker extends StatefulWidget {
  const GenderPicker({super.key});

  @override
  State<GenderPicker> createState() => GenderPickerState();
}

class GenderPickerState extends State<GenderPicker> {
  Gender? _gender = Gender.laki;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Radio<Gender>(
              value: Gender.laki,
              groupValue: _gender,
              onChanged: (Gender? value) {
                setState(() {
                  _gender = value;
                });
              },
            ),
            Text('Laki-laki', style: TextStyle(fontSize: 16)),
          ],
        ),
        Row(
          children: [
            Radio<Gender>(
              value: Gender.perempuan,
              groupValue: _gender,
              onChanged: (Gender? value) {
                setState(() {
                  _gender = value;
                });
              },
            ),
            Text('Perempuan', style: TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }
}
