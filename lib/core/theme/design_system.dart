import 'package:flutter/material.dart';

/// Unified Design System for MusicBud
///
/// This is the single source of truth for all design tokens including:
/// - Semantic color tokens (primary, surface, onSurface, etc.)
/// - Typography scale with consistent font sizes and weights
/// - Spacing and radius tokens
/// - Theme-aware color selection for light/dark modes
/// - Component-specific theme extensions
class DesignSystem {
  // Private constructor to prevent instantiation
  DesignSystem._();

  // ===========================================================================
  // SEMANTIC COLOR TOKENS
  // ===========================================================================

  /// Primary brand colors (Pink/Red accent from Figma)
  static const Color primary = Color(0xFFFE2C54);  // Bright pink for primary actions
  static const Color primaryContainer = Color(0xFFFF6B8F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryVariant = Color(0xFFFF2D55);
  
  /// Pink shades for UI elements
  static const Color pinkAccent = Color(0xFFFE2C54);
  static const Color pinkLight = Color(0xFFFF6B8F);
  static const Color pinkDark = Color(0xFFE02548);

  /// Secondary colors
  static const Color secondary = Color(0xFF1DB954);
  static const Color secondaryContainer = Color(0xFF1ED760);
  static const Color onSecondary = Color(0xFFFFFFFF);

  /// Surface colors (Dark theme from Figma)
  static const Color surface = Color(0xFF0A0A0A);  // Very dark background
  static const Color surfaceContainer = Color(0xFF1A1A1A);  // Card/container background
  static const Color surfaceContainerHigh = Color(0xFF252525);  // Elevated containers
  static const Color surfaceContainerHighest = Color(0xFF303030);  // Highest elevation
  static const Color onSurface = Color(0xFFFFFFFF);  // White text
  static const Color onSurfaceVariant = Color(0xFFB3B3B3);  // Gray text
  static const Color onSurfaceDim = Color(0xFF808080);  // Dimmer text

  /// Background colors
  static const Color background = Color(0xFF0A0A0A);  // Main dark background
  static const Color backgroundDark = Color(0xFF000000);  // Pure black
  static const Color onBackground = Color(0xFFFFFFFF);

  /// Error colors
  static const Color error = Color(0xFFCF6679);
  static const Color errorRed = Color(0xFFE53935);  // Bright red for errors
  static const Color errorContainer = Color(0xFFFF0000);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFFFFFFFF);

  /// Success colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successGreen = Color(0xFF4CAF50);  // Alias for success
  static const Color successContainer = Color(0xFF66BB6A);
  static const Color onSuccess = Color(0xFFFFFFFF);

  /// Warning colors
  static const Color warning = Color(0xFFFFA500);
  static const Color warningOrange = Color(0xFFFFA500);  // Alias for warning
  static const Color warningContainer = Color(0xFFFFB74D);
  static const Color onWarning = Color(0xFFFFFFFF);

  /// Info colors
  static const Color info = Color(0xFF2196F3);
  static const Color infoContainer = Color(0xFF64B5F6);
  static const Color onInfo = Color(0xFFFFFFFF);

