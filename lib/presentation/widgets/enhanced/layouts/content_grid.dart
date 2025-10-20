import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A grid layout widget for displaying content
///
/// Perfect for album grids, playlist grids, artist grids, etc.
///
/// Example:
/// ```dart
/// ContentGrid(
///   itemCount: albums.length,
///   itemBuilder: (context, index) => MediaCard.album(
///     imageUrl: albums[index].artworkUrl,
///     title: albums[index].title,
///     artist: albums[index].artist,
///   ),
/// )
/// ```
class ContentGrid extends StatelessWidget {
  /// Number of items in the grid
  final int itemCount;

  /// Builder function for each item
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Number of columns (responsive by default)
  final int? crossAxisCount;

  /// Spacing between grid items
  final double spacing;

  /// Aspect ratio for grid items (width/height)
  final double aspectRatio;

  /// Padding around the grid
  final EdgeInsetsGeometry? padding;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Scroll controller
  final ScrollController? controller;

  /// Whether the grid should shrink wrap
  final bool shrinkWrap;

  const ContentGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount,
    this.spacing = DesignSystem.spacingMD,
    this.aspectRatio = 1.0,
    this.padding,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCrossAxisCount = crossAxisCount ??
        _getResponsiveCrossAxisCount(MediaQuery.of(context).size.width);

    return GridView.builder(
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding ??
          const EdgeInsets.all(DesignSystem.spacingLG),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: effectiveCrossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  int _getResponsiveCrossAxisCount(double width) {
    if (width < 600) return 2; // Mobile
    if (width < 900) return 3; // Tablet
    if (width < 1200) return 4; // Small desktop
    return 5; // Large desktop
  }

  /// Factory for album grid (square items)
  factory ContentGrid.albums({
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    EdgeInsetsGeometry? padding,
  }) {
    return ContentGrid(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      aspectRatio: 1.0,
      padding: padding,
    );
  }

  /// Factory for compact grid (smaller spacing)
  factory ContentGrid.compact({
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    double aspectRatio = 1.0,
  }) {
    return ContentGrid(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      spacing: DesignSystem.spacingSM,
      aspectRatio: aspectRatio,
    );
  }
}

/// A sliver grid for use in CustomScrollView
class SliverContentGrid extends StatelessWidget {
  /// Number of items in the grid
  final int itemCount;

  /// Builder function for each item
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Number of columns (responsive by default)
  final int? crossAxisCount;

  /// Spacing between grid items
  final double spacing;

  /// Aspect ratio for grid items (width/height)
  final double aspectRatio;

  const SliverContentGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount,
    this.spacing = DesignSystem.spacingMD,
    this.aspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCrossAxisCount = crossAxisCount ??
        _getResponsiveCrossAxisCount(MediaQuery.of(context).size.width);

    return SliverPadding(
      padding: const EdgeInsets.all(DesignSystem.spacingLG),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: effectiveCrossAxisCount,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        delegate: SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
        ),
      ),
    );
  }

  int _getResponsiveCrossAxisCount(double width) {
    if (width < 600) return 2;
    if (width < 900) return 3;
    if (width < 1200) return 4;
    return 5;
  }
}

/// A responsive grid that adapts to different screen sizes
class ResponsiveGrid extends StatelessWidget {
  /// List of items to display
  final List<Widget> children;

  /// Minimum item width
  final double minItemWidth;

  /// Spacing between items
  final double spacing;

  /// Padding around the grid
  final EdgeInsetsGeometry? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 150,
    this.spacing = DesignSystem.spacingMD,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount =
            (constraints.maxWidth / minItemWidth).floor().clamp(1, 6);

        return GridView.count(
          padding: padding ?? const EdgeInsets.all(DesignSystem.spacingLG),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          children: children,
        );
      },
    );
  }
}
