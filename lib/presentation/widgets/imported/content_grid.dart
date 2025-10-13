import '../base/base_content_container.dart';

/// A reusable grid layout widget for displaying content in a grid format.
/// Provides consistent spacing, responsive columns, and loading states.
///
/// Features:
/// - Responsive column count based on screen size
/// - Customizable item builder for flexible content
/// - Consistent spacing and padding
/// - Loading state support
/// - Empty state handling
/// - Scroll physics customization
class ContentGrid<T> extends BaseContentContainer<T> {

  /// Number of columns in the grid (responsive by default)
  final int? crossAxisCount;

  /// Spacing between grid items
  final double spacing;

  /// Aspect ratio for grid items (width/height)
  final double aspectRatio;

  const ContentGrid({
    super.key,
    required super.items,
    required super.itemBuilder,
    super.isLoading,
    super.emptyState,
    super.onLoadMore,
    super.hasMoreItems,
    super.scrollController,
    super.physics,
    super.padding,
    super.shrinkWrap,
    this.crossAxisCount,
    this.spacing = 16,
    this.aspectRatio = 1,
  });

}