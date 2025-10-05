import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6200EE);
  static const Color secondary = Color(0xFF03DAC5);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightPurple = Color(0xFFCFCDFD);
  static const Color pink = Color(0xFFFF68BF);
  static const Color black = Color(0xFF0E0D11);

  // Map Colors
  static const Color bluePurple = Color(0xFF5B5D9F);
  static const Color darkBlue = Color(0xFF232C4E);
  static const Color brightRed = Color(0xFFFF265A);

  static const ColorScheme colorScheme = ColorScheme(
    primary: Color(0xFF6200EE),
    primaryContainer: Color(0xFFB0B0FD),
    secondary: Color(0xFF03DAC5),
    secondaryContainer: Color(0xFFFF50A0),
    surface: Color(0xFFFFFFFF),
    error: Color(0xFFFF0000),
    onPrimary: Color(0xFF0E0D11),
    onSecondary: Color(0xFFFFFFFF),
    onSurface: Color(0xFF0E0D11),
    onError: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  );
}