  /// Neutral colors (grayscale)
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFFCCCCCC);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF0F0E12);

  /// Neutral colors map for backward compatibility
  static const Map<int, Color> neutral = {
    50: neutral50,
    100: neutral100,
    200: neutral200,
    300: neutral300,
    400: neutral400,
    500: neutral500,
    600: neutral600,
    700: neutral700,
    800: neutral800,
    900: neutral900,
  };

  /// Accent colors
  static const Color accentBlue = Color(0xFF4A90E2);
  static const Color accentPurple = Color(0xFF9B59B6);
  static const Color accentGreen = Color(0xFF2ECC71);
  static const Color accentOrange = Color(0xFFE67E22);

  /// Special colors
  static const Color transparent = Color(0x00000000);
  static const Color overlay = Color(0x80000000);
  static const Color border = Color(0xFF3A3A3A);
  static const Color borderLight = Color(0xFFCFD0FD);

  // ===========================================================================
  // TYPOGRAPHY SCALE
  // ===========================================================================

  /// Font families
  static const String fontFamilyPrimary = 'Cairo';
  static const String fontFamilySecondary = 'Josefin Sans';
  static const String fontFamilyArabic = 'Almarai';

  /// Display styles (largest, for hero content)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 60,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.40,
    height: 1.0,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.0,
    height: 1.0,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.6,
    height: 1.0,
  );

  /// Headline styles (for section headers)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.50,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.40,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  /// Title styles (for card titles, buttons)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.30,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.40,
  );

  /// Body styles (for main content)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.40,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.50,
  );

  /// Label styles (for buttons, form labels)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.40,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.45,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.50,
  );

  /// Caption styles (for secondary information)
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.50,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.60,
  );

  /// Special typography
  static const TextStyle arabicText = TextStyle(
    fontFamily: fontFamilyArabic,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  // ===========================================================================
  // SPACING TOKENS
  // ===========================================================================

  /// Spacing scale (4px base unit)
  static const double spacingXXS = 4.0;
  static const double spacingXS = 8.0;
  static const double spacingSM = 12.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  static const double spacingXXXL = 64.0;
  static const double spacingHuge = 96.0;

  // Backward compatibility aliases
  static const double spacingS = spacingSM;  // 12.0
  static const double spacingM = spacingMD;  // 16.0
  static const double spacingL = spacingLG;  // 24.0

  // ===========================================================================
  // BORDER RADIUS TOKENS
  // ===========================================================================

  /// Border radius scale
  static const double radiusXXS = 4.0;
  static const double radiusXS = 8.0;
  static const double radiusSM = 12.0;
  static const double radiusMD = 16.0;
  static const double radiusLG = 24.0;
  static const double radiusXL = 31.0;
  static const double radiusXXL = 40.0;
  static const double radiusCircular = 50.0;
  static const double radiusFull = 999.0;  // Fully rounded (pill shape)

  // Backward compatibility aliases  
  static const double radiusS = radiusSM;  // 12.0
  static const double radiusM = radiusMD;  // 16.0

  // ===========================================================================
  // SHADOW TOKENS
  // ===========================================================================

  /// Shadow definitions
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

  // ===========================================================================
  // GRADIENT TOKENS
  // ===========================================================================

  /// Gradient definitions
  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment(0.50, -0.00),
    end: Alignment(0.50, 1.00),
    colors: [transparent, primary],
  );

  static const LinearGradient gradientSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryVariant],
  );

  static const LinearGradient gradientBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, surfaceContainer],
  );

  static const LinearGradient gradientCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceContainer, surfaceContainerHigh],
  );

  static const LinearGradient gradientOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [transparent, overlay],
  );

  static const LinearGradient gradientAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentBlue, accentPurple],
  );

  // ===========================================================================
  // THEME DATA
  // ===========================================================================

  /// Light theme data
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamilySecondary,
    brightness: Brightness.light,

    // Color scheme
    colorScheme: const ColorScheme.light(
      primary: primary,
      primaryContainer: primaryContainer,
      secondary: secondary,
      secondaryContainer: secondaryContainer,
      surface: neutral50,
      surfaceContainer: neutral100,
      surfaceContainerHigh: neutral200,
      surfaceContainerHighest: neutral300,
      error: error,
      errorContainer: errorContainer,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onSurface: neutral900,
      onSurfaceVariant: neutral700,
      onError: onError,
      onErrorContainer: onErrorContainer,
      outline: neutral500,
    ),

    // Text theme
    textTheme: TextTheme(
      displayLarge: displayLarge.copyWith(color: neutral900),
      displayMedium: displayMedium.copyWith(color: neutral900),
      displaySmall: displaySmall.copyWith(color: neutral900),
      headlineLarge: headlineLarge.copyWith(color: neutral900),
      headlineMedium: headlineMedium.copyWith(color: neutral900),
      headlineSmall: headlineSmall.copyWith(color: neutral900),
      titleLarge: titleLarge.copyWith(color: neutral900),
      titleMedium: titleMedium.copyWith(color: neutral900),
      titleSmall: titleSmall.copyWith(color: neutral900),
      bodyLarge: bodyLarge.copyWith(color: neutral900),
      bodyMedium: bodyMedium.copyWith(color: neutral800),
      bodySmall: bodySmall.copyWith(color: neutral700),
      labelLarge: labelLarge.copyWith(color: neutral900),
      labelMedium: labelMedium.copyWith(color: neutral800),
      labelSmall: labelSmall.copyWith(color: neutral700),
    ),

    // Component themes
    cardTheme: CardTheme(
      color: neutral50,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusXL),
      ),
      shadowColor: Colors.black,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: neutral50,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: headlineSmall.copyWith(
        color: neutral900,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: neutral900),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: neutral50,
      selectedItemColor: primary,
      unselectedItemColor: neutral600,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: neutral400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: neutral400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: error),
      ),
      filled: true,
      fillColor: neutral100,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingMD,
        vertical: spacingMD,
      ),
    ),

    // Design system extensions
    extensions: <ThemeExtension<dynamic>>[
      const DesignSystemColors(
        primary: primary,
        secondary: secondary,
        surface: neutral50,
        background: neutral50,
        onSurface: neutral900,
        onSurfaceVariant: neutral700,
        error: error,
        success: success,
        warning: warning,
        info: info,
        accentBlue: accentBlue,
        accentPurple: accentPurple,
        accentGreen: accentGreen,
        accentOrange: accentOrange,
        border: neutral400,
        overlay: overlay,
        surfaceContainer: neutral100,
        surfaceContainerHigh: neutral200,
        surfaceContainerHighest: neutral300,
        onPrimary: onPrimary,
        onError: onError,
        onErrorContainer: onErrorContainer,
        textMuted: onSurfaceVariant,
        primaryRed: primary,
        white: neutral50,
        surfaceDark: surface,
        surfaceLight: surfaceContainer,
        cardBackground: surfaceContainer,
        borderColor: border,
        textPrimary: onSurface,
      ),
      DesignSystemTypography(
        displayLarge: displayLarge.copyWith(color: neutral900),
        displayMedium: displayMedium.copyWith(color: neutral900),
        displaySmall: displaySmall.copyWith(color: neutral900),
        headlineLarge: headlineLarge.copyWith(color: neutral900),
        headlineMedium: headlineMedium.copyWith(color: neutral900),
        headlineSmall: headlineSmall.copyWith(color: neutral900),
        titleLarge: titleLarge.copyWith(color: neutral900),
        titleMedium: titleMedium.copyWith(color: neutral900),
        titleSmall: titleSmall.copyWith(color: neutral900),
        bodyLarge: bodyLarge.copyWith(color: neutral900),
        bodyMedium: bodyMedium.copyWith(color: neutral800),
        bodySmall: bodySmall.copyWith(color: neutral700),
        labelLarge: labelLarge.copyWith(color: neutral900),
        labelMedium: labelMedium.copyWith(color: neutral800),
        labelSmall: labelSmall.copyWith(color: neutral700),
        caption: caption.copyWith(color: neutral700),
        overline: overline.copyWith(color: neutral700),
        arabicText: arabicText.copyWith(color: neutral900),
      ),
      const DesignSystemSpacing(),
      const DesignSystemRadius(),
      const DesignSystemShadows(),
      const DesignSystemGradients(),
      DesignSystemThemeExtension(
        designSystemColors: const DesignSystemColors(
          primary: primary,
          secondary: secondary,
          surface: neutral50,
          background: neutral50,
          onSurface: neutral900,
          onSurfaceVariant: neutral700,
          error: error,
          success: success,
          warning: warning,
          info: info,
          accentBlue: accentBlue,
          accentPurple: accentPurple,
          accentGreen: accentGreen,
          accentOrange: accentOrange,
          border: neutral400,
          overlay: overlay,
          surfaceContainer: neutral100,
          surfaceContainerHigh: neutral200,
          surfaceContainerHighest: neutral300,
          onPrimary: onPrimary,
          onError: onError,
          onErrorContainer: onErrorContainer,
          textMuted: onSurfaceVariant,
          primaryRed: primary,
          white: neutral50,
          surfaceDark: surface,
          surfaceLight: surfaceContainer,
          cardBackground: surfaceContainer,
          borderColor: border,
          textPrimary: onSurface,
        ),
        designSystemSpacing: const DesignSystemSpacing(),
        designSystemTypography: DesignSystemTypography(
          displayLarge: displayLarge.copyWith(color: neutral900),
          displayMedium: displayMedium.copyWith(color: neutral900),
          displaySmall: displaySmall.copyWith(color: neutral900),
          headlineLarge: headlineLarge.copyWith(color: neutral900),
          headlineMedium: headlineMedium.copyWith(color: neutral900),
          headlineSmall: headlineSmall.copyWith(color: neutral900),
          titleLarge: titleLarge.copyWith(color: neutral900),
          titleMedium: titleMedium.copyWith(color: neutral900),
          titleSmall: titleSmall.copyWith(color: neutral900),
          bodyLarge: bodyLarge.copyWith(color: neutral900),
          bodyMedium: bodyMedium.copyWith(color: neutral800),
          bodySmall: bodySmall.copyWith(color: neutral700),
          labelLarge: labelLarge.copyWith(color: neutral900),
          labelMedium: labelMedium.copyWith(color: neutral800),
          labelSmall: labelSmall.copyWith(color: neutral700),
          caption: caption.copyWith(color: neutral700),
          overline: overline.copyWith(color: neutral700),
          arabicText: arabicText.copyWith(color: neutral900),
        ),
        designSystemRadius: const DesignSystemRadius(),
        designSystemShadows: const DesignSystemShadows(),
        designSystemGradients: const DesignSystemGradients(),
      ),
    ],
  );

  /// Dark theme data (primary theme for MusicBud)
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamilySecondary,
    brightness: Brightness.dark,

    // Color scheme
    colorScheme: const ColorScheme.dark(
      primary: primary,
      primaryContainer: primaryContainer,
      secondary: secondary,
      secondaryContainer: secondaryContainer,
      surface: surface,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
      error: error,
      errorContainer: errorContainer,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      onError: onError,
      onErrorContainer: onErrorContainer,
      outline: neutral400,
    ),

    // Text theme
    textTheme: TextTheme(
      displayLarge: displayLarge.copyWith(color: onSurface),
      displayMedium: displayMedium.copyWith(color: onSurface),
      displaySmall: displaySmall.copyWith(color: onSurface),
      headlineLarge: headlineLarge.copyWith(color: onSurface),
      headlineMedium: headlineMedium.copyWith(color: onSurface),
      headlineSmall: headlineSmall.copyWith(color: onSurface),
      titleLarge: titleLarge.copyWith(color: onSurface),
      titleMedium: titleMedium.copyWith(color: onSurface),
      titleSmall: titleSmall.copyWith(color: onSurface),
      bodyLarge: bodyLarge.copyWith(color: onSurface),
      bodyMedium: bodyMedium.copyWith(color: onSurfaceVariant),
      bodySmall: bodySmall.copyWith(color: onSurfaceVariant),
      labelLarge: labelLarge.copyWith(color: onSurface),
      labelMedium: labelMedium.copyWith(color: onSurfaceVariant),
      labelSmall: labelSmall.copyWith(color: onSurfaceVariant),
    ),

    // Component themes
    cardTheme: CardTheme(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusXL),
      ),
      shadowColor: Colors.black,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: headlineSmall.copyWith(
        color: onSurface,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: onSurface),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: error),
      ),
      filled: true,
      fillColor: surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingMD,
        vertical: spacingMD,
      ),
    ),

    // Design system extensions
    extensions: <ThemeExtension<dynamic>>[
      const DesignSystemColors(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        error: error,
        success: success,
        warning: warning,
        info: info,
        accentBlue: accentBlue,
        accentPurple: accentPurple,
        accentGreen: accentGreen,
        accentOrange: accentOrange,
        border: border,
        overlay: overlay,
        surfaceContainer: surfaceContainer,
        surfaceContainerHigh: surfaceContainerHigh,
        surfaceContainerHighest: surfaceContainerHighest,
        onPrimary: onPrimary,
        onError: onError,
        onErrorContainer: onErrorContainer,
        textMuted: neutral700,
        primaryRed: primary,
        white: neutral50,
        surfaceDark: neutral900,
        surfaceLight: neutral100,
        cardBackground: neutral50,
        borderColor: neutral400,
        textPrimary: neutral900,
      ),
      DesignSystemTypography(
        displayLarge: displayLarge.copyWith(color: onSurface),
        displayMedium: displayMedium.copyWith(color: onSurface),
        displaySmall: displaySmall.copyWith(color: onSurface),
        headlineLarge: headlineLarge.copyWith(color: onSurface),
        headlineMedium: headlineMedium.copyWith(color: onSurface),
        headlineSmall: headlineSmall.copyWith(color: onSurface),
        titleLarge: titleLarge.copyWith(color: onSurface),
        titleMedium: titleMedium.copyWith(color: onSurface),
        titleSmall: titleSmall.copyWith(color: onSurface),
        bodyLarge: bodyLarge.copyWith(color: onSurface),
        bodyMedium: bodyMedium.copyWith(color: onSurfaceVariant),
        bodySmall: bodySmall.copyWith(color: onSurfaceVariant),
        labelLarge: labelLarge.copyWith(color: onSurface),
        labelMedium: labelMedium.copyWith(color: onSurfaceVariant),
        labelSmall: labelSmall.copyWith(color: onSurfaceVariant),
        caption: caption.copyWith(color: onSurfaceVariant),
        overline: overline.copyWith(color: onSurfaceVariant),
        arabicText: arabicText.copyWith(color: onSurface),
      ),
      const DesignSystemSpacing(),
      const DesignSystemRadius(),
      const DesignSystemShadows(),
      const DesignSystemGradients(),
      DesignSystemThemeExtension(
        designSystemColors: const DesignSystemColors(
          primary: primary,
          secondary: secondary,
          surface: surface,
          background: surface,
          onSurface: onSurface,
          onSurfaceVariant: onSurfaceVariant,
          error: error,
          success: success,
          warning: warning,
          info: info,
          accentBlue: accentBlue,
          accentPurple: accentPurple,
          accentGreen: accentGreen,
          accentOrange: accentOrange,
          border: border,
          overlay: overlay,
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          surfaceContainerHighest: surfaceContainerHighest,
          onPrimary: onPrimary,
          onError: onError,
          onErrorContainer: onErrorContainer,
          textMuted: neutral700,
          primaryRed: primary,
          white: neutral50,
          surfaceDark: neutral900,
          surfaceLight: neutral100,
          cardBackground: neutral50,
          borderColor: neutral400,
          textPrimary: neutral900,
        ),
        designSystemSpacing: const DesignSystemSpacing(),
        designSystemTypography: DesignSystemTypography(
          displayLarge: displayLarge.copyWith(color: onSurface),
          displayMedium: displayMedium.copyWith(color: onSurface),
          displaySmall: displaySmall.copyWith(color: onSurface),
          headlineLarge: headlineLarge.copyWith(color: onSurface),
          headlineMedium: headlineMedium.copyWith(color: onSurface),
          headlineSmall: headlineSmall.copyWith(color: onSurface),
          titleLarge: titleLarge.copyWith(color: onSurface),
          titleMedium: titleMedium.copyWith(color: onSurface),
          titleSmall: titleSmall.copyWith(color: onSurface),
          bodyLarge: bodyLarge.copyWith(color: onSurface),
          bodyMedium: bodyMedium.copyWith(color: onSurfaceVariant),
          bodySmall: bodySmall.copyWith(color: onSurfaceVariant),
          labelLarge: labelLarge.copyWith(color: onSurface),
          labelMedium: labelMedium.copyWith(color: onSurfaceVariant),
          labelSmall: labelSmall.copyWith(color: onSurfaceVariant),
          caption: caption.copyWith(color: onSurfaceVariant),
          overline: overline.copyWith(color: onSurfaceVariant),
          arabicText: arabicText.copyWith(color: onSurface),
        ),
        designSystemRadius: const DesignSystemRadius(),
        designSystemShadows: const DesignSystemShadows(),
        designSystemGradients: const DesignSystemGradients(),
      ),
    ],
  );
}

