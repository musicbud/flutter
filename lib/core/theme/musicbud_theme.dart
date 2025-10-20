import 'package:flutter/material.dart';
import '../design_system/design_system.dart';

class MusicBudTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: MusicBudColors.primaryRed,
      secondary: MusicBudColors.accent,
      tertiary: MusicBudColors.accentDark,
      primaryContainer: MusicBudColors.primaryLight,
      error: MusicBudColors.error,
      errorContainer: MusicBudColors.error,
      surface: MusicBudColors.surface,
      onPrimary: MusicBudColors.textOnPrimary,
      onSurface: MusicBudColors.onSurface,
      onSecondary: MusicBudColors.textOnPrimary,
      surfaceContainerHighest: MusicBudColors.surfaceVariant,
      onSurfaceVariant: MusicBudColors.onSurfaceVariant,
      outline: MusicBudColors.disabled,
      outlineVariant: MusicBudColors.disabledText,
    ),
    scaffoldBackgroundColor: MusicBudColors.backgroundPrimary,
    canvasColor: MusicBudColors.backgroundSecondary,
    cardColor: MusicBudColors.backgroundTertiary,
    dividerColor: MusicBudColors.disabled,
    focusColor: MusicBudColors.focus,
    hoverColor: MusicBudColors.focus.withValues(alpha: 0.08),
    highlightColor: MusicBudColors.focus.withValues(alpha: 0.12),
    splashColor: MusicBudColors.focus.withValues(alpha: 0.12),
    unselectedWidgetColor: MusicBudColors.disabled,
    disabledColor: MusicBudColors.disabled,
    buttonTheme: const ButtonThemeData(
      buttonColor: MusicBudColors.primaryRed,
      disabledColor: MusicBudColors.disabled,
    ),
    textTheme: const TextTheme(
      headlineLarge: MusicBudTypography.heading1,
      headlineMedium: MusicBudTypography.heading2,
      headlineSmall: MusicBudTypography.heading3,
      titleLarge: MusicBudTypography.heading4,
      titleMedium: MusicBudTypography.heading5,
      titleSmall: MusicBudTypography.heading6,
      bodyLarge: MusicBudTypography.bodyLarge,
      bodyMedium: MusicBudTypography.bodyMedium,
      bodySmall: MusicBudTypography.bodySmall,
      labelLarge: MusicBudTypography.labelLarge,
      labelMedium: MusicBudTypography.labelMedium,
      labelSmall: MusicBudTypography.labelSmall,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: MusicBudTypography.heading4,
      iconTheme: IconThemeData(
        color: MusicBudColors.textPrimary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: MusicBudComponents.primaryButton,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: MusicBudComponents.secondaryButton,
    ),
    cardTheme: CardThemeData(
      color: MusicBudColors.backgroundTertiary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: MusicBudSpacing.sm,
        vertical: MusicBudSpacing.xs,
      ),
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: MusicBudColors.backgroundTertiary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
        borderSide: const BorderSide(
          color: MusicBudColors.primaryRed,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: MusicBudSpacing.lg,
        vertical: MusicBudSpacing.md,
      ),
      hintStyle: MusicBudTypography.bodyMedium.copyWith(
        color: MusicBudColors.textHint,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: MusicBudColors.backgroundTertiary,
      selectedItemColor: MusicBudColors.primaryRed,
      unselectedItemColor: MusicBudColors.textSecondary,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: MusicBudColors.backgroundTertiary,
      selectedIconTheme: IconThemeData(
        color: MusicBudColors.primaryRed,
      ),
      unselectedIconTheme: IconThemeData(
        color: MusicBudColors.textSecondary,
      ),
      selectedLabelTextStyle: MusicBudTypography.labelSmall,
      unselectedLabelTextStyle: MusicBudTypography.labelSmall,
    ),
    iconTheme: const IconThemeData(
      color: MusicBudColors.textPrimary,
      size: 24,
    ),
    primaryIconTheme: const IconThemeData(
      color: MusicBudColors.textOnPrimary,
      size: 24,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: MusicBudColors.primaryRed,
      secondary: MusicBudColors.accent,
      tertiary: MusicBudColors.accentDark,
      primaryContainer: MusicBudColors.primaryDark,
      error: MusicBudColors.error,
      errorContainer: MusicBudColors.error,
      surface: MusicBudColors.surface,
      onPrimary: MusicBudColors.textOnPrimary,
      onSurface: MusicBudColors.onSurface,
      onSecondary: MusicBudColors.textOnPrimary,
      surfaceContainerHighest: MusicBudColors.surfaceVariant,
      onSurfaceVariant: MusicBudColors.onSurfaceVariant,
      outline: MusicBudColors.disabled,
      outlineVariant: MusicBudColors.disabledText,
    ),
    scaffoldBackgroundColor: MusicBudColors.backgroundPrimary,
    canvasColor: MusicBudColors.backgroundSecondary,
    cardColor: MusicBudColors.backgroundTertiary,
    dividerColor: MusicBudColors.disabled,
    focusColor: MusicBudColors.focus,
    hoverColor: MusicBudColors.focus.withValues(alpha: 0.08),
    highlightColor: MusicBudColors.focus.withValues(alpha: 0.12),
    splashColor: MusicBudColors.focus.withValues(alpha: 0.12),
    unselectedWidgetColor: MusicBudColors.disabled,
    disabledColor: MusicBudColors.disabled,
    buttonTheme: const ButtonThemeData(
      buttonColor: MusicBudColors.primaryRed,
      disabledColor: MusicBudColors.disabled,
    ),
    textTheme: const TextTheme(
      headlineLarge: MusicBudTypography.heading1,
      headlineMedium: MusicBudTypography.heading2,
      headlineSmall: MusicBudTypography.heading3,
      titleLarge: MusicBudTypography.heading4,
      titleMedium: MusicBudTypography.heading5,
      titleSmall: MusicBudTypography.heading6,
      bodyLarge: MusicBudTypography.bodyLarge,
      bodyMedium: MusicBudTypography.bodyMedium,
      bodySmall: MusicBudTypography.bodySmall,
      labelLarge: MusicBudTypography.labelLarge,
      labelMedium: MusicBudTypography.labelMedium,
      labelSmall: MusicBudTypography.labelSmall,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: MusicBudTypography.heading4,
      iconTheme: IconThemeData(
        color: MusicBudColors.textPrimary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: MusicBudComponents.primaryButton,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: MusicBudComponents.secondaryButton,
    ),
    cardTheme: CardThemeData(
      color: MusicBudColors.backgroundTertiary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: MusicBudSpacing.sm,
        vertical: MusicBudSpacing.xs,
      ),
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: MusicBudColors.backgroundTertiary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
        borderSide: const BorderSide(
          color: MusicBudColors.primaryRed,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: MusicBudSpacing.lg,
        vertical: MusicBudSpacing.md,
      ),
      hintStyle: MusicBudTypography.bodyMedium.copyWith(
        color: MusicBudColors.textHint,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: MusicBudColors.backgroundTertiary,
      selectedItemColor: MusicBudColors.primaryRed,
      unselectedItemColor: MusicBudColors.textSecondary,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: MusicBudColors.backgroundTertiary,
      selectedIconTheme: IconThemeData(
        color: MusicBudColors.primaryRed,
      ),
      unselectedIconTheme: IconThemeData(
        color: MusicBudColors.textSecondary,
      ),
      selectedLabelTextStyle: MusicBudTypography.labelSmall,
      unselectedLabelTextStyle: MusicBudTypography.labelSmall,
    ),
    iconTheme: const IconThemeData(
      color: MusicBudColors.textPrimary,
      size: 24,
    ),
    primaryIconTheme: const IconThemeData(
      color: MusicBudColors.textOnPrimary,
      size: 24,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: MusicBudColors.textPrimary,
      unselectedLabelColor: MusicBudColors.textSecondary,
      labelStyle: MusicBudTypography.labelLarge,
      unselectedLabelStyle: MusicBudTypography.labelMedium,
      indicatorColor: MusicBudColors.primaryRed,
      dividerColor: Colors.transparent,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return MusicBudColors.primaryRed;
        }
        return MusicBudColors.disabled;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return MusicBudColors.primaryRed.withValues(alpha: 0.5);
        }
        return MusicBudColors.backgroundTertiary;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: MusicBudColors.primaryRed,
      linearTrackColor: MusicBudColors.backgroundTertiary,
      circularTrackColor: MusicBudColors.backgroundTertiary,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: MusicBudColors.backgroundTertiary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
      ),
      titleTextStyle: MusicBudTypography.heading5,
      contentTextStyle: MusicBudTypography.bodyMedium,
      actionsPadding: const EdgeInsets.all(MusicBudSpacing.md),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: MusicBudColors.backgroundTertiary,
      contentTextStyle: MusicBudTypography.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MusicBudSpacing.radiusMd),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 8,
    ),
  );
}