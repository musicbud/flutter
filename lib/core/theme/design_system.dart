
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  static const Color primary = Color(0xFFE91E63);  // Vibrant Pink
  static const Color primaryContainer = Color(0xFFF06292);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryVariant = Color(0xFFD81B60);
    static const Color primaryRed = primary;
  static const Color primaryDark = primaryVariant;


  /// Pink shades for UI elements
  static const Color pinkAccent = Color(0xFFE91E63);
  static const Color pinkLight = Color(0xFFF48FB1);
  static const Color pinkDark = Color(0xFFC2185B);

  /// Secondary colors
  static const Color secondary = Color(0xFF00E5FF); // Cyan Accent
  static const Color secondaryContainer = Color(0xFF84FFFF);
  static const Color onSecondary = Color(0xFF000000);

  /// Surface colors (Dark theme from Figma)
  static const Color surface = Color(0xFF121212);  // Near-black background
  static const Color surfaceContainer = Color(0xFF1E1E1E);  // Card/container background
  static const Color surfaceContainerHigh = Color(0xFF282828);  // Elevated containers
  static const Color surfaceContainerHighest = Color(0xFF323232);  // Highest elevation
  static const Color onSurface = Color(0xFFFFFFFF);  // White text
  static const Color onSurfaceVariant = Color(0xFFAAAAAA);  // Gray text
  static const Color onSurfaceDim = Color(0xFF888888);  // Dimmer text
  static const Color surfaceDark = surfaceContainer;
  static const Color surfaceLight = surfaceContainerHigh;
    static const Color cardBackground = surfaceContainer;
      static const Color textPrimary = onSurface;
  static const Color textMuted = onSurfaceVariant;

  /// Background colors
  static const Color background = Color(0xFF121212);  // Main dark background
  static const Color backgroundDark = Color(0xFF000000);  // Pure black
  static const Color onBackground = Color(0xFFFFFFFF);
    static const Color backgroundPrimary = background;

  /// Error colors
  static const Color error = Color(0xFFCF6679);
  static const Color errorRed = Color(0xFFE53935);  // Bright red for errors
  static const Color errorContainer = Color(0xFFFF0000);
  static const Color onError = Color(0xFF000000);
  static const Color onErrorContainer = Color(0xFFFFFFFF);

  /// Success colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successGreen = Color(0xFF4CAF50);  // Alias for success
  static const Color successContainer = Color(0xFF66BB6A);
  static const Color onSuccess = Color(0xFFFFFFFF);

  /// Warning colors
  static const Color warning = Color(0xFFFFA726);
  static const Color warningOrange = Color(0xFFFFA726);  // Alias for warning
  static const Color warningContainer = Color(0xFFFFB74D);
  static const Color onWarning = Color(0xFF000000);

  /// Info colors
  static const Color info = Color(0xFF29B6F6);
  static const Color infoContainer = Color(0xFF4FC3F7);
  static const Color onInfo = Color(0xFFFFFFFF);

  /// Neutral colors (grayscale)
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);
    static const Color textSecondary = neutral400;

  /// Accent colors
  static const Color accentBlue = Color(0xFF448AFF);
  static const Color accentPurple = Color(0xFF7C4DFF);
  static const Color accentGreen = Color(0xFF00E676);
  static const Color accentOrange = Color(0xFFFF9100);

  /// Special colors
  static const Color transparent = Color(0x00000000);
  static const Color overlay = Color(0x8A000000);
  static const Color border = Color(0xFF3A3A3A);
  static const Color borderLight = Color(0xFFCFD0FD);
  static const Color borderColor = border;


  // ===========================================================================
  // TYPOGRAPHY SCALE using Google Fonts
  // ===========================================================================

  /// Font families
  static final String fontFamilyPrimary = GoogleFonts.poppins().fontFamily!;
  static final String fontFamilySecondary = GoogleFonts.montserrat().fontFamily!;

  /// Display styles
  static final TextStyle displayLarge = GoogleFonts.poppins(fontSize: 57, fontWeight: FontWeight.w800, letterSpacing: -0.25);
  static final TextStyle displayMedium = GoogleFonts.poppins(fontSize: 45, fontWeight: FontWeight.w700);
  static final TextStyle displaySmall = GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w600);

  /// Headline styles
  static final TextStyle headlineLarge = GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w700);
  static final TextStyle headlineMedium = GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w600);
  static final TextStyle headlineSmall = GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500);

  /// Title styles
  static final TextStyle titleLarge = GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500);
  static final TextStyle titleMedium = GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15);
  static final TextStyle titleSmall = GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1);

  /// Body styles
  static final TextStyle bodyLarge = GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5);
  static final TextStyle bodyMedium = GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25);
  static final TextStyle bodySmall = GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4);
    static final TextStyle caption = bodySmall;


  /// Label styles
  static final TextStyle labelLarge = GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1);
  static final TextStyle labelMedium = GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5);
  static final TextStyle labelSmall = GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5);
  static final TextStyle heading3 = headlineSmall;
  static final TextStyle heading4 = titleLarge;
  // ===========================================================================
  // SPACING TOKENS
  // ===========================================================================

  /// Spacing scale (8px base unit)
  static const double spacingXXS = 4.0;
  static const double spacingXS = 8.0;
  static const double spacingSM = 16.0;
  static const double spacingMD = 24.0;
  static const double spacingLG = 32.0;
  static const double spacingXL = 48.0;
  static const double spacingXXL = 64.0;
  static const double md = spacingMD;
    static const double lg = spacingLG;
  // ===========================================================================
  // BORDER RADIUS TOKENS
  // ===========================================================================

  /// Border radius scale
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;
    static const double radiusLg = radiusLG;
    static const double radiusCircular = 50.0;

  // ===========================================================================
  // SHADOW TOKENS
  // ===========================================================================
  static const List<BoxShadow> shadowSmall = [BoxShadow(color: Color(0x33000000), offset: Offset(0, 1), blurRadius: 3, spreadRadius: 0)];
  static const List<BoxShadow> shadowMedium = [BoxShadow(color: Color(0x3D000000), offset: Offset(0, 4), blurRadius: 8, spreadRadius: 0)];
  static const List<BoxShadow> shadowLarge = [BoxShadow(color: Color(0x4D000000), offset: Offset(0, 12), blurRadius: 17, spreadRadius: 0)];
    static const List<BoxShadow> shadowCard = shadowMedium;
  static const List<BoxShadow> shadowText = [ BoxShadow( color: Color(0x80000000), offset: Offset(0, 2), blurRadius: 4, spreadRadius: 0, ), ];


  // ===========================================================================
  // GRADIENT TOKENS
  // ===========================================================================
  static const LinearGradient gradientPrimary = LinearGradient(colors: [primary, primaryVariant], begin: Alignment.topLeft, end: Alignment.bottomRight);
  static const LinearGradient gradientSecondary = LinearGradient(colors: [secondary, Color(0xFF64FFDA)], begin: Alignment.topLeft, end: Alignment.bottomRight);
  static const LinearGradient gradientOverlay = LinearGradient(colors: [Color(0x00000000), Color(0xA0000000)], begin: Alignment.topCenter, end: Alignment.bottomCenter);
  static const LinearGradient gradientBackground = LinearGradient(colors: [background, surfaceContainer], begin: Alignment.topCenter, end: Alignment.bottomCenter);
  static const LinearGradient gradientCard = LinearGradient(colors: [surfaceContainer, surfaceContainerHigh], begin: Alignment.topLeft, end: Alignment.bottomRight);
  
  // ===========================================================================
  // THEME DATA
  // ===========================================================================

  /// Light theme data
  static ThemeData get lightTheme => _createTheme(brightness: Brightness.light);

  /// Dark theme data
  static ThemeData get darkTheme => _createTheme(brightness: Brightness.dark);
  
  static ThemeData _createTheme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondary,
      tertiary: accentPurple,
      onTertiary: onPrimary,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: isDark ? surface : neutral100,
      onSurface: isDark ? onSurface : neutral900,
      onSurfaceVariant: isDark ? onSurfaceVariant : neutral700,
      surfaceContainerHighest: isDark ? surfaceContainerHighest : neutral200,
      outline: isDark ? border : neutral400,
      inverseSurface: isDark ? onSurface : neutral900,
      onInverseSurface: isDark ? surface : neutral100,
      inversePrimary: onPrimary,
      shadow: isDark ? Colors.black : Colors.grey.shade400,
    );

    final textTheme = TextTheme(
      displayLarge: displayLarge.copyWith(color: colorScheme.onSurface),
      displayMedium: displayMedium.copyWith(color: colorScheme.onSurface),
      displaySmall: displaySmall.copyWith(color: colorScheme.onSurface),
      headlineLarge: headlineLarge.copyWith(color: colorScheme.onSurface),
      headlineMedium: headlineMedium.copyWith(color: colorScheme.onSurface),
      headlineSmall: headlineSmall.copyWith(color: colorScheme.onSurface),
      titleLarge: titleLarge.copyWith(color: colorScheme.onSurface),
      titleMedium: titleMedium.copyWith(color: colorScheme.onSurface),
      titleSmall: titleSmall.copyWith(color: colorScheme.onSurface),
      bodyLarge: bodyLarge.copyWith(color: colorScheme.onSurface),
      bodyMedium: bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
      bodySmall: bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
      labelLarge: labelLarge.copyWith(color: colorScheme.onSurface),
      labelMedium: labelMedium.copyWith(color: colorScheme.onSurfaceVariant),
      labelSmall: labelSmall.copyWith(color: colorScheme.onSurfaceVariant, letterSpacing: 0.5),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: isDark ? background : neutral50,
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLG)),
        color: isDark ? surfaceContainer : Colors.white,
        shadowColor: colorScheme.shadow,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? surface : Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: headlineSmall.copyWith(color: colorScheme.onSurface),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? surfaceContainer : neutral100,
        selectedItemColor: primary,
        unselectedItemColor: onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? surfaceContainer : neutral100,
        contentPadding: const EdgeInsets.symmetric(horizontal: spacingSM, vertical: spacingSM),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusFull)),
          backgroundColor: primary,
          foregroundColor: onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: spacingMD, vertical: spacingSM),
          textStyle: labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: labelLarge,
        ),
      ),
    );
  }
}


class MusicBudColors {
  static const Color backgroundPrimary = DesignSystem.background;
  static const Color backgroundTertiary = DesignSystem.surfaceContainer;
  static const Color primaryRed = DesignSystem.primary;
  static const Color textSecondary = DesignSystem.onSurfaceVariant;
  static const Color primaryDark = DesignSystem.primaryDark;
  static const Color textPrimary = DesignSystem.onSurface;

}

class MusicBudTypography {
  static final TextStyle heading3 = DesignSystem.headlineSmall;
  static final TextStyle bodyMedium = DesignSystem.bodyMedium;
  static final TextStyle bodyLarge = DesignSystem.bodyLarge;
  static final TextStyle heading4 = DesignSystem.headlineSmall;
  static final TextStyle bodySmall = DesignSystem.bodySmall;
}

class MusicBudSpacing {
    static const double lg = DesignSystem.spacingLG;
    static const double radiusLg = DesignSystem.radiusLG;
    static const double md = DesignSystem.spacingMD;
    static const double sm = DesignSystem.spacingSM;
}
