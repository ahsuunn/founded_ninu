import 'package:flutter/material.dart';

class VideocallContainer extends StatelessWidget {
  const VideocallContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 175,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset('assets/assistance.png', fit: BoxFit.cover),
      ),
    );
  }
}
