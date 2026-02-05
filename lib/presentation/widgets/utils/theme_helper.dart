import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

/// Utility class for theme-related operations and design system helpers.
/// Provides convenient methods for accessing design tokens and creating consistent styling.
///
/// **Features:**
/// - Easy access to design system tokens
/// - Common widget styling helpers
/// - Responsive breakpoint utilities
/// - Color manipulation helpers
/// - Typography shortcuts
///
/// **Usage:**
/// ```dart
/// // Get design system colors
/// final colors = ThemeHelper.getDesignSystemColors(context);
/// final textColor = colors.onSurface;
///
/// // Get responsive spacing
/// final spacing = ThemeHelper.getResponsiveSpacing(context, base: 16);
///
/// // Create consistent button style
/// final buttonStyle = ThemeHelper.getElevatedButtonStyle(context);
///
/// // Check if dark mode
/// final isDark = ThemeHelper.isDarkMode(context);
///
/// // Get screen size category
/// final sizeCategory = ThemeHelper.getScreenSizeCategory(context);
/// ```
class ThemeHelper {
  /// Private constructor to prevent instantiation
  const ThemeHelper._();

  /// Get design system colors from context
  static DesignSystemColors getDesignSystemColors(BuildContext context) {
    // Access DesignSystem static members directly
    return DesignSystemColors(
      primary: DesignSystem.primary,
      secondary: DesignSystem.secondary,
      surface: DesignSystem.surface,
      background: DesignSystem.background,
      onSurface: DesignSystem.onSurface,
      onSurfaceVariant: DesignSystem.onSurfaceVariant,
      error: DesignSystem.error,
      success: DesignSystem.success,
      warning: DesignSystem.warning,
      info: DesignSystem.info,
      accentBlue: DesignSystem.accentBlue,
      accentPurple: DesignSystem.accentPurple,
      accentGreen: DesignSystem.accentGreen,
      accentOrange: DesignSystem.accentOrange,
      border: DesignSystem.border,
      overlay: DesignSystem.overlay,
      surfaceContainer: DesignSystem.surfaceContainer,
      surfaceContainerHigh: DesignSystem.surfaceContainerHigh,
      surfaceContainerHighest: DesignSystem.surfaceContainerHighest,
      onPrimary: DesignSystem.onPrimary,
      onError: DesignSystem.onError,
      onErrorContainer: DesignSystem.onErrorContainer,
      textMuted: DesignSystem.textMuted,
      primaryRed: DesignSystem.primaryRed,
      white: Colors.white, // Assuming white is directly from Colors
      surfaceDark: DesignSystem.surfaceDark,
      surfaceLight: DesignSystem.surfaceLight,
      cardBackground: DesignSystem.cardBackground,
      borderColor: DesignSystem.borderColor,
      textPrimary: DesignSystem.textPrimary,
    );
  }

  /// Get design system typography from context
  static DesignSystemTypography getDesignSystemTypography(BuildContext context) {
    // Access DesignSystem static members directly
    return DesignSystemTypography(
      displayLarge: DesignSystem.displayLarge,
      displayMedium: DesignSystem.displayMedium,
      displaySmall: DesignSystem.displaySmall,
      headlineLarge: DesignSystem.headlineLarge,
      headlineMedium: DesignSystem.headlineMedium,
      headlineSmall: DesignSystem.headlineSmall,
      titleLarge: DesignSystem.titleLarge,
      titleMedium: DesignSystem.titleMedium,
      titleSmall: DesignSystem.titleSmall,
      bodyLarge: DesignSystem.bodyLarge,
      bodyMedium: DesignSystem.bodyMedium,
      bodySmall: DesignSystem.bodySmall,
      labelLarge: DesignSystem.labelLarge,
      labelMedium: DesignSystem.labelMedium,
      labelSmall: DesignSystem.labelSmall,
      caption: DesignSystem.caption,
      overline: DesignSystem.bodySmall, // Closest equivalent in new system
      arabicText: DesignSystem.bodyMedium, // Closest equivalent in new system
    );
  }

  /// Get design system spacing from context
  static DesignSystemSpacing getDesignSystemSpacing(BuildContext context) {
    // Access DesignSystem static members directly
    return DesignSystemSpacing(
      xxs: DesignSystem.spacingXXS,
      xs: DesignSystem.spacingXS,
      sm: DesignSystem.spacingSM,
      md: DesignSystem.spacingMD,
      lg: DesignSystem.spacingLG,
      xl: DesignSystem.spacingXL,
      xxl: DesignSystem.spacingXXL,
      xxxl: DesignSystem.spacingXXL, // Closest equivalent
      huge: DesignSystem.spacingXXL, // Closest equivalent
    );
  }

