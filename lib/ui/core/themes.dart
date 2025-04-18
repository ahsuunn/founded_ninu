import 'package:flutter/material.dart';

final ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.light, // Required: Defines light/dark mode
  primary: Color(0xFFAF3231),
  onPrimary: Colors.white, // Text/icons on primary color
  secondary: Color(0x80FDAB33),
  onSecondary: Colors.black,
  tertiary: Color(0xFFF4F2E3),
  onTertiary: Colors.black,
  error: Colors.redAccent,
  onError: Colors.white,
  surface: Color(0xFFF4F2E3),
  onSurface: Colors.black,
);
