import 'package:flutter/material.dart';
import 'package:nursecycle/core/colorconfig.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    // inputDecorationTheme: InputDecorationTheme(
    //   filled: true,
    //   // fillColor: const Color.fromARGB(255, 255, 255, 255),
    //   border: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(12),
    //     borderSide: BorderSide.none,
    //   ),
    //   hintStyle: TextStyle(color: Colors.grey),
    //   labelStyle: const TextStyle(color: Colors.grey),
    // ),
  );
}