  /// Get design system radius from context
  static DesignSystemRadius getDesignSystemRadius(BuildContext context) {
    // Access DesignSystem static members directly
    return DesignSystemRadius(
      xs: DesignSystem.radiusXS,
      sm: DesignSystem.radiusSM,
      md: DesignSystem.radiusMD,
      lg: DesignSystem.radiusLG,
      xl: DesignSystem.radiusXL,
      xxl: DesignSystem.radiusXL, // Closest equivalent
      circular: DesignSystem.radiusFull,
      xxs: DesignSystem.radiusXS,
    );
  }

  /// Get design system shadows from context
  static DesignSystemShadows getDesignSystemShadows(BuildContext context) {
    return DesignSystemShadows(
      small: DesignSystem.shadowSmall,
      medium: DesignSystem.shadowMedium,
      large: DesignSystem.shadowLarge,
      card: DesignSystem.shadowCard,
      text: DesignSystem.shadowText,
    );
  }

  /// Get design system gradients from context
  static DesignSystemGradients getDesignSystemGradients(BuildContext context) {
    return DesignSystemGradients(
      primary: DesignSystem.gradientPrimary,
      secondary: DesignSystem.gradientSecondary,
      overlay: DesignSystem.gradientOverlay,
      background: DesignSystem.gradientBackground,
      card: DesignSystem.gradientCard,
    );
  }

