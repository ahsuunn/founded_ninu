import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/home/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ninu',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
        colorScheme: colorScheme,
      ),
      home: const MyHomePage(title: 'Ninu Home Page'),
    );
  }
}
