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

  const ContentList({
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
    this.separatorBuilder,
    this.spacing = 16,
    this.onRefresh,
    this.enablePullToRefresh = false,
  });




}