import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/home/home_view.dart';
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
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme().copyWith(
          headlineLarge: GoogleFonts.lato(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colorScheme.tertiary,
          ),
        ),
        colorScheme: colorScheme,
      ),
      home: const HomePage(userName: 'Ahsan'),
    );
  }
}
