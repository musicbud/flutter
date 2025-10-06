import 'package:flutter/material.dart';
import 'navigation_constants.dart';
import 'navigation_item.dart';

/// Main navigation items for the bottom navigation bar
final List<NavigationItem> mainNavigationItems = [
  NavigationItem(
    label: 'Home',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    route: NavigationConstants.home,
  ),
  NavigationItem(
    label: 'Discover',
    icon: Icons.explore_outlined,
    activeIcon: Icons.explore,
    route: NavigationConstants.discover,
  ),
  NavigationItem(
    label: 'Library',
    icon: Icons.library_music_outlined,
    activeIcon: Icons.library_music,
    route: NavigationConstants.library,
  ),
  NavigationItem(
    label: 'Chat',
    icon: Icons.chat_outlined,
    activeIcon: Icons.chat,
    route: NavigationConstants.chat,
  ),
  NavigationItem(
    label: 'Profile',
    icon: Icons.person_outlined,
    activeIcon: Icons.person,
    route: NavigationConstants.profile,
  ),
];

/// Additional navigation items for drawer or other menus
final List<NavigationItem> secondaryNavigationItems = [
  NavigationItem(
    label: 'Search',
    icon: Icons.search_outlined,
    activeIcon: Icons.search,
    route: NavigationConstants.search,
  ),
  NavigationItem(
    label: 'Settings',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    route: NavigationConstants.settings,
  ),
];

/// Get navigation item by route
NavigationItem? getNavigationItemByRoute(String route) {
  return mainNavigationItems.firstWhere(
    (item) => item.route == route,
    orElse: () => secondaryNavigationItems.firstWhere(
      (item) => item.route == route,
      orElse: () => throw ArgumentError('Navigation item not found for route: $route'),
    ),
  );
}

/// Get navigation item index by route
int? getNavigationItemIndex(String route) {
  final index = mainNavigationItems.indexWhere((item) => item.route == route);
  return index >= 0 ? index : null;
}

/// Check if route is a main navigation route
bool isMainNavigationRoute(String route) {
  return mainNavigationItems.any((item) => item.route == route);
}

/// Check if route is a secondary navigation route
bool isSecondaryNavigationRoute(String route) {
  return secondaryNavigationItems.any((item) => item.route == route);
}