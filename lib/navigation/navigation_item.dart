import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// Represents a navigation item in the app
class NavigationItem extends Equatable {
  const NavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    this.badgeCount = 0,
    this.isEnabled = true,
    this.pageBuilder,
  });

  /// The label text for the navigation item
  final String label;

  /// The icon to display when the item is not selected
  final IconData icon;

  /// The icon to display when the item is selected
  final IconData activeIcon;

  /// The route name this item navigates to
  final String route;

  /// Optional badge count to show notifications
  final int badgeCount;

  /// Whether this navigation item is enabled
  final bool isEnabled;

  /// Optional page builder for navigation
  final Widget Function(BuildContext)? pageBuilder;

  /// Creates a copy of this NavigationItem with the given fields replaced
  NavigationItem copyWith({
    String? label,
    IconData? icon,
    IconData? activeIcon,
    String? route,
    int? badgeCount,
    bool? isEnabled,
    Widget Function(BuildContext)? pageBuilder,
  }) {
    return NavigationItem(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      route: route ?? this.route,
      badgeCount: badgeCount ?? this.badgeCount,
      isEnabled: isEnabled ?? this.isEnabled,
      pageBuilder: pageBuilder ?? this.pageBuilder,
    );
  }

  /// Whether this item has a badge
  bool get hasBadge => badgeCount > 0;

  @override
  List<Object?> get props => [
    label,
    icon,
    activeIcon,
    route,
    badgeCount,
    isEnabled,
    pageBuilder,
  ];
}

/// Extension methods for NavigationItem
extension NavigationItemExtension on NavigationItem {
  /// Gets the appropriate icon based on selection state
  IconData getIcon(bool isSelected) {
    return isSelected ? activeIcon : icon;
  }

  /// Creates a BottomNavigationBarItem from this NavigationItem
  BottomNavigationBarItem toBottomNavigationBarItem({
    required bool isSelected,
    required BuildContext context,
  }) {
    return BottomNavigationBarItem(
      icon: badgeCount > 0
          ? Badge(
              label: Text(badgeCount.toString()),
              child: Icon(getIcon(isSelected)),
            )
          : Icon(getIcon(isSelected)),
      label: label,
    );
  }
}