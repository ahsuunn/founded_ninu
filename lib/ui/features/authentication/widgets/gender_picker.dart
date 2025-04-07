import 'package:flutter/material.dart';

enum Gender { laki, perempuan }

class GenderPicker extends StatefulWidget {
  final Function(Gender) onGenderSelected;

  const GenderPicker({super.key, required this.onGenderSelected});

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
                if (value != null) {
                  setState(() {
                    _gender = value;
                  });
                  widget.onGenderSelected(value); // Send selected value
                }
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
                if (value != null) {
                  setState(() {
                    _gender = value;
                  });
                  widget.onGenderSelected(value); // Send selected value
                }
              },
            ),
            Text('Perempuan', style: TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }
}
