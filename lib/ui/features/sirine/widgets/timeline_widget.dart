import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';

class TimelineWidget extends StatelessWidget {
  final String fromLocation;
  final String toLocation;
  final String fromTime;
  final String toTime;

  const TimelineWidget({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.fromTime,
    required this.toTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Dots and Line
          Column(
            children: [
              SizedBox(height: 8),
              Icon(Icons.circle, size: 12, color: Colors.white),
              Container(width: 2, height: 42, color: Colors.white),
              Icon(Icons.circle, size: 12, color: Colors.white),
            ],
          ),
          const SizedBox(width: 12),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "From $fromLocation",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  fromTime,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  "To $toLocation",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  toTime,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
