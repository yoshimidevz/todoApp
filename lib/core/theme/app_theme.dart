import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    primaryColor: const Color.fromARGB(255, 31, 26, 134),
    scaffoldBackgroundColor: const Color.fromARGB(255, 43, 184, 177),
    colorScheme: ColorScheme.light(primary: const Color.fromARGB(255, 46, 133, 38)),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
    ),
  );
}