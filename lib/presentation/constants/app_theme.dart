import 'package:flutter/material.dart';

/// App Theme Constants based on Figma Design
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ==================== COLOR PALETTE ====================

  /// Primary Colors
  static const Color primaryPink = Color(0xFFFF6B8F);
  static const Color primaryPinkDark = Color(0xFFFF265A);
  static const Color primaryPinkLight = Color(0xFFD08A96);

  /// Secondary Colors
  static const Color secondaryBlue = Color(0xFF4B4685);
  static const Color secondaryPurple = Color(0xFF5B5D9F);
  static const Color secondaryNavy = Color(0xFF222C4D);

  /// Neutral Colors
  static const Color neutralWhite = Color(0xFFFFFFFF);
  static const Color neutralLightGray = Color(0xFFCFD0FD);
  static const Color neutralGray = Color(0xFFCED0FC);
  static const Color neutralDarkGray = Color(0xFF18181F);
  static const Color neutralBlack = Color(0xFF0E0D11);
  static const Color neutralText = Color(0xFF1D1D34);

  /// Accent Colors
  static const Color accentRed = Color(0xFFAD0742);
  static const Color accentGreen = Color(0xFF1B3719);
  static const Color accentBrown = Color(0xFF684D3F);

  /// Status Colors
  static const Color successGreen = Color(0xFF1B3719);
  static const Color warningOrange = Color(0xFF684D3F);
  static const Color errorRed = Color(0xFFFF265A);

  /// Transparent Colors
  static const Color transparentWhite = Color(0x20FFFFFF);
  static const Color transparentBlack = Color(0x00000000);
  static const Color semiTransparentBlack = Color(0xCC09090B);
  static const Color semiTransparentWhite = Color(0x7F0E0D11);

  // ==================== TYPOGRAPHY ====================

  /// Font Family
  static const String fontFamily = 'Josefin Sans';

  /// Typography Scale (Mathematical Scale 1.250)
  static const double baseFontSize = 18.0;

  /// Display Text Styles
  static const TextStyle displayH1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 107.0,
    fontWeight: FontWeight.w500,
    height: 1.21,
    color: neutralText,
  );

  static const TextStyle displayH2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 86.0,
    fontWeight: FontWeight.w500,
    color: neutralText,
  );

  static const TextStyle displayH3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 69.0,
    fontWeight: FontWeight.w500,
    color: neutralText,
  );

  static const TextStyle displayH4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 55.0,
    fontWeight: FontWeight.w500,
    color: neutralText,
  );

  static const TextStyle displayH5 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 44.0,
    fontWeight: FontWeight.w500,
    color: neutralText,
  );

  /// Headline Text Styles
  static const TextStyle headlineH6 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 35.0,
    fontWeight: FontWeight.w400,
    color: neutralText,
  );

  static const TextStyle headlineH7 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28.0,
    fontWeight: FontWeight.w400,
    color: neutralText,
  );

  /// Body Text Styles
  static const TextStyle bodyH8 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 23.0,
    fontWeight: FontWeight.w400,
    height: 1.30,
    color: neutralText,
  );

  static const TextStyle bodyH9 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    height: 1.67,
    color: neutralText,
  );

  static const TextStyle bodyH10 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.79,
    color: neutralText,
  );

  /// Special Text Styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 90.0,
    fontWeight: FontWeight.w400,
    color: neutralWhite,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 50.0,
    fontWeight: FontWeight.w600,
    color: primaryPink,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22.0,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.66,
    color: neutralWhite,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: neutralLightGray,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    color: neutralGray,
  );

  // ==================== SPACING SYSTEM ====================

  /// Base spacing unit (8px)
  static const double spacingUnit = 8.0;

  /// Spacing values
  static const double spacingXS = spacingUnit * 0.5;    // 4px
  static const double spacingS = spacingUnit;            // 8px
  static const double spacingM = spacingUnit * 1.5;      // 12px
  static const double spacingL = spacingUnit * 2;        // 16px
  static const double spacingXL = spacingUnit * 3;       // 24px
  static const double spacingXXL = spacingUnit * 4;      // 32px
  static const double spacingXXXL = spacingUnit * 6;     // 48px
  static const double spacingHuge = spacingUnit * 9;     // 72px
  static const double spacingMassive = spacingUnit * 12; // 96px

  // ==================== BORDER RADIUS ====================

  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 40.0;
  static const double radiusCircular = 50.0;

  // ==================== SHADOWS ====================

  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Color(0xFF000000),
      blurRadius: 0,
      offset: Offset(4, 4),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0xFF000000),
      blurRadius: 0,
      offset: Offset(8, 8),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0xFF000000),
      blurRadius: 0,
      offset: Offset(16, 16),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowText = [
    Shadow(
      offset: Offset(0, 4),
      blurRadius: 4,
      color: Color(0x40000000),
    ),
  ];

  // ==================== GRADIENTS ====================

  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment(0.50, 0.23),
    end: Alignment(0.50, 1.08),
    colors: [
      Color(0x0009090B),
      Color(0x0009090B),
      Color(0xCC09090B),
    ],
  );

  static const LinearGradient gradientBackground = LinearGradient(
    begin: Alignment(0.50, -0.00),
    end: Alignment(0.50, 1.00),
    colors: [
      Color(0x00000000),
      Color(0xB3000000),
      Color(0xFF0E0D11),
    ],
  );

  static const LinearGradient gradientCard = LinearGradient(
    begin: Alignment(0.50, 0.42),
    end: Alignment(0.50, 1.07),
    colors: [
      Color(0x00000000),
      Color(0xFF000000),
    ],
  );

  // ==================== COMPONENT THEMES ====================

  /// Card Theme
  static final CardTheme cardTheme = CardTheme(
    color: neutralBlack,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusXL),
      side: const BorderSide(
        color: transparentWhite,
        width: 0.5,
      ),
    ),
  );

  /// Button Theme
  static final ButtonThemeData buttonTheme = ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusM),
    ),
    buttonColor: primaryPink,
    textTheme: ButtonTextTheme.primary,
  );

  /// Input Decoration Theme
  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusXL),
      borderSide: const BorderSide(
        color: transparentWhite,
        width: 0.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusXL),
      borderSide: const BorderSide(
        color: transparentWhite,
        width: 0.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusXL),
      borderSide: const BorderSide(
        color: primaryPink,
        width: 1.0,
      ),
    ),
    filled: true,
    fillColor: neutralBlack,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: spacingXL,
      vertical: spacingXL,
    ),
  );

  /// App Bar Theme
  static final AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: neutralBlack,
    foregroundColor: neutralWhite,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: titleSmall,
  );

  /// Bottom Navigation Bar Theme
  static final BottomNavigationBarThemeData bottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    backgroundColor: neutralBlack,
    selectedItemColor: primaryPink,
    unselectedItemColor: neutralLightGray,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  );

  // ==================== MAIN THEME DATA ====================

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    primaryColor: primaryPink,
    scaffoldBackgroundColor: neutralWhite,
    cardTheme: cardTheme,
    buttonTheme: buttonTheme,
    inputDecorationTheme: inputDecorationTheme,
    appBarTheme: appBarTheme,
    bottomNavigationBarTheme: bottomNavigationBarTheme,
    colorScheme: const ColorScheme.light(
      primary: primaryPink,
      secondary: secondaryBlue,
      surface: neutralWhite,
      background: neutralWhite,
      error: errorRed,
      onPrimary: neutralWhite,
      onSecondary: neutralWhite,
      onSurface: neutralText,
      onBackground: neutralText,
      onError: neutralWhite,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    primaryColor: primaryPink,
    scaffoldBackgroundColor: neutralBlack,
    cardTheme: cardTheme,
    buttonTheme: buttonTheme,
    inputDecorationTheme: inputDecorationTheme,
    appBarTheme: appBarTheme,
    bottomNavigationBarTheme: bottomNavigationBarTheme,
    colorScheme: const ColorScheme.dark(
      primary: primaryPink,
      secondary: secondaryBlue,
      surface: neutralBlack,
      background: neutralBlack,
      error: errorRed,
      onPrimary: neutralWhite,
      onSecondary: neutralWhite,
      onSurface: neutralWhite,
      onBackground: neutralWhite,
      onError: neutralWhite,
    ),
  );
}