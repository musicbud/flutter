import 'package:flutter/material.dart';

class AppTheme {
  static AppTheme? _instance;

  static AppTheme of(BuildContext context) {
    _instance ??= AppTheme._();
    return _instance!;
  }

  AppTheme._();

  // Font Families
  static const String fontFamilyPrimary = 'Cairo';
  static const String fontFamilySecondary = 'Josefin Sans';
  static const String fontFamilyArabic = 'Almarai';

  // Enhanced Color Palette from Figma Design
  static const Color primaryRed = Color(0xFFFE2C54);
  static const Color secondaryRed = Color(0xFFFF2D55);
  static const Color darkTone = Color(0xFF0F0E12);
  static const Color lightGray = Color(0xFFCCCCCC);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);

  // Additional colors from UI design
  static const Color cardBackground = Color(0xFF1A1A1A);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF2A2A2A);
  static const Color accentBlue = Color(0xFF4A90E2);
  static const Color accentPurple = Color(0xFF9B59B6);
  static const Color accentGreen = Color(0xFF2ECC71);
  static const Color accentOrange = Color(0xFFE67E22);
  static const Color textMuted = Color(0xFF8E8E93);
  static const Color borderColor = Color(0xFF3A3A3A);
  static const Color overlayColor = Color(0x80000000);

  // Color Palette
  static const Color primary = primaryRed;
  static const Color secondary = secondaryRed;
  static const Color accent = secondaryRed;
  static const Color background = darkTone;
  static const Color surface = darkTone;
  static const Color white = pureWhite;
  static const Color black = darkTone;
  static const Color error = primaryRed;
  static const Color warning = Color(0xFFFFA500);
  static const Color success = Color(0xFF4CAF50);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors (0-900 scale)
  static const Map<int, Color> neutral = {
    50: Color(0xFFFAFAFA),
    100: Color(0xFFF5F5F5),
    200: Color(0xFFEEEEEE),
    300: Color(0xFFE0E0E0),
    400: Color(0xFFBDBDBD),
    500: lightGray,
    600: Color(0xFF757575),
    700: Color(0xFF616161),
    800: Color(0xFF424242),
    900: darkTone,
  };

  // Enhanced Typography with better hierarchy
  static const TextStyle displayH1 = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 60,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.40,
    color: primaryRed,
  );

  static const TextStyle displayH2 = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.0,
    color: primaryRed,
  );

  static const TextStyle displayH3 = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.6,
    color: primaryRed,
  );

  static const TextStyle headlineH4 = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.50,
    color: lightGray,
  );

  static const TextStyle headlineH5 = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.40,
    color: lightGray,
  );

  static const TextStyle headlineH6 = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: white,
  );

  static const TextStyle headlineH7 = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.30,
    color: white,
  );

  static const TextStyle bodyH8 = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: white,
  );

  static const TextStyle bodyH9 = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.40,
    color: white,
  );

  static const TextStyle bodyH10 = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: lightGray,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.30,
    color: white,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: white,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.40,
    color: white,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: lightGray,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.60,
    color: lightGray,
  );

  // Special Typography for Arabic Text
  static const TextStyle arabicText = TextStyle(
    fontFamily: fontFamilyArabic,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: white,
  );

  // Enhanced Spacing System (8px base unit)
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  static const double spacingXXXL = 64.0;
  static const double spacingHuge = 96.0;

  // Enhanced Border Radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 16.0;
  static const double radiusL = 24.0;
  static const double radiusXL = 31.0; // From Figma design
  static const double radiusXXL = 40.0;
  static const double radiusCircular = 50.0;

  // Enhanced Shadows with better depth
  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0x4D000000),
      offset: Offset(0, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowText = [
    BoxShadow(
      color: Color(0x80000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  // Enhanced card shadows
  static const List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowCardHover = [
    BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  // Enhanced Gradients from UI design
  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment(0.50, -0.00),
    end: Alignment(0.50, 1.00),
    colors: [transparent, secondaryRed],
  );

  static const LinearGradient gradientSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, secondaryRed],
  );

  static const LinearGradient gradientBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkTone, Color(0xFF1A1A1A)],
  );

  // New gradients from UI design
  static const LinearGradient gradientCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardBackground, surfaceDark],
  );

  static const LinearGradient gradientOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [transparent, overlayColor],
  );

  static const LinearGradient gradientAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentBlue, accentPurple],
  );

  // Instance-based getters for components
  AppColors get colors => AppColors();
  AppTypography get typography => AppTypography();
  AppSpacing get spacing => AppSpacing();
  AppRadius get radius => AppRadius();
  AppShadows get shadows => AppShadows();
  AppGradients get gradients => AppGradients();

  // Enhanced Component Themes
  CardTheme get cardTheme => CardTheme(
    color: cardBackground,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusXL),
    ),
    margin: const EdgeInsets.all(spacingM),
    shadowColor: Colors.black,
  );

  ButtonThemeData get buttonTheme => ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusM),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingL,
      vertical: spacingM,
    ),
  );

  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusM),
      borderSide: const BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusM),
      borderSide: const BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusM),
      borderSide: const BorderSide(color: primaryRed, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusM),
      borderSide: const BorderSide(color: error),
    ),
    filled: true,
    fillColor: surfaceDark,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: spacingM,
      vertical: spacingM,
    ),
  );

  AppBarTheme get appBarTheme => AppBarTheme(
    backgroundColor: surface,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: headlineH6.copyWith(
      color: white,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: const IconThemeData(color: white),
  );

  BottomNavigationBarThemeData get bottomNavigationBarTheme => const BottomNavigationBarThemeData(
    backgroundColor: surface,
    selectedItemColor: primaryRed,
    unselectedItemColor: lightGray,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  );

  // Theme Data
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamilySecondary,
    primaryColor: primaryRed,
    scaffoldBackgroundColor: white,
    cardTheme: CardThemeData(
      color: cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusXL),
      ),
      margin: const EdgeInsets.all(spacingM),
      shadowColor: Colors.black,
    ),
    buttonTheme: buttonTheme,
    inputDecorationTheme: inputDecorationTheme,
    appBarTheme: appBarTheme.copyWith(
      backgroundColor: white,
      titleTextStyle: headlineH6.copyWith(color: darkTone),
      iconTheme: const IconThemeData(color: darkTone),
    ),
    bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
      backgroundColor: white,
      selectedItemColor: primaryRed,
      unselectedItemColor: neutral[600]!,
    ),
  );

  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamilySecondary,
    primaryColor: primaryRed,
    scaffoldBackgroundColor: darkTone,
    cardTheme: CardThemeData(
      color: cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusXL),
      ),
      margin: const EdgeInsets.all(spacingM),
      shadowColor: Colors.black,
    ),
    buttonTheme: buttonTheme,
    inputDecorationTheme: inputDecorationTheme,
    appBarTheme: appBarTheme,
    bottomNavigationBarTheme: bottomNavigationBarTheme,
  );
}

