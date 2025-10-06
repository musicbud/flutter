import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
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

  const ContentList({
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

  @override
  Widget _buildContent(BuildContext context) {
    final listWidget = ListView.separated(
      itemCount: hasMoreItems ? items.length + 1 : items.length,
      itemBuilder: (context, index) {
        // Show loading indicator for pagination
        if (hasMoreItems && index == items.length) {
          _handlePagination();
          return _buildDefaultLoadingIndicator();
        }

        return itemBuilder(context, items[index], index);
      },
      separatorBuilder: separatorBuilder ?? (context, index) {
        if (hasMoreItems && index == items.length - 1) {
          return const SizedBox.shrink();
        }
        return SizedBox(height: spacing);
      },
      shrinkWrap: shrinkWrap,
      physics: physics ?? getDefaultScrollPhysics(),
      controller: scrollController,
    );

    // Wrap with RefreshIndicator if pull-to-refresh is enabled
    if (enablePullToRefresh && onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: listWidget,
      );
    }

    return listWidget;
  }

  @override
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No items to display',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  void _handlePagination() {
    triggerLoadMore();
  }

  Widget _buildDefaultLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Center(
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

  Widget _buildDefaultEmptyState(BuildContext context) {
    return Center(
      child: Text(
        'No items to display',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }

}