  /// Check if current theme is dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get screen size category for responsive design
  static ScreenSizeCategory getScreenSizeCategory(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) return ScreenSizeCategory.mobile;
    if (width < 900) return ScreenSizeCategory.tablet;
    if (width < 1200) return ScreenSizeCategory.smallDesktop;
    return ScreenSizeCategory.largeDesktop;
  }

  /// Get responsive spacing based on screen size
  static double getResponsiveSpacing(BuildContext context, {
    required double mobile,
    double? tablet,
    double? smallDesktop,
    double? largeDesktop,
  }) {
    final category = getScreenSizeCategory(context);

    switch (category) {
      case ScreenSizeCategory.mobile:
        return mobile;
      case ScreenSizeCategory.tablet:
        return tablet ?? (mobile * 1.25);
      case ScreenSizeCategory.smallDesktop:
        return smallDesktop ?? (mobile * 1.5);
      case ScreenSizeCategory.largeDesktop:
        return largeDesktop ?? (mobile * 1.75);
    }
  }

  /// Get responsive text scale factor
  static double getResponsiveTextScale(BuildContext context) {
    final category = getScreenSizeCategory(context);

    switch (category) {
      case ScreenSizeCategory.mobile:
        return 1.0;
      case ScreenSizeCategory.tablet:
        return 1.1;
      case ScreenSizeCategory.smallDesktop:
        return 1.2;
      case ScreenSizeCategory.largeDesktop:
        return 1.3;
    }
  }

  /// Create consistent card decoration
  static BoxDecoration getCardDecoration(BuildContext context, {
    Color? color,
    bool showShadow = false,
    BorderRadius? borderRadius,
  }) {
    final colors = ThemeHelper.getDesignSystemColors(context);

    return BoxDecoration(
      color: color ?? colors.surfaceContainer,
      borderRadius: borderRadius ?? BorderRadius.circular(DesignSystem.radiusLG),
      boxShadow: showShadow ? DesignSystem.shadowCard : null,
    );
  }

  /// Create consistent button style
  static ButtonStyle getElevatedButtonStyle(BuildContext context, {
    Color? backgroundColor,
    Color? foregroundColor,
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
  }) {
    final colors = ThemeHelper.getDesignSystemColors(context);

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? colors.primary,
      foregroundColor: foregroundColor ?? colors.onPrimary,
      minimumSize: minimumSize ?? const Size(88, 36),
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingLG,
        vertical: DesignSystem.spacingMD,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      ),
    );
  }

  /// Create consistent text button style
  static ButtonStyle getTextButtonStyle(BuildContext context, {
    Color? foregroundColor,
    TextStyle? textStyle,
  }) {
    final colors = ThemeHelper.getDesignSystemColors(context);

    return TextButton.styleFrom(
      foregroundColor: foregroundColor ?? colors.primary,
      textStyle: textStyle ?? DesignSystem.labelLarge,
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingMD,
        vertical: DesignSystem.spacingSM,
      ),
    );
  }

  /// Create consistent outlined button style
  static ButtonStyle getOutlinedButtonStyle(BuildContext context, {
    Color? foregroundColor,
    Color? sideColor,
  }) {
    final colors = ThemeHelper.getDesignSystemColors(context);

    return OutlinedButton.styleFrom(
      foregroundColor: foregroundColor ?? colors.onSurface,
      side: BorderSide(color: sideColor ?? colors.border),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingLG,
        vertical: DesignSystem.spacingMD,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      ),
    );
  }

  /// Get consistent text style with responsive scaling
  static TextStyle getResponsiveTextStyle(BuildContext context, TextStyle baseStyle) {
    final scale = getResponsiveTextScale(context);
    return baseStyle.copyWith(fontSize: baseStyle.fontSize! * scale);
  }

  /// Create a color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withAlpha((255 * opacity).round());
  }

  /// Lighten a color by a percentage
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    return Color.lerp(color, Colors.white, amount)!;
  }

  /// Darken a color by a percentage
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    return Color.lerp(color, Colors.black, amount)!;
  }

  /// Get contrasting text color for a background
  static Color getContrastTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  /// Create a surface color with elevation
  static Color getSurfaceColorWithElevation(BuildContext context, int elevation) {
    final colors = getDesignSystemColors(context);

    switch (elevation) {
      case 0:
        return colors.surface;
      case 1:
        return colors.surfaceContainer;
      case 2:
        return colors.surfaceContainerHigh;
      case 3:
      default:
        return colors.surfaceContainerHighest;
    }
  }

  /// Get spacing value by name
  static double getSpacingByName(BuildContext context, String name) {
    // Access DesignSystem static members directly
    switch (name) {
      case 'xxs':
        return DesignSystem.spacingXXS;
      case 'xs':
        return DesignSystem.spacingXS;
      case 'sm':
        return DesignSystem.spacingSM;
      case 'md':
        return DesignSystem.spacingMD;
      case 'lg':
        return DesignSystem.spacingLG;
      case 'xl':
        return DesignSystem.spacingXL;
      case 'xxl':
        return DesignSystem.spacingXXL;
      case 'xxxl':
        return DesignSystem.spacingXXL; // Closest equivalent
      case 'huge':
        return DesignSystem.spacingXXL; // Closest equivalent
      default:
        return DesignSystem.spacingMD;
    }
  }

  /// Get radius value by name
  static double getRadiusByName(BuildContext context, String name) {
    // Access DesignSystem static members directly
    switch (name) {
      case 'xxs':
        return DesignSystem.radiusXS;
      case 'xs':
        return DesignSystem.radiusXS;
      case 'sm':
        return DesignSystem.radiusSM;
      case 'md':
        return DesignSystem.radiusMD;
      case 'lg':
        return DesignSystem.radiusLG;
      case 'xl':
        return DesignSystem.radiusXL;
      case 'xxl':
        return DesignSystem.radiusXL; // Closest equivalent
      case 'circular':
        return DesignSystem.radiusFull;
      default:
        return DesignSystem.radiusMD;
    }
  }
}

/// Screen size categories for responsive design
enum ScreenSizeCategory {
  mobile,        // < 600px
  tablet,        // 600px - 900px
  smallDesktop,  // 900px - 1200px
  largeDesktop,  // >= 1200px
}

// Dummy classes for DesignSystem components since they were removed
class DesignSystemColors {
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
}

class DesignSystemTypography {
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

  const DesignSystemTypography({
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
}

class DesignSystemSpacing {
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;
  final double huge;

  const DesignSystemSpacing({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.huge,
  });
}

class DesignSystemRadius {
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double circular;

  const DesignSystemRadius({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.circular,
  });
}

class DesignSystemShadows {
  final List<BoxShadow> small;
  final List<BoxShadow> medium;
  final List<BoxShadow> large;
  final List<BoxShadow> card;
  final List<BoxShadow> text;

  const DesignSystemShadows({
    required this.small,
    required this.medium,
    required this.large,
    required this.card,
    required this.text,
  });
}

class DesignSystemGradients {
  final LinearGradient primary;
  final LinearGradient secondary;
  final LinearGradient overlay;
  final LinearGradient background;
  final LinearGradient card;

  const DesignSystemGradients({
    required this.primary,
    required this.secondary,
    required this.overlay,
    required this.background,
    required this.card,
  });
}