/// Enhanced navigation item class with type safety and permission checking
import 'package:flutter/material.dart';

class NavigationItem {
  final IconData icon;
  final String label;
  final WidgetBuilder pageBuilder;
  final String? route;
  final bool requiresAuth;
  final List<String>? requiredPermissions;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.pageBuilder,
    this.route,
    this.requiresAuth = false,
    this.requiredPermissions,
  });

  /// Create a copy of this navigation item with modified values
  NavigationItem copyWith({
    IconData? icon,
    String? label,
    WidgetBuilder? pageBuilder,
    String? route,
    bool? requiresAuth,
    List<String>? requiredPermissions,
  }) {
    return NavigationItem(
      icon: icon ?? this.icon,
      label: label ?? this.label,
      pageBuilder: pageBuilder ?? this.pageBuilder,
      route: route ?? this.route,
      requiresAuth: requiresAuth ?? this.requiresAuth,
      requiredPermissions: requiredPermissions ?? this.requiredPermissions,
    );
  }

  /// Check if user has required permissions for this navigation item
  bool hasRequiredPermissions(List<String>? userPermissions) {
    if (requiredPermissions == null || requiredPermissions!.isEmpty) {
      return true;
    }
    if (userPermissions == null || userPermissions.isEmpty) {
      return false;
    }
    return requiredPermissions!.any((permission) => userPermissions.contains(permission));
  }

  @override
  String toString() {
    return 'NavigationItem(icon: $icon, label: $label, route: $route, requiresAuth: $requiresAuth)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationItem &&
        other.icon == icon &&
        other.label == label &&
        other.route == route &&
        other.requiresAuth == requiresAuth;
  }

  @override
  int get hashCode {
    return Object.hash(icon, label, route, requiresAuth);
  }
}