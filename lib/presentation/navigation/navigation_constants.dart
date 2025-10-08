import 'package:flutter/material.dart';

class NavigationConstants {
  // Navigation dimensions
  static const double defaultAppBarHeight = 56.0;
  static const double defaultBottomNavBarHeight = 90.0;
  static const double defaultDrawerWidth = 300.0;
  static const double defaultBorderRadius = 30.0;
  static const double defaultIconSize = 24.0;
  static const double defaultActiveIconSize = 26.0;

  // Navigation spacing
  static const EdgeInsets defaultMargin = EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  static const EdgeInsets defaultPadding = EdgeInsets.all(16);
  static const double defaultItemSpacing = 8.0;

  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 200);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);

  // Navigation z-index/elevation
  static const double defaultElevation = 0.0;
  static const double modalElevation = 8.0;

  // Default colors (fallback values)
  static const String defaultAppTitle = 'MusicBud';
  static const Color defaultBackgroundColor = Color.fromARGB(200, 20, 20, 20);
  static const Color defaultSelectedColor = Color.fromARGB(255, 255, 255, 255);
  static const Color defaultUnselectedColor = Color.fromARGB(153, 255, 255, 255); // 0.6 alpha

  // Navigation sections
  static const String mainNavigationSection = 'MAIN NAVIGATION';
  static const String authPagesSection = 'Auth Pages';
  static const String onboardingSection = 'Onboarding Pages';
  static const String otherPagesSection = 'Other Pages';

  // Navigation routes (for backward compatibility)
  static const String homeRoute = '/home';
  static const String searchRoute = '/search';
  static const String discoverRoute = '/discover';
  static const String chatRoute = '/chat';
  static const String libraryRoute = '/library';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String eventsRoute = '/events';
  static const String budsRoute = '/buds';
  static const String adminRoute = '/admin';

  // Icon data constants
  static const IconData homeIcon = Icons.home_outlined;
  static const IconData searchIcon = Icons.search;
  static const IconData discoverIcon = Icons.explore_outlined;
  static const IconData chatIcon = Icons.chat_bubble_outline;
  static const IconData libraryIcon = Icons.library_music_outlined;
  static const IconData profileIcon = Icons.person_outline;
  static const IconData settingsIcon = Icons.settings_outlined;
  static const IconData eventsIcon = Icons.event_outlined;
  static const IconData budsIcon = Icons.people_outline;
  static const IconData adminIcon = Icons.admin_panel_settings_outlined;
}

/// Navigation configuration class for type-safe configuration
class NavigationConfig {
  final String title;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool enableBlur;
  final bool enableGradient;

  const NavigationConfig({
    this.title = NavigationConstants.defaultAppTitle,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.elevation,
    this.margin,
    this.borderRadius,
    this.enableBlur = true,
    this.enableGradient = true,
  });

  /// Create a copy of this config with modified values
  NavigationConfig copyWith({
    String? title,
    Color? backgroundColor,
    Color? selectedColor,
    Color? unselectedColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    bool? enableBlur,
    bool? enableGradient,
  }) {
    return NavigationConfig(
      title: title ?? this.title,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedColor: selectedColor ?? this.selectedColor,
      unselectedColor: unselectedColor ?? this.unselectedColor,
      elevation: elevation ?? this.elevation,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      enableBlur: enableBlur ?? this.enableBlur,
      enableGradient: enableGradient ?? this.enableGradient,
    );
  }
}