// Enhanced Helper classes for instance-based access
class AppColors {
  Color get primaryRed => AppTheme.primaryRed;
  Color get secondaryRed => AppTheme.secondaryRed;
  Color get darkTone => AppTheme.darkTone;
  Color get lightGray => AppTheme.lightGray;
  Color get white => AppTheme.white;
  Color get pureWhite => AppTheme.pureWhite;
  Color get black => AppTheme.black;
  Color get transparent => AppTheme.transparent;
  Color get primary => AppTheme.primary;
  Color get secondary => AppTheme.secondary;
  Color get accent => AppTheme.accent;
  Color get background => AppTheme.background;
  Color get surface => AppTheme.surface;
  Color get error => AppTheme.error;
  Color get warning => AppTheme.warning;
  Color get success => AppTheme.success;
  Color get info => AppTheme.info;
  Map<int, Color> get neutral => AppTheme.neutral;

  // Enhanced colors from UI design
  Color get textPrimary => AppTheme.white;
  Color get textSecondary => AppTheme.lightGray;
  Color get textMuted => AppTheme.textMuted;
  Color get neutralGray => AppTheme.lightGray;
  Color get infoBlue => AppTheme.info;
  Color get successGreen => AppTheme.success;
  Color get errorRed => AppTheme.error;
  Color get cardBackground => AppTheme.cardBackground;
  Color get surfaceDark => AppTheme.surfaceDark;
  Color get surfaceLight => AppTheme.surfaceLight;
  Color get accentBlue => AppTheme.accentBlue;
  Color get accentPurple => AppTheme.accentPurple;
  Color get accentGreen => AppTheme.accentGreen;
  Color get accentOrange => AppTheme.accentOrange;
  Color get borderColor => AppTheme.borderColor;
  Color get overlayColor => AppTheme.overlayColor;
}

