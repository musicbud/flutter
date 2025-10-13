import 'package:flutter/material.dart';

/// Unified Navigation Routes and Constants
/// 
/// This file consolidates all navigation-related constants, routes,
/// and configuration to provide a single source of truth for app navigation.
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // ===========================================================================
  // ROUTE CONSTANTS
  // ===========================================================================

  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String onboarding = '/onboarding';
  
  // Main navigation routes
  static const String home = '/home';
  static const String discover = '/discover';
  static const String library = '/library';
  static const String search = '/search';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String buds = '/buds';
  static const String settings = '/settings';
  
  // Feature routes
  static const String topTracks = '/top-tracks';
  static const String connectServices = '/connect-services';
  static const String editProfile = '/edit-profile';
  
  // Detail pages
  static const String artistDetails = '/artist-details';
  static const String genreDetails = '/genre-details';
  static const String trackDetails = '/track-details';
  
  // Spotify integration
  static const String playedTracksMap = '/played-tracks-map';
  static const String spotifyControl = '/spotify-control';
  
  // Development/showcase
  static const String uiShowcase = '/ui-showcase';
  static const String settingsOld = '/settings-old';

  // ===========================================================================
  // NAVIGATION CONFIGURATION
  // ===========================================================================

  // Navigation bar configuration
  static const double navigationBarHeight = 80.0;
  static const double navigationBarIconSize = 24.0;
  static const double navigationBarActiveIconSize = 28.0;
  static const double navigationBarBorderRadius = 20.0;
  static const double navigationBarElevation = 8.0;
  
  // Navigation spacing
  static const EdgeInsets navigationBarMargin = EdgeInsets.symmetric(
    horizontal: 16.0, 
    vertical: 8.0,
  );
  static const double navigationBarItemSpacing = 12.0;

  // Animation durations
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration tabSwitchDuration = Duration(milliseconds: 200);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);

  // Navigation keys
  static final GlobalKey<NavigatorState> rootNavigatorKey = 
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellNavigatorKey = 
      GlobalKey<NavigatorState>();

  // ===========================================================================
  // NAVIGATION ICONS
  // ===========================================================================

  static const IconData homeIcon = Icons.home_outlined;
  static const IconData searchIcon = Icons.search;
  static const IconData discoverIcon = Icons.explore_outlined;
  static const IconData chatIcon = Icons.chat_bubble_outline;
  static const IconData libraryIcon = Icons.library_music_outlined;
  static const IconData profileIcon = Icons.person_outline;
  static const IconData settingsIcon = Icons.settings_outlined;
  static const IconData budsIcon = Icons.people_outline;

  // ===========================================================================
  // NAVIGATION ITEMS CONFIGURATION
  // ===========================================================================

  /// Main navigation items with their properties
  static List<NavigationItem> get mainNavigationItems => [
    NavigationItem(
      route: home,
      icon: homeIcon,
      label: 'Home',
      index: 0,
    ),
    NavigationItem(
      route: search,
      icon: searchIcon,
      label: 'Search',
      index: 1,
    ),
    NavigationItem(
      route: discover,
      icon: discoverIcon,
      label: 'Discover',
      index: 2,
    ),
    NavigationItem(
      route: chat,
      icon: chatIcon,
      label: 'Chat',
      index: 3,
    ),
    NavigationItem(
      route: library,
      icon: libraryIcon,
      label: 'Library',
      index: 4,
    ),
  ];

  /// Secondary navigation items (drawer/settings)
  static List<NavigationItem> get secondaryNavigationItems => [
    NavigationItem(
      route: profile,
      icon: profileIcon,
      label: 'Profile',
      index: 5,
    ),
    NavigationItem(
      route: buds,
      icon: budsIcon,
      label: 'Buds',
      index: 6,
    ),
    NavigationItem(
      route: settings,
      icon: settingsIcon,
      label: 'Settings',
      index: 7,
    ),
  ];

  // ===========================================================================
  // UTILITY METHODS
  // ===========================================================================

  /// Check if a route is a main navigation route
  static bool isMainNavigationRoute(String route) {
    return mainNavigationItems.any((item) => item.route == route);
  }

  /// Get navigation item by route
  static NavigationItem? getNavigationItemByRoute(String route) {
    final allItems = [...mainNavigationItems, ...secondaryNavigationItems];
    try {
      return allItems.firstWhere((item) => item.route == route);
    } catch (e) {
      return null;
    }
  }

  /// Get index of route in main navigation
  static int getMainNavigationIndex(String route) {
    final index = mainNavigationItems.indexWhere((item) => item.route == route);
    return index != -1 ? index : 0; // Default to home if not found
  }

  /// Check if route requires authentication
  static bool requiresAuth(String route) {
    return ![login, register, onboarding].contains(route);
  }

  /// Get route display name
  static String getRouteDisplayName(String route) {
    final item = getNavigationItemByRoute(route);
    return item?.label ?? route.replaceAll('/', '').replaceAll('-', ' ');
  }
}

/// Navigation item data class
class NavigationItem {
  final String route;
  final IconData icon;
  final String label;
  final int index;
  final bool requiresAuth;

  const NavigationItem({
    required this.route,
    required this.icon,
    required this.label,
    required this.index,
    this.requiresAuth = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationItem &&
          runtimeType == other.runtimeType &&
          route == other.route;

  @override
  int get hashCode => route.hashCode;

  @override
  String toString() => 'NavigationItem(route: $route, label: $label, index: $index)';
}