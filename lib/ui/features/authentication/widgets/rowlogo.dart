import 'package:flutter/material.dart';

class Rowlogo extends StatelessWidget {
  final double logoWidth;
  final double logoHeight;
  final double fontSize;
  final double textTopPadding;

  const Rowlogo({
    super.key,
    required this.logoHeight,
    required this.logoWidth,
    required this.fontSize,
    required this.textTopPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: logoWidth,
          height: logoHeight,
          child: Image.asset("assets/logo.png"),
        ),
        Padding(
          padding: EdgeInsets.only(top: textTopPadding),
          child: Text(
            "NINU",
            style: TextStyle(
              fontFamily: 'DinNextW1G',
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