// ===========================================================================
// THEME EXTENSIONS
// ===========================================================================


/// Extension for component-specific theming
extension ThemeDataDesignSystemExtension on ThemeData {
  /// Combined design system extension
  DesignSystemThemeExtension? get designSystem => extension<DesignSystemThemeExtension>();

  /// Colors extension
  DesignSystemColors? get designSystemColors => extension<DesignSystemColors>();

  /// Typography extension
  DesignSystemTypography? get designSystemTypography => extension<DesignSystemTypography>();

  /// Spacing extension
  DesignSystemSpacing? get designSystemSpacing => extension<DesignSystemSpacing>();

  /// Radius extension
  DesignSystemRadius? get designSystemRadius => extension<DesignSystemRadius>();

  /// Shadows extension
  DesignSystemShadows? get designSystemShadows => extension<DesignSystemShadows>();

  /// Gradients extension
  DesignSystemGradients? get designSystemGradients => extension<DesignSystemGradients>();
}

/// Colors extension class
class DesignSystemColors extends ThemeExtension<DesignSystemColors> {
  const DesignSystemColors({
    required this.primary,
    required this.secondary,
    required this.surface,
    required this.background,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.accentBlue,
    required this.accentPurple,
    required this.accentGreen,
    required this.accentOrange,
    required this.border,
    required this.overlay,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.onPrimary,
    required this.onError,
    required this.onErrorContainer,
    required this.textMuted,
    required this.primaryRed,
    required this.white,
    required this.surfaceDark,
    required this.surfaceLight,
    required this.cardBackground,
    required this.borderColor,
    required this.textPrimary,
  });

