import 'package:flutter/material.dart';
import 'navigation_constants.dart';
import 'navigation_item.dart';

/// Main navigation items for the bottom navigation bar
const List<NavigationItem> mainNavigationItems = [
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
const List<NavigationItem> secondaryNavigationItems = [
  NavigationItem(
    label: 'Search',
    icon: Icons.search_outlined,
    activeIcon: Icons.search,
    route: NavigationConstants.search,
  ),
  NavigationItem(
    label: 'Buds',
    icon: NavigationConstants.budsIcon,
    activeIcon: Icons.people,
    route: NavigationConstants.buds,
  ),
  NavigationItem(
    label: 'Settings',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    route: NavigationConstants.settings,
  ),
  NavigationItem(
    label: 'Login',
    icon: Icons.login_outlined,
    activeIcon: Icons.login,
    route: NavigationConstants.login,
  ),
  NavigationItem(
    label: 'Register',
    icon: Icons.person_add_outlined,
    activeIcon: Icons.person_add,
    route: NavigationConstants.register,
  ),
  NavigationItem(
    label: 'Onboarding',
    icon: Icons.info_outline,
    activeIcon: Icons.info,
    route: NavigationConstants.onboarding,
  ),
  NavigationItem(
    label: 'Connect Services',
    icon: Icons.link_outlined,
    activeIcon: Icons.link,
    route: NavigationConstants.connectServices,
  ),
  NavigationItem(
    label: 'Top Tracks',
    icon: Icons.trending_up_outlined,
    activeIcon: Icons.trending_up,
    route: NavigationConstants.topTracks,
  ),
  NavigationItem(
    label: 'Artist Details',
    icon: Icons.mic_outlined,
    activeIcon: Icons.mic,
    route: NavigationConstants.artistDetails,
  ),
  NavigationItem(
    label: 'Genre Details',
    icon: Icons.category_outlined,
    activeIcon: Icons.category,
    route: NavigationConstants.genreDetails,
  ),
  NavigationItem(
    label: 'Track Details',
    icon: Icons.music_note_outlined,
    activeIcon: Icons.music_note,
    route: NavigationConstants.trackDetails,
  ),
  NavigationItem(
    label: 'Played Tracks Map',
    icon: Icons.map_outlined,
    activeIcon: Icons.map,
    route: NavigationConstants.playedTracksMap,
  ),
  NavigationItem(
    label: 'Spotify Control',
    icon: Icons.play_circle_outlined,
    activeIcon: Icons.play_circle,
    route: NavigationConstants.spotifyControl,
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