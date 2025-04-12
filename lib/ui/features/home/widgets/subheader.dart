import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';

class SubHeader extends StatelessWidget {
  final String title;
  final Icon icon;

  const SubHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8), // Padding around the icon
          decoration: BoxDecoration(
            color: colorScheme.secondary, // Background color of the box
            shape: BoxShape.circle, // Makes it a circle
          ),
          child: icon,
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: colorScheme.tertiary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ],
    );
  }
}
