import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFFFF6B8F);
  static const Color secondary = Color(0xFF5B5D9F);

  // Background colors
  static const Color background = Color.fromARGB(54, 0, 0, 0);
  static const Color surfaceOverlay = Color.fromARGB(121, 59, 59, 59);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFD0FD);

  // Gradient colors
  static const List<Color> backgroundGradient = [
    Color.fromARGB(255, 63, 60, 60),
    Color.fromARGB(255, 32, 85, 150),
    Color.fromARGB(255, 91, 27, 83),
    Color.fromARGB(255, 180, 248, 32),
    Color.fromARGB(255, 32, 85, 150),
    Color.fromARGB(255, 91, 27, 83),
    Color.fromARGB(255, 243, 169, 169),
    Color.fromARGB(255, 32, 85, 150),
    Color.fromARGB(255, 246, 171, 236),
    Color.fromARGB(255, 43, 15, 15),
    Color.fromARGB(255, 255, 255, 255),
  ];

  // Custom color scheme
  static final ColorScheme colorScheme = ColorScheme(
    primary: const Color(0xFFFF6B8F),
    secondary: secondary,
    surface: surfaceOverlay,
    surfaceContainer: background,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: const Color(0xFFCFD0FD),
    onSurface: textPrimary,
    onError: Colors.white,
    brightness: Brightness.dark,
  );

  // Get gradient decoration
  static BoxDecoration get gradientDecoration => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: backgroundGradient,
        ),
      );
}
