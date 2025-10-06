import 'package:flutter/material.dart';
import 'navigation_constants.dart';

/// Mixin for base navigation functionality
mixin BaseNavigationMixin {
  /// Gets the decoration for navigation items
  BoxDecoration getNavigationItemDecoration({
    required bool isSelected,
    required Color selectedColor,
    required double borderRadius,
  }) {
    return BoxDecoration(
      color: isSelected ? selectedColor.withValues(alpha: 0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      border: isSelected
          ? Border.all(
              color: selectedColor.withValues(alpha: 0.3),
              width: 1.5,
            )
          : null,
    );
  }
}

/// Mixin for navigation functionality
mixin NavigationMixin<T extends StatefulWidget> on State<T> {
  /// Navigate to a named route
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(context).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Navigate to a named route and remove all previous routes
  Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
    required RoutePredicate predicate,
  }) {
    return Navigator.of(context).pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  /// Replace current route with a named route
  Future<T?> pushReplacementNamed<T, TO>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.of(context).pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Pop current route
  void pop<T>([T? result]) {
    Navigator.of(context).pop<T>(result);
  }

  /// Pop until a specific route
  void popUntil(RoutePredicate predicate) {
    Navigator.of(context).popUntil(predicate);
  }

  /// Check if can pop
  bool canPop() {
    return Navigator.of(context).canPop();
  }

  /// Navigate to home
  void goToHome() {
    pushNamedAndRemoveUntil(
      NavigationConstants.home,
      predicate: (route) => false,
    );
  }

  /// Navigate to login
  void goToLogin() {
    pushNamedAndRemoveUntil(
      NavigationConstants.login,
      predicate: (route) => false,
    );
  }
}

/// Mixin for bottom navigation functionality
mixin BottomNavigationMixin<T extends StatefulWidget> on State<T> {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    if (_currentIndex != value) {
      setState(() => _currentIndex = value);
      onTabChanged(value);
    }
  }

  /// Override this method to handle tab changes
  void onTabChanged(int index) {}

  /// Handle bottom navigation tap
  void onBottomNavTap(int index) {
    currentIndex = index;
  }
}

/// Mixin for route-aware widgets
mixin RouteAwareMixin<T extends StatefulWidget> on State<T> implements RouteAware {
  RouteObserver<ModalRoute<void>>? _routeObserver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver = RouteObserver<ModalRoute<void>>();
    _routeObserver!.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {}

  @override
  void didPop() {}

  @override
  void didPopNext() {}

  @override
  void didPushNext() {}
}