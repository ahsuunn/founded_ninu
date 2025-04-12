import 'package:flutter/material.dart';

class MapSkeleton extends StatelessWidget {
  const MapSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 175,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 120,
              height: 20,
              color: Colors.grey.shade400,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 50,
            child: Container(color: Colors.grey.shade200),
          ),
        ],
      ),
    );
  }
}
