import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';

class MyCheckbox extends StatefulWidget {
  const MyCheckbox({super.key});

  @override
  State<MyCheckbox> createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: colorScheme.tertiary,
      fillColor: WidgetStateProperty.fromMap(<WidgetStatesConstraint, Color?>{
        WidgetState.error: Colors.red,
        WidgetState.hovered & WidgetState.focused: colorScheme.primary,
        WidgetState.focused: colorScheme.primary,
      }),

      side: WidgetStateBorderSide.fromMap(<WidgetStatesConstraint, BorderSide?>{
        WidgetState.selected: BorderSide(color: Colors.transparent, width: 2),
      }),
      value: isChecked,
      onChanged:
          (bool? value) => setState(() {
            isChecked = value!;
          }),
    );
  }
}
