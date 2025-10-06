import 'package:flutter/material.dart';
import 'navigation_constants.dart';
import 'navigation_item.dart';
import 'navigation_items.dart';

/// Base mixin for navigation components providing common functionality
mixin BaseNavigationMixin {
  /// Get themed colors based on current theme and selection state
  NavigationColors getThemedColors(BuildContext context, bool isSelected) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return NavigationColors(
      background: isDark ? const Color.fromARGB(200, 20, 20, 20) : Colors.white,
      selected: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
      unselected: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
      surface: theme.colorScheme.surface,
      onSurface: theme.colorScheme.onSurface,
    );
  }

  /// Create consistent navigation item decoration
  BoxDecoration getNavigationItemDecoration({
    required bool isSelected,
    required Color selectedColor,
    double borderRadius = NavigationConstants.defaultBorderRadius,
  }) {
    return BoxDecoration(
      color: isSelected ? selectedColor.withOpacity(0.2) : Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      border: isSelected
          ? Border.all(
              color: selectedColor.withOpacity(0.3),
              width: 1,
            )
          : null,
    );
  }

  /// Create consistent icon widget for navigation items
  Widget buildNavigationIcon({
    required IconData icon,
    required bool isSelected,
    required Color color,
    double size = NavigationConstants.defaultIconSize,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: getNavigationItemDecoration(isSelected: isSelected, selectedColor: color),
      child: Icon(
        icon,
        size: isSelected ? NavigationConstants.defaultActiveIconSize : size,
        color: color,
      ),
    );
  }

  /// Create consistent text style for navigation items
  TextStyle getNavigationTextStyle({
    required bool isSelected,
    required Color color,
    double fontSize = 12,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      letterSpacing: isSelected ? 0.5 : 0.3,
      color: color,
    );
  }
}

/// Colors used in navigation components
class NavigationColors {
  final Color background;
  final Color selected;
  final Color unselected;
  final Color surface;
  final Color onSurface;

  const NavigationColors({
    required this.background,
    required this.selected,
    required this.unselected,
    required this.surface,
    required this.onSurface,
  });
}

/// Navigation state management mixin
mixin NavigationStateMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Set loading state
  void setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
        if (loading) _error = null; // Clear error when loading
      });
    }
  }

  /// Set error state
  void setError(String? error) {
    if (mounted) {
      setState(() {
        _error = error;
        if (error != null) _isLoading = false; // Clear loading when error occurs
      });
    }
  }

  /// Clear both loading and error states
  void clearStates() {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _error = null;
      });
    }
  }

  /// Handle navigation with error handling
  Future<void> handleNavigation({
    required VoidCallback navigationAction,
    VoidCallback? onError,
  }) async {
    setLoading(true);
    try {
      await Future.microtask(navigationAction);
      clearStates();
    } catch (e) {
      setError(e.toString());
      onError?.call();
    }
  }
}

/// Navigation animation mixin for consistent animations
mixin NavigationAnimationMixin {
  /// Create fade transition animation
  static Widget createFadeTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Create slide transition animation
  static Widget createSlideTransition({
    required Animation<double> animation,
    required Widget child,
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: end,
      ).animate(animation),
      child: child,
    );
  }

  /// Create scale transition animation
  static Widget createScaleTransition({
    required Animation<double> animation,
    required Widget child,
    double begin = 0.8,
    double end = 1.0,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: begin,
        end: end,
      ).animate(animation),
      child: child,
    );
  }
}

/// Navigation utility methods
class NavigationUtils {
  /// Get navigation item by index safely
  static NavigationItem? getNavigationItemByIndex(int index) {
    if (index < 0 || index >= mainNavigationItems.length) {
      return null;
    }
    return mainNavigationItems[index];
  }

  /// Find navigation item index by label
  static int findNavigationIndexByLabel(String label) {
    return mainNavigationItems.indexWhere((item) => item.label == label);
  }

  /// Check if navigation item exists by label
  static bool navigationItemExists(String label) {
    return findNavigationIndexByLabel(label) != -1;
  }

  /// Get additional navigation items by section
  static List<NavigationItem> getAdditionalNavigationItemsBySection({
    required int startIndex,
    required int count,
  }) {
    final endIndex = (startIndex + count).clamp(0, additionalNavigationItems.length);
    return additionalNavigationItems.sublist(startIndex, endIndex);
  }

  /// Create route map from navigation items for easy lookup
  static Map<String, NavigationItem> createRouteMap() {
    final Map<String, NavigationItem> routeMap = {};

    // Add main navigation items (using index as route for simplicity)
    for (int i = 0; i < mainNavigationItems.length; i++) {
      routeMap['/$i'] = mainNavigationItems[i];
    }

    return routeMap;
  }
}