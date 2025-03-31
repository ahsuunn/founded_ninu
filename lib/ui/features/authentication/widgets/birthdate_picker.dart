import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;
  final FormFieldSetter<DateTime>? onSaved;
  final FormFieldValidator<DateTime>? validator;

  const BirthDatePicker({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    this.onSaved,
    this.validator,
  });

  @override
  State<BirthDatePicker> createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000, 1, 1), // Default date
      firstDate: DateTime(1900), // Minimum birth year
      lastDate: DateTime.now(), // Prevent selecting future dates
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
      widget.onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: widget.validator,
      onSaved: widget.onSaved,
      builder: (FormFieldState<DateTime> state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _pickDate(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    border: Border.all(
                      color: state.hasError ? Colors.red : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    selectedDate != null
                        ? DateFormat('dd MMM yyyy').format(selectedDate!)
                        : "Select Birthdate",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
              if (state.hasError) // Show error message
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10),
                  child: Text(
                    state.errorText ?? '',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
