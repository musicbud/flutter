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
    return Theme.of(context).extension<DesignSystemThemeExtension>()!.designSystemColors;
  }

  /// Get design system typography from context
  static DesignSystemTypography getDesignSystemTypography(BuildContext context) {
    return Theme.of(context).extension<DesignSystemThemeExtension>()!.designSystemTypography;
  }

  /// Get design system spacing from context
  static DesignSystemSpacing getDesignSystemSpacing(BuildContext context) {
    return Theme.of(context).extension<DesignSystemThemeExtension>()!.designSystemSpacing;
  }

  /// Get design system radius from context
  static DesignSystemRadius getDesignSystemRadius(BuildContext context) {
    return Theme.of(context).extension<DesignSystemThemeExtension>()!.designSystemRadius;
  }

  /// Get design system shadows from context
  static DesignSystemShadows getDesignSystemShadows(BuildContext context) {
    return Theme.of(context).extension<DesignSystemThemeExtension>()!.designSystemShadows;
  }

  /// Get design system gradients from context
  static DesignSystemGradients getDesignSystemGradients(BuildContext context) {
    return Theme.of(context).extension<DesignSystemThemeExtension>()!.designSystemGradients;
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
    final design = Theme.of(context).extension<DesignSystemThemeExtension>()!;
    final colors = design.designSystemColors;

    return BoxDecoration(
      color: color ?? colors.surfaceContainer,
      borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.lg),
      boxShadow: showShadow ? design.designSystemShadows.card : null,
    );
  }

  /// Create consistent button style
  static ButtonStyle getElevatedButtonStyle(BuildContext context, {
    Color? backgroundColor,
    Color? foregroundColor,
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
  }) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>()!;
    final colors = design.designSystemColors;

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? colors.primary,
      foregroundColor: foregroundColor ?? colors.onPrimary,
      minimumSize: minimumSize ?? const Size(88, 36),
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: design.designSystemSpacing.lg,
        vertical: design.designSystemSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      ),
    );
  }

  /// Create consistent text button style
  static ButtonStyle getTextButtonStyle(BuildContext context, {
    Color? foregroundColor,
    TextStyle? textStyle,
  }) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>()!;
    final colors = design.designSystemColors;
    final typography = design.designSystemTypography;

    return TextButton.styleFrom(
      foregroundColor: foregroundColor ?? colors.primary,
      textStyle: textStyle ?? typography.labelLarge,
      padding: EdgeInsets.symmetric(
        horizontal: design.designSystemSpacing.md,
        vertical: design.designSystemSpacing.sm,
      ),
    );
  }

  /// Create consistent outlined button style
  static ButtonStyle getOutlinedButtonStyle(BuildContext context, {
    Color? foregroundColor,
    Color? sideColor,
  }) {
    final design = Theme.of(context).extension<DesignSystemThemeExtension>()!;
    final colors = design.designSystemColors;

    return OutlinedButton.styleFrom(
      foregroundColor: foregroundColor ?? colors.onSurface,
      side: BorderSide(color: sideColor ?? colors.border),
      padding: EdgeInsets.symmetric(
        horizontal: design.designSystemSpacing.lg,
        vertical: design.designSystemSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(design.designSystemRadius.md),
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
    return color.withValues(alpha: opacity);
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
    final spacing = getDesignSystemSpacing(context);

    switch (name) {
      case 'xxs':
        return spacing.xxs;
      case 'xs':
        return spacing.xs;
      case 'sm':
        return spacing.sm;
      case 'md':
        return spacing.md;
      case 'lg':
        return spacing.lg;
      case 'xl':
        return spacing.xl;
      case 'xxl':
        return spacing.xxl;
      case 'xxxl':
        return spacing.xxxl;
      case 'huge':
        return spacing.huge;
      default:
        return spacing.md;
    }
  }

  /// Get radius value by name
  static double getRadiusByName(BuildContext context, String name) {
    final radius = getDesignSystemRadius(context);

    switch (name) {
      case 'xxs':
        return radius.xxs;
      case 'xs':
        return radius.xs;
      case 'sm':
        return radius.sm;
      case 'md':
        return radius.md;
      case 'lg':
        return radius.lg;
      case 'xl':
        return radius.xl;
      case 'xxl':
        return radius.xxl;
      case 'circular':
        return radius.circular;
      default:
        return radius.md;
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