class AppTypography {
  TextStyle get displayH1 => AppTheme.displayH1;
  TextStyle get displayH2 => AppTheme.displayH2;
  TextStyle get displayH3 => AppTheme.displayH3;
  TextStyle get headlineH4 => AppTheme.headlineH4;
  TextStyle get headlineH5 => AppTheme.headlineH5;
  TextStyle get headlineH6 => AppTheme.headlineH6;
  TextStyle get headlineH7 => AppTheme.headlineH7;
  TextStyle get bodyH8 => AppTheme.bodyH8;
  TextStyle get bodyH9 => AppTheme.bodyH9;
  TextStyle get bodyH10 => AppTheme.bodyH10;
  TextStyle get bodyMedium => AppTheme.bodyH9; // Alias for bodyH9
  TextStyle get titleLarge => AppTheme.titleLarge;
  TextStyle get titleMedium => AppTheme.titleMedium;
  TextStyle get titleSmall => AppTheme.titleSmall;
  TextStyle get caption => AppTheme.caption;
  TextStyle get overline => AppTheme.overline;
  TextStyle get arabicText => AppTheme.arabicText;
  String get fontFamilyPrimary => AppTheme.fontFamilyPrimary;
  String get fontFamilySecondary => AppTheme.fontFamilySecondary;
  String get fontFamilyArabic => AppTheme.fontFamilyArabic;

  // Additional typography for pages
  TextStyle get bodySmall => AppTheme.bodyH10;
}

class AppSpacing {
  double get xs => AppTheme.spacingXS;
  double get sm => AppTheme.spacingS;
  double get md => AppTheme.spacingM;
  double get lg => AppTheme.spacingL;
  double get xl => AppTheme.spacingXL;
  double get xxl => AppTheme.spacingXXL;
  double get xxxl => AppTheme.spacingXXXL;
  double get huge => AppTheme.spacingHuge;

  // Padding aliases
  double get paddingMedium => AppTheme.spacingM;
}

class AppRadius {
  double get xs => AppTheme.radiusXS;
  double get sm => AppTheme.radiusS;
  double get md => AppTheme.radiusM;
  double get lg => AppTheme.radiusL;
  double get xl => AppTheme.radiusXL;
  double get xxl => AppTheme.radiusXXL;
  double get circular => AppTheme.radiusCircular;
}

class AppShadows {
  List<BoxShadow> get shadowSmall => AppTheme.shadowSmall;
  List<BoxShadow> get shadowMedium => AppTheme.shadowMedium;
  List<BoxShadow> get shadowLarge => AppTheme.shadowLarge;
  List<BoxShadow> get shadowText => AppTheme.shadowText;
  List<BoxShadow> get shadowCard => AppTheme.shadowCard;
  List<BoxShadow> get shadowCardHover => AppTheme.shadowCardHover;
}

class AppGradients {
  LinearGradient get primaryGradient => AppTheme.gradientPrimary;
  LinearGradient get secondaryGradient => AppTheme.gradientSecondary;
  LinearGradient get backgroundGradient => AppTheme.gradientBackground;
  LinearGradient get cardGradient => AppTheme.gradientCard;
  LinearGradient get overlayGradient => AppTheme.gradientOverlay;
  LinearGradient get accentGradient => AppTheme.gradientAccent;
}