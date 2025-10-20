import 'package:flutter/material.dart';

/// @deprecated Use DesignSystem instead. This file is deprecated and will be removed in a future version.
/// Migrate to: import 'package:musicbud/core/theme/design_system.dart';
/// All theme tokens are now available through DesignSystem and theme extensions.
@Deprecated('Use DesignSystem instead. This file is deprecated and will be removed in a future version.')
extension CustomTextTheme on TextTheme {
  TextStyle get headlineH7 => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.30,
  );
}

@Deprecated('Use DesignSystem instead. This file is deprecated and will be removed in a future version.')
class AppTheme {
  final BuildContext context;
  
  const AppTheme._(this.context);
  
  static AppTheme of(BuildContext context) {
    return AppTheme._(context);
  }

  ThemeData get theme => Theme.of(context);
  
  static const Color primaryColor = Color(0xFF1DB954);
  static const Color secondaryColor = Color(0xFF191414);
  static const Color accentColor = Color(0xFF1ED760);
  static const Color backgroundColor = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF282828);
  static const Color errorColor = Color(0xFFCF6679);
  
  ColorScheme get colors => theme.colorScheme;
  TextTheme get typography => theme.textTheme;
  
  // Instance getters for convenience
  AppSpacing get spacing => AppSpacing();
  AppBorderRadius get radius => AppBorderRadius();

  // Custom text styles
  TextStyle get headlineH7 => const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.30,
  );

  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Color(0xB3FFFFFF);
  static const Color textTertiaryColor = Color(0x80FFFFFF);


  // Instance getters for gradients and shadows
  AppGradients get gradients => AppGradients();
  AppShadows get shadows => AppShadows();

  // Custom color getters
  Color get surfaceDark => const Color(0xFF282828);
  Color get surfaceLight => const Color(0xFF3E3E3E);
  Color get textPrimary => Colors.white;
  Color get textSecondary => const Color(0xB3FFFFFF);
  Color get textMuted => const Color(0x80FFFFFF);
  Color get primaryRed => const Color(0xFFCF6679);
  Color get errorRed => const Color(0xFFCF6679);
  Color get accentGreen => const Color(0xFF1ED760);
  Color get accentBlue => const Color(0xFF1E90FF);
  Color get white => Colors.white;
  Color get borderColor => const Color(0xFF3E3E3E);
  Color get primaryDark => const Color(0xFF1AA34A);

  // Gradients
  LinearGradient get backgroundGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF121212),
      Color(0xFF1A1A1A),
      Color(0xFF121212),
    ],
  );

  // Shadows
  List<BoxShadow> get shadowCard => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 6,
      offset: const Offset(0, 3),
    ),
  ];

  List<BoxShadow> get shadowSmall => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor, // Changed from backgroundColor to use surface
        error: errorColor,
        surfaceContainerHighest: surfaceColor.withAlpha(204), // .8 opacity using withAlpha
        // Add custom extensions for text colors
        brightness: Brightness.dark,
        outline: textSecondaryColor,
        onSurface: textPrimaryColor,
      ).copyWith(
        // We'll use shadow color for textSecondary since it's rarely used
        shadow: textSecondaryColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textSecondaryColor,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: textTertiaryColor,
          fontSize: 12,
        ),
      ).copyWith(
        // Add custom headlineH7
        headlineSmall: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.30,
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        buttonColor: primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
        error: errorColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF5F5F5),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.black,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: Colors.black54,
          fontSize: 12,
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        buttonColor: primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
      ),
    );
  }
}

@Deprecated('Use DesignSystem instead. This file is deprecated and will be removed in a future version.')
class AppSpacing {
  AppSpacing();

  final double xxs = 4;
  final double xs = 8;
  final double sm = 12;
  final double md = 16;
  final double lg = 24;
  final double xl = 32;
  final double xxl = 48;
}

@Deprecated('Use DesignSystem instead. This file is deprecated and will be removed in a future version.')
class AppBorderRadius {
  AppBorderRadius();

  final double xs = 4;
  final double sm = 8;
  final double md = 12;
  final double lg = 16;
  final double xl = 24;
  final double xxl = 32;
  final double circular = 999;
}

@Deprecated('Use DesignSystem instead. This file is deprecated and will be removed in a future version.')
class AppGradients {
  AppGradients();

  LinearGradient get backgroundGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF121212),
      Color(0xFF1A1A1A),
      Color(0xFF121212),
    ],
  );
}

@Deprecated('Use DesignSystem instead. This file is deprecated and will be removed in a future version.')
class AppShadows {
  AppShadows();

  List<BoxShadow> get shadowCard => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 6,
      offset: const Offset(0, 3),
    ),
  ];

  List<BoxShadow> get shadowSmall => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
}
