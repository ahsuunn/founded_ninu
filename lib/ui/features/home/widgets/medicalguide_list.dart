import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:google_fonts/google_fonts.dart';

class HorizontalList extends StatelessWidget {
  HorizontalList({super.key});

  final List<Map<String, String>> items = [
    {
      "image": "assets/fa.png", // Replace with your image URL
      "title": "Panduan Pertolongan Pertama",
    },
    {"image": "assets/fa1.png", "title": "Panduan Penanganan Utama"},
    {"image": "assets/fa.png", "title": "Item 3"},
    {"image": "assets/fa1.png", "title": "Item 4"},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Set height to fit the images and text
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scrolling
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  child: Image.asset(
                    items[index]["image"]!,
                    width: 220,
                    height: 120,
                    fit: BoxFit.cover, // Crop image to fit
                  ),
                ),
                const SizedBox(height: 5), // Space between image and text
                Text(
                  items[index]["title"]!,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