  final Color primary;
  final Color secondary;
  final Color surface;
  final Color background;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color error;
  final Color success;
  final Color warning;
  final Color info;
  final Color accentBlue;
  final Color accentPurple;
  final Color accentGreen;
  final Color accentOrange;
  final Color border;
  final Color overlay;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color onPrimary;
  final Color onError;
  final Color onErrorContainer;
  final Color textMuted;
  final Color primaryRed;
  final Color white;
  final Color surfaceDark;
  final Color surfaceLight;
  final Color cardBackground;
  final Color borderColor;
  final Color textPrimary;

  @override
  DesignSystemColors copyWith({
    Color? primary,
    Color? secondary,
    Color? surface,
    Color? background,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
    Color? accentBlue,
    Color? accentPurple,
    Color? accentGreen,
    Color? accentOrange,
    Color? border,
    Color? overlay,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onPrimary,
    Color? onError,
    Color? onErrorContainer,
    Color? textMuted,
    Color? primaryRed,
    Color? white,
    Color? surfaceDark,
    Color? surfaceLight,
    Color? cardBackground,
    Color? borderColor,
    Color? textPrimary,
  }) {
    return DesignSystemColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      surface: surface ?? this.surface,
      background: background ?? this.background,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      accentBlue: accentBlue ?? this.accentBlue,
      accentPurple: accentPurple ?? this.accentPurple,
      accentGreen: accentGreen ?? this.accentGreen,
      accentOrange: accentOrange ?? this.accentOrange,
      border: border ?? this.border,
      overlay: overlay ?? this.overlay,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest ?? this.surfaceContainerHighest,
      onPrimary: onPrimary ?? this.onPrimary,
      onError: onError ?? this.onError,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      textMuted: textMuted ?? this.textMuted,
      primaryRed: primaryRed ?? this.primaryRed,
      white: white ?? this.white,
      surfaceDark: surfaceDark ?? this.surfaceDark,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      cardBackground: cardBackground ?? this.cardBackground,
      borderColor: borderColor ?? this.borderColor,
      textPrimary: textPrimary ?? this.textPrimary,
    );
  }

  @override
  DesignSystemColors lerp(DesignSystemColors? other, double t) {
    if (other is! DesignSystemColors) return this;
    return DesignSystemColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      background: Color.lerp(background, other.background, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      accentBlue: Color.lerp(accentBlue, other.accentBlue, t)!,
      accentPurple: Color.lerp(accentPurple, other.accentPurple, t)!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      accentOrange: Color.lerp(accentOrange, other.accentOrange, t)!,
      border: Color.lerp(border, other.border, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      surfaceContainer: Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh: Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceContainerHighest: Color.lerp(surfaceContainerHighest, other.surfaceContainerHighest, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      onErrorContainer: Color.lerp(onErrorContainer, other.onErrorContainer, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      primaryRed: Color.lerp(primaryRed, other.primaryRed, t)!,
      white: Color.lerp(white, other.white, t)!,
      surfaceDark: Color.lerp(surfaceDark, other.surfaceDark, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
    );
  }
}

/// Typography extension class
class DesignSystemTypography extends ThemeExtension<DesignSystemTypography> {
  DesignSystemTypography({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.caption,
    required this.overline,
    required this.arabicText,
  });

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
  final TextStyle caption;
  final TextStyle overline;
  final TextStyle arabicText;

  @override
  DesignSystemTypography copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    TextStyle? caption,
    TextStyle? overline,
    TextStyle? arabicText,
  }) {
    return DesignSystemTypography(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
      caption: caption ?? this.caption,
      overline: overline ?? this.overline,
      arabicText: arabicText ?? this.arabicText,
    );
  }

  @override
  DesignSystemTypography lerp(DesignSystemTypography? other, double t) {
    if (other is! DesignSystemTypography) return this;
    return DesignSystemTypography(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      overline: TextStyle.lerp(overline, other.overline, t)!,
      arabicText: TextStyle.lerp(arabicText, other.arabicText, t)!,
    );
  }
}

/// Spacing extension class
class DesignSystemSpacing extends ThemeExtension<DesignSystemSpacing> {
  const DesignSystemSpacing();

  double get xxs => DesignSystem.spacingXXS;
  double get xs => DesignSystem.spacingXS;
  double get sm => DesignSystem.spacingSM;
  double get md => DesignSystem.spacingMD;
  double get lg => DesignSystem.spacingLG;
  double get xl => DesignSystem.spacingXL;
  double get xxl => DesignSystem.spacingXXL;
  double get xxxl => DesignSystem.spacingXXXL;
  double get huge => DesignSystem.spacingHuge;

  @override
  DesignSystemSpacing copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
    double? huge,
  }) {
    return const DesignSystemSpacing();
  }

  @override
  DesignSystemSpacing lerp(DesignSystemSpacing? other, double t) {
    if (other is! DesignSystemSpacing) return this;
    return const DesignSystemSpacing();
  }
}

