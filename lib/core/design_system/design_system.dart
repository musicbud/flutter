/// MusicBud Design System
/// 
/// This file contains all design tokens for the MusicBud app including colors,
/// typography, spacing, shadows, and component styles based on the UI designs.
library;

import 'package:flutter/material.dart';

/// Color System
class MusicBudColors {
  MusicBudColors._();

  // Primary Colors - Red theme from UI designs
  static const Color primaryRed = Color(0xFFE91E63); // Main brand color
  static const Color primaryDark = Color(0xFFC2185B); // Darker red for gradients
  static const Color primaryLight = Color(0xFFF48FB1); // Lighter red for highlights
  
  // Secondary Colors
  static const Color accent = Color(0xFF03DAC6); // Cyan accent
  static const Color accentDark = Color(0xFF018786);
  
  // Background Colors - Dark theme based
  static const Color backgroundPrimary = Color(0xFF121212); // Main dark background
  static const Color backgroundSecondary = Color(0xFF1E1E1E); // Secondary surfaces
  static const Color backgroundTertiary = Color(0xFF2D2D2D); // Cards, elevated surfaces
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF); // Primary text on dark
  static const Color textSecondary = Color(0xFFB0B0B0); // Secondary text
  static const Color textHint = Color(0xFF757575); // Hint text, disabled
  static const Color textOnPrimary = Color(0xFFFFFFFF); // Text on primary color
  
  // Surface Colors
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFF424242);
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFFE0E0E0);
  
  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE91E63); // Using primary red for errors
  static const Color info = Color(0xFF2196F3);
  
  // Interactive Colors
  static const Color focus = Color(0xFFE91E63);
  static const Color pressed = Color(0xFFC2185B);
  static const Color disabled = Color(0xFF424242);
  static const Color disabledText = Color(0xFF757575);
  
  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color cardOverlay = Color(0x1AFFFFFF);
}

/// Typography System
class MusicBudTypography {
  MusicBudTypography._();

  // Font Family
  static const String fontFamily = 'Inter'; // Modern, readable font
  
  // Heading Styles
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5,
    color: MusicBudColors.textPrimary,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5,
    color: MusicBudColors.textPrimary,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.25,
    color: MusicBudColors.textPrimary,
  );
  
  static const TextStyle heading4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.25,
    color: MusicBudColors.textPrimary,
  );
  
  static const TextStyle heading5 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 0,
    color: MusicBudColors.textPrimary,
  );
  
  static const TextStyle heading6 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 0.15,
    color: MusicBudColors.textPrimary,
  );
  
  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.15,
    color: MusicBudColors.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.25,
    color: MusicBudColors.textPrimary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.35,
    letterSpacing: 0.4,
    color: MusicBudColors.textPrimary,
  );
  
  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
    color: MusicBudColors.textPrimary,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.35,
    letterSpacing: 0.5,
    color: MusicBudColors.textPrimary,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.35,
    letterSpacing: 0.5,
    color: MusicBudColors.textPrimary,
  );
}

/// Spacing System
class MusicBudSpacing {
  MusicBudSpacing._();

  // Base spacing unit (4px)
  static const double unit = 4.0;
  
  // Spacing Scale
  static const double xs = unit * 1; // 4px
  static const double sm = unit * 2; // 8px
  static const double md = unit * 4; // 16px
  static const double lg = unit * 6; // 24px
  static const double xl = unit * 8; // 32px
  static const double xxl = unit * 12; // 48px
  static const double xxxl = unit * 16; // 64px
  
  // Border Radius Scale
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  static const double radiusRound = 9999.0; // For fully rounded elements
  
  // Elevation/Shadow Scale
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation3 = 4.0;
  static const double elevation4 = 8.0;
  static const double elevation5 = 12.0;
}

/// Shadow System
class MusicBudShadows {
  MusicBudShadows._();

  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];
  
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];
}

/// Animation System
class MusicBudAnimations {
  MusicBudAnimations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeIn = Curves.easeIn;
}

/// Component Styles
class MusicBudComponents {
  MusicBudComponents._();

  // Button Styles
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    backgroundColor: MusicBudColors.primaryRed,
    foregroundColor: MusicBudColors.textOnPrimary,
    elevation: 0,
    padding: const EdgeInsets.symmetric(
      horizontal: MusicBudSpacing.lg,
      vertical: MusicBudSpacing.md,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
    ),
    textStyle: MusicBudTypography.labelLarge,
  );
  
  static ButtonStyle get secondaryButton => OutlinedButton.styleFrom(
    foregroundColor: MusicBudColors.primaryRed,
    side: const BorderSide(color: MusicBudColors.primaryRed),
    padding: const EdgeInsets.symmetric(
      horizontal: MusicBudSpacing.lg,
      vertical: MusicBudSpacing.md,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
    ),
    textStyle: MusicBudTypography.labelLarge,
  );
  
  // Card Style
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: MusicBudColors.backgroundTertiary,
    borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
    boxShadow: MusicBudShadows.medium,
  );
}