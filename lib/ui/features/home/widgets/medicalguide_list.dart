import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Tambahkan ini
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:google_fonts/google_fonts.dart';

class HorizontalList extends StatelessWidget {
  HorizontalList({super.key});

  final List<Map<String, String>> items = [
    {
      "image": "assets/fa.png",
      "title": "CPR",
      "route": "/cprGuide", // Sesuaikan dengan path di router kamu
    },
    {
      "image": "assets/fa1.png",
      "title": "Bleeding",
      "route": "/bleedingGuide", // Sesuaikan juga
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () {
                context.push(items[index]["route"]!);
              },
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      items[index]["image"]!,
                      width: 220,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    items[index]["title"]!,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
