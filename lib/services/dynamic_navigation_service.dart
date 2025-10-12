import 'package:flutter/material.dart';
import 'dynamic_config_service.dart';

/// Service for managing dynamic navigation and routing
class DynamicNavigationService {
  static DynamicNavigationService? _instance;
  static DynamicNavigationService get instance => _instance ??= DynamicNavigationService._();

  DynamicNavigationService._();

  final DynamicConfigService _config = DynamicConfigService.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Map<String, WidgetBuilder> _routes = {};
  final List<String> _navigationHistory = [];
  String? _currentRoute;

  /// Initialize the navigation service
  Future<void> initialize() async {
    await _loadDynamicRoutes();
  }

  /// Load dynamic routes from configuration
  Future<void> _loadDynamicRoutes() async {
    // TODO: Load routes from remote configuration
    // For now, we'll use the default routes
    _routes = _getDefaultRoutes();
  }

  /// Get default routes
  Map<String, WidgetBuilder> _getDefaultRoutes() {
    return {
      '/': (context) => const Scaffold(
        body: Center(child: Text('Home - Dynamic Route')),
      ),
      '/discover': (context) => const Scaffold(
        body: Center(child: Text('Discover - Dynamic Route')),
      ),
      '/buds': (context) => const Scaffold(
        body: Center(child: Text('Buds - Dynamic Route')),
      ),
      '/library': (context) => const Scaffold(
        body: Center(child: Text('Library - Dynamic Route')),
      ),
      '/profile': (context) => const Scaffold(
        body: Center(child: Text('Profile - Dynamic Route')),
      ),
      '/chat': (context) => const Scaffold(
        body: Center(child: Text('Chat - Dynamic Route')),
      ),
      '/search': (context) => const Scaffold(
        body: Center(child: Text('Search - Dynamic Route')),
      ),
      '/settings': (context) => const Scaffold(
        body: Center(child: Text('Settings - Dynamic Route')),
      ),
    };
  }

  /// Get all available routes
  Map<String, WidgetBuilder> get routes => Map.from(_routes);

  /// Add a dynamic route
  void addRoute(String name, WidgetBuilder builder) {
    _routes[name] = builder;
  }

  /// Remove a dynamic route
  void removeRoute(String name) {
    _routes.remove(name);
  }

  /// Update routes with new configuration
  Future<void> updateRoutes(Map<String, WidgetBuilder> newRoutes) async {
    _routes = {
      ..._routes,
      ...newRoutes,
    };
  }

  /// Navigate to a route
  Future<T?> navigateTo<T extends Object?>(
    String routeName, {
    Object? arguments,
    bool replace = false,
    bool clearStack = false,
  }) async {
    if (!_routes.containsKey(routeName)) {
      debugPrint('Route $routeName not found');
      return null;
    }

    _addToHistory(routeName);

    if (clearStack) {
      return await navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(
        routeName,
        (route) => false,
        arguments: arguments,
      );
    } else if (replace) {
      return await navigatorKey.currentState?.pushReplacementNamed<T, dynamic>(
        routeName,
        arguments: arguments,
      );
    } else {
      return await navigatorKey.currentState?.pushNamed<T>(
        routeName,
        arguments: arguments,
      );
    }
  }

  /// Navigate back
  void goBack<T extends Object?>([T? result]) {
    navigatorKey.currentState?.pop<T>(result);
    _removeFromHistory();
  }

  /// Navigate to previous route in history
  Future<void> goBackToPrevious() async {
    if (_navigationHistory.length > 1) {
      _navigationHistory.removeLast(); // Remove current route
      final previousRoute = _navigationHistory.last;
      await navigateTo(previousRoute, replace: true);
    }
  }

  /// Add route to navigation history
  void _addToHistory(String routeName) {
    if (_currentRoute != null && _currentRoute != routeName) {
      _navigationHistory.add(_currentRoute!);
    }
    _currentRoute = routeName;
  }