/// Border radius extension class
class DesignSystemRadius extends ThemeExtension<DesignSystemRadius> {
  const DesignSystemRadius();

  double get xxs => DesignSystem.radiusXXS;
  double get xs => DesignSystem.radiusXS;
  double get sm => DesignSystem.radiusSM;
  double get md => DesignSystem.radiusMD;
  double get lg => DesignSystem.radiusLG;
  double get xl => DesignSystem.radiusXL;
  double get xxl => DesignSystem.radiusXXL;
  double get circular => DesignSystem.radiusCircular;

  @override
  DesignSystemRadius copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? circular,
  }) {
    return const DesignSystemRadius();
  }

  @override
  DesignSystemRadius lerp(DesignSystemRadius? other, double t) {
    if (other is! DesignSystemRadius) return this;
    return const DesignSystemRadius();
  }
}

/// Shadows extension class
class DesignSystemShadows extends ThemeExtension<DesignSystemShadows> {
  const DesignSystemShadows();

  List<BoxShadow> get small => DesignSystem.shadowSmall;
  List<BoxShadow> get medium => DesignSystem.shadowMedium;
  List<BoxShadow> get large => DesignSystem.shadowLarge;
  List<BoxShadow> get text => DesignSystem.shadowText;
  List<BoxShadow> get card => DesignSystem.shadowCard;
  List<BoxShadow> get cardHover => DesignSystem.shadowCardHover;

