import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;

  const BirthDatePicker({
    super.key,
    this.initialDate,
    required this.onDateSelected,
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
      widget.onDateSelected(pickedDate); // Pass the selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          selectedDate != null
              ? DateFormat('dd MMM yyyy').format(selectedDate!)
              : "Select Birthdate",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}
