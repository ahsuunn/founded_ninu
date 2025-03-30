import 'package:flutter/material.dart';

class EnumPicker<T> extends StatelessWidget {
  final String title;
  final T? selectedValue;
  final List<T> values;
  final Function(T) onSelected;

  const EnumPicker({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.values,
    required this.onSelected,
  });

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children:
              values
                  .map(
                    (value) => ListTile(
                      title: Text(value.toString().split('.').last),
                      onTap: () {
                        onSelected(value);
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        GestureDetector(
          onTap: () => _showPicker(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                selectedValue != null
                    ? selectedValue.toString().split('.').last
                    : "Select $title",
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