  @override
  DesignSystemShadows copyWith({
    List<BoxShadow>? small,
    List<BoxShadow>? medium,
    List<BoxShadow>? large,
    List<BoxShadow>? text,
    List<BoxShadow>? card,
    List<BoxShadow>? cardHover,
  }) {
    return const DesignSystemShadows();
  }

  @override
  DesignSystemShadows lerp(DesignSystemShadows? other, double t) {
    if (other is! DesignSystemShadows) return this;
    return const DesignSystemShadows();
  }
}

/// Gradients extension class
class DesignSystemGradients extends ThemeExtension<DesignSystemGradients> {
  const DesignSystemGradients();

  LinearGradient get primary => DesignSystem.gradientPrimary;
  LinearGradient get secondary => DesignSystem.gradientSecondary;
  LinearGradient get background => DesignSystem.gradientBackground;
  LinearGradient get card => DesignSystem.gradientCard;
  LinearGradient get overlay => DesignSystem.gradientOverlay;
  LinearGradient get accent => DesignSystem.gradientAccent;

  @override
  DesignSystemGradients copyWith({
    LinearGradient? primary,
    LinearGradient? secondary,
    LinearGradient? background,
    LinearGradient? card,
    LinearGradient? overlay,
    LinearGradient? accent,
  }) {
    return const DesignSystemGradients();
  }

