import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A pull-to-refresh wrapper for list content
///
/// Wraps any scrollable widget with pull-to-refresh functionality.
///
/// Example:
/// ```dart
/// PullToRefreshWrapper(
///   onRefresh: () async {
///     await fetchNewData();
///   },
///   child: ListView.builder(...),
/// )
/// ```
class PullToRefreshWrapper extends StatelessWidget {
  /// The scrollable child widget
  final Widget child;

  /// Refresh callback (must be async)
  final Future<void> Function() onRefresh;

  /// Color of the refresh indicator
  final Color? color;

  /// Background color
  final Color? backgroundColor;

  /// Stroke width of the indicator
  final double strokeWidth;

  const PullToRefreshWrapper({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? DesignSystem.primary,
      backgroundColor: backgroundColor ?? DesignSystem.surface,
      strokeWidth: strokeWidth,
      child: child,
    );
  }
}

/// A custom refresh indicator with a more modern design
class ModernPullToRefresh extends StatelessWidget {
  /// The scrollable child widget
  final Widget child;

  /// Refresh callback (must be async)
  final Future<void> Function() onRefresh;

  /// Custom refresh message
  final String? refreshMessage;

  const ModernPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.refreshMessage,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: DesignSystem.primary,
      backgroundColor: DesignSystem.surfaceContainer,
      strokeWidth: 3.0,
      displacement: 40,
      child: child,
    );
  }
}

/// A scrollable widget that can be refreshed
///
/// Combines a scroll view with pull-to-refresh
class RefreshableScrollView extends StatelessWidget {
  /// List of widgets to display
  final List<Widget> children;

  /// Refresh callback
  final Future<void> Function() onRefresh;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Physics
  final ScrollPhysics? physics;

  const RefreshableScrollView({
    super.key,
    required this.children,
    required this.onRefresh,
    this.padding,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return PullToRefreshWrapper(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

/// A refreshable custom scroll view with slivers
class RefreshableCustomScrollView extends StatelessWidget {
  /// Sliver widgets to display
  final List<Widget> slivers;

  /// Refresh callback
  final Future<void> Function() onRefresh;

  /// Scroll controller
  final ScrollController? controller;

  /// Physics
  final ScrollPhysics? physics;

  const RefreshableCustomScrollView({
    super.key,
    required this.slivers,
    required this.onRefresh,
    this.controller,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: DesignSystem.primary,
      backgroundColor: DesignSystem.surfaceContainer,
      child: CustomScrollView(
        controller: controller,
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        slivers: slivers,
      ),
    );
  }
}