  /// Remove route from navigation history
  void _removeFromHistory() {
    if (_navigationHistory.isNotEmpty) {
      _currentRoute = _navigationHistory.removeLast();
    } else {
      _currentRoute = null;
    }
  }

  /// Get navigation history
  List<String> get navigationHistory => List.from(_navigationHistory);

  /// Get current route
  String? get currentRoute => _currentRoute;

  /// Clear navigation history
  void clearHistory() {
    _navigationHistory.clear();
    _currentRoute = null;
  }

  /// Check if a route exists
  bool hasRoute(String routeName) {
    return _routes.containsKey(routeName);
  }

  /// Get route arguments
  T? getRouteArguments<T>() {
    return ModalRoute.of(navigatorKey.currentContext!)?.settings.arguments as T?;
  }

  /// Navigate with conditional logic
  Future<void> navigateConditionally(
    String routeName, {
    required bool condition,
    String? fallbackRoute,
    Object? arguments,
  }) async {
    if (condition) {
      await navigateTo(routeName, arguments: arguments);
    } else if (fallbackRoute != null) {
      await navigateTo(fallbackRoute, arguments: arguments);
    }
  }

  /// Navigate based on feature flags
  Future<void> navigateWithFeatureCheck(
    String routeName, {
    required String featureFlag,
    String? fallbackRoute,
    Object? arguments,
  }) async {
    final isFeatureEnabled = _config.isFeatureEnabled(featureFlag);
    await navigateConditionally(
      routeName,
      condition: isFeatureEnabled,
      fallbackRoute: fallbackRoute,
      arguments: arguments,
    );
  }

  /// Navigate based on user permissions
  Future<void> navigateWithPermissionCheck(
    String routeName, {
    required String permission,
    String? fallbackRoute,
    Object? arguments,
  }) async {
    // TODO: Implement permission checking
    const hasPermission = true; // Placeholder
    await navigateConditionally(
      routeName,
      condition: hasPermission,
      fallbackRoute: fallbackRoute,
      arguments: arguments,
    );
  }

  /// Navigate with analytics tracking
  Future<void> navigateWithAnalytics(
    String routeName, {
    Object? arguments,
    Map<String, dynamic>? analyticsData,
  }) async {
    // TODO: Track navigation analytics
    if (_config.isAnalyticsEnabled()) {
      debugPrint('Navigation analytics: $routeName - $analyticsData');
    }

    await navigateTo(routeName, arguments: arguments);
  }

  /// Get route configuration
  Map<String, dynamic> getRouteConfig(String routeName) {
    // TODO: Load route-specific configuration
    return {
      'requiresAuth': routeName != '/login' && routeName != '/register',
      'showBottomNav': !['/login', '/register', '/settings'].contains(routeName),
      'allowBack': routeName != '/',
    };
  }

  /// Check if route requires authentication
  bool requiresAuth(String routeName) {
    return getRouteConfig(routeName)['requiresAuth'] ?? false;
  }

  /// Check if route should show bottom navigation
  bool shouldShowBottomNav(String routeName) {
    return getRouteConfig(routeName)['showBottomNav'] ?? true;
  }

  /// Check if route allows back navigation
  bool allowsBack(String routeName) {
    return getRouteConfig(routeName)['allowBack'] ?? true;
  }

  /// Create dynamic route generator
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name ?? '/';

    if (_routes.containsKey(routeName)) {
      return MaterialPageRoute(
        builder: _routes[routeName]!,
        settings: settings,
      );
    }

    // Handle dynamic route patterns
    if (routeName.startsWith('/user/')) {
      final userId = routeName.split('/').last;
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('User Profile: $userId')),
          body: Center(child: Text('User Profile for: $userId')),
        ),
        settings: settings,
      );
    }

    if (routeName.startsWith('/track/')) {
      final trackId = routeName.split('/').last;
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Track Details')),
          body: Center(child: Text('Track Details for: $trackId')),
        ),
        settings: settings,
      );
    }

    // 404 route
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              Text('Route "$routeName" not found'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => navigateTo('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
      settings: settings,
    );
  }
}