  @override
  DesignSystemGradients lerp(DesignSystemGradients? other, double t) {
    if (other is! DesignSystemGradients) return this;
    return const DesignSystemGradients();
  }
}

/// Main theme extension that combines all design system components
class DesignSystemThemeExtension extends ThemeExtension<DesignSystemThemeExtension> {
  DesignSystemThemeExtension({
    required this.designSystemColors,
    required this.designSystemSpacing,
    required this.designSystemTypography,
    required this.designSystemRadius,
    required this.designSystemShadows,
    required this.designSystemGradients,
  });

  final DesignSystemColors designSystemColors;
  final DesignSystemSpacing designSystemSpacing;
  final DesignSystemTypography designSystemTypography;
  final DesignSystemRadius designSystemRadius;
  final DesignSystemShadows designSystemShadows;
  final DesignSystemGradients designSystemGradients;

  @override
  DesignSystemThemeExtension copyWith({
    DesignSystemColors? designSystemColors,
    DesignSystemSpacing? designSystemSpacing,
    DesignSystemTypography? designSystemTypography,
    DesignSystemRadius? designSystemRadius,
    DesignSystemShadows? designSystemShadows,
    DesignSystemGradients? designSystemGradients,
  }) {
    return DesignSystemThemeExtension(
      designSystemColors: designSystemColors ?? this.designSystemColors,
      designSystemSpacing: designSystemSpacing ?? this.designSystemSpacing,
      designSystemTypography: designSystemTypography ?? this.designSystemTypography,
      designSystemRadius: designSystemRadius ?? this.designSystemRadius,
      designSystemShadows: designSystemShadows ?? this.designSystemShadows,
      designSystemGradients: designSystemGradients ?? this.designSystemGradients,
    );
  }

  @override
  DesignSystemThemeExtension lerp(DesignSystemThemeExtension? other, double t) {
    if (other is! DesignSystemThemeExtension) return this;
    return DesignSystemThemeExtension(
      designSystemColors: designSystemColors.lerp(other.designSystemColors, t),
      designSystemSpacing: designSystemSpacing.lerp(other.designSystemSpacing, t),
      designSystemTypography: designSystemTypography.lerp(other.designSystemTypography, t),
      designSystemRadius: designSystemRadius.lerp(other.designSystemRadius, t),
      designSystemShadows: designSystemShadows.lerp(other.designSystemShadows, t),
      designSystemGradients: designSystemGradients.lerp(other.designSystemGradients, t),
    );
  }
}