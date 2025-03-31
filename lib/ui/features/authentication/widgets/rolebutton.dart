import 'package:flutter/material.dart';

class Rolebutton extends StatelessWidget {
  final double width;
  final Icon icon;
  final String title;
  final Function()? onPressed;

  const Rolebutton({
    super.key,
    required this.width,
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 60,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateColor.fromMap(
            <WidgetStatesConstraint, Color>{WidgetState.any: Colors.white},
          ),
          side: WidgetStatePropertyAll(
            BorderSide(width: 2, color: Colors.transparent),
          ),

          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            icon,
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                title,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
