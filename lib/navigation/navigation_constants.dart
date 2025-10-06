import 'package:flutter/material.dart';

/// Navigation constants for the app
class NavigationConstants {
  // Route names
  static const String home = '/';
  static const String discover = '/discover';
  static const String library = '/library';
  static const String profile = '/profile';
  static const String chat = '/chat';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String login = '/login';
  static const String register = '/register';
  static const String onboarding = '/onboarding';

  // Navigation keys
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

  // Animation durations
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration tabSwitchDuration = Duration(milliseconds: 200);

  // Navigation bar configuration
  static const double navigationBarHeight = 80.0;
  static const double navigationBarIconSize = 24.0;

  // Default navigation constants
  static const double defaultBottomNavBarHeight = 80.0;
  static const EdgeInsetsGeometry defaultMargin = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  static const double defaultBorderRadius = 20.0;
  static const Color defaultUnselectedColor = Color(0xFF9E9E9E);
  static const double defaultElevation = 8.0;
  static const double defaultActiveIconSize = 28.0;
  static const double defaultIconSize = 24.0;
  static const double defaultItemSpacing = 12.0;

  // Icons
  static const IconData settingsIcon = Icons.settings_outlined;

  // Routes
  static const String settingsRoute = '/settings';

  // Private constructor to prevent instantiation
  NavigationConstants._();
}