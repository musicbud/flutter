import 'package:flutter/material.dart';
import '../base/base_content_container.dart';

/// A reusable list layout widget for displaying content in a vertical list.
/// Provides consistent spacing, separators, and loading states.
///
/// Features:
/// - Customizable item builder for flexible content
/// - Optional separators between items
/// - Consistent spacing and padding
/// - Loading state support
/// - Empty state handling
/// - Scroll physics customization
/// - Pull-to-refresh support
class ContentList<T> extends BaseContentContainer<T> {

  /// Builder function for separators between items (optional)
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Spacing between items (ignored if separatorBuilder is provided)
  final double spacing;

  /// Callback for pull-to-refresh functionality
  final Future<void> Function()? onRefresh;

  /// Whether to enable pull-to-refresh
  final bool enablePullToRefresh;

  ContentList({
    super.key,
    required List<T> items,
    required Widget Function(BuildContext context, T item, int index) itemBuilder,
    bool isLoading = false,
    Widget? emptyState,
    VoidCallback? onLoadMore,
    bool hasMoreItems = false,
    ScrollController? scrollController,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    this.separatorBuilder,
    this.spacing = 16,
    this.onRefresh,
    this.enablePullToRefresh = false,
  }) : super(
    items: items,
    itemBuilder: itemBuilder,
    isLoading: isLoading,
    emptyState: emptyState,
    onLoadMore: onLoadMore,
    hasMoreItems: hasMoreItems,
    scrollController: scrollController,
    physics: physics,
    padding: padding,
    shrinkWrap: shrinkWrap,
  );




  void _handlePagination() {
    triggerLoadMore();
  }

  Widget _buildDefaultLoadingIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}