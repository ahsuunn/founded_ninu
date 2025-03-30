import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/routing.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme().copyWith(
          headlineLarge: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colorScheme.tertiary,
          ),
        ),
        colorScheme: colorScheme,
      ),
      routerConfig: router,
    );
  }
}
