import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
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
  /// The list of items to display in the grid
  final List<T> items;

  /// Builder function to create widgets for each item
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

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

  @override
  Widget _buildContent(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount ?? getResponsiveCrossAxisCount(context),
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: hasMoreItems ? items.length + 1 : items.length,
      itemBuilder: (context, index) {
        // Show loading indicator for pagination
        if (hasMoreItems && index == items.length) {
          _handlePagination();
          return _buildDefaultLoadingIndicator();
        }

        return itemBuilder(context, items[index], index);
      },
      shrinkWrap: shrinkWrap,
      physics: physics ?? getDefaultScrollPhysics(),
      controller: scrollController,
    );
  }

  @override
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No items to display',
        style: TextStyle(
          color: getDesignSystemColors(context).onSurfaceVariant,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  void _handlePagination() {
    triggerLoadMore();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

}