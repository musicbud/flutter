import 'package:flutter/material.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

/// A builder class for composing list and grid items with consistent layouts.
/// Provides a fluent API for building lists with proper spacing, dividers, and styling.
///
/// **Features:**
/// - Support for both list and grid layouts
/// - Customizable item spacing and separators
/// - Built-in support for loading states
/// - Consistent styling with design system
/// - Flexible item builder patterns
/// - Support for empty states
///
/// **Usage:**
/// ```dart
/// final listWidget = ListBuilder<String>()
///   .withItems(['Item 1', 'Item 2', 'Item 3'])
///   .withItemBuilder((context, item, index) {
///     return ListTile(title: Text(item));
///   })
///   .withSeparatorBuilder((context, index) {
///     return Divider(height: 1);
///   })
///   .withPadding(EdgeInsets.all(DesignSystem.spacingMD))
///   .withScrollPhysics(BouncingScrollPhysics())
///   .build();
/// ```
class ListBuilder<T> {
  List<T> _items = [];
  Widget Function(BuildContext context, T item, int index)? _itemBuilder;
  Widget Function(BuildContext context, int index)? _separatorBuilder;
  Widget? _emptyWidget;
  Widget? _loadingWidget;
  Widget? _errorWidget;
  EdgeInsetsGeometry? _padding;
  ScrollPhysics? _scrollPhysics;
  bool _shrinkWrap = false;
  ScrollController? _scrollController;
  Axis _scrollDirection = Axis.vertical;
  bool _reverse = false;
  bool _primary = true;
  String? _emptyMessage;
  String? _loadingMessage;
  String? _errorMessage;
  VoidCallback? _onRetry;
  ListLoadingState _loadingState = ListLoadingState.none;

  /// Creates a new ListBuilder instance
  ListBuilder();

  /// Sets the items to display in the list
  ListBuilder<T> withItems(List<T> items) {
    _items = items;
    return this;
  }

  /// Sets the item builder function for creating list items
  ListBuilder<T> withItemBuilder(Widget Function(BuildContext context, T item, int index) builder) {
    _itemBuilder = builder;
    return this;
  }

  /// Sets the separator builder function for creating dividers between items
  ListBuilder<T> withSeparatorBuilder(Widget Function(BuildContext context, int index) builder) {
    _separatorBuilder = builder;
    return this;
  }

  /// Sets custom padding for the list
  ListBuilder<T> withPadding(EdgeInsetsGeometry padding) {
    _padding = padding;
    return this;
  }

  /// Sets scroll physics for the list
  ListBuilder<T> withScrollPhysics(ScrollPhysics physics) {
    _scrollPhysics = physics;
    return this;
  }

  /// Sets whether the list should shrink wrap its content
  ListBuilder<T> withShrinkWrap(bool shrinkWrap) {
    _shrinkWrap = shrinkWrap;
    return this;
  }

  /// Sets custom scroll controller for the list
  ListBuilder<T> withScrollController(ScrollController controller) {
    _scrollController = controller;
    return this;
  }

  /// Sets scroll direction for the list
  ListBuilder<T> withScrollDirection(Axis direction) {
    _scrollDirection = direction;
    return this;
  }

  /// Sets whether the list should be reversed
  ListBuilder<T> withReverse(bool reverse) {
    _reverse = reverse;
    return this;
  }

  /// Sets whether this is the primary scroll view
  ListBuilder<T> withPrimary(bool primary) {
    _primary = primary;
    return this;
  }

  /// Sets custom empty state widget
  ListBuilder<T> withEmptyWidget(Widget widget) {
    _emptyWidget = widget;
    return this;
  }

  /// Sets custom loading state widget
  ListBuilder<T> withLoadingWidget(Widget widget) {
    _loadingWidget = widget;
    return this;
  }

  /// Sets custom error state widget
  ListBuilder<T> withErrorWidget(Widget widget) {
    _errorWidget = widget;
    return this;
  }

  /// Sets empty state message
  ListBuilder<T> withEmptyMessage(String message) {
    _emptyMessage = message;
    return this;
  }

  /// Sets loading state message
  ListBuilder<T> withLoadingMessage(String message) {
    _loadingMessage = message;
    return this;
  }

  /// Sets error state message
  ListBuilder<T> withErrorMessage(String message) {
    _errorMessage = message;
    return this;
  }

  /// Sets retry callback for error state
  ListBuilder<T> withOnRetry(VoidCallback onRetry) {
    _onRetry = onRetry;
    return this;
  }

  /// Sets the current loading state
  ListBuilder<T> withLoadingState(ListLoadingState state) {
    _loadingState = state;
    return this;
  }

  /// Builds and returns the final list widget
  Widget build() {
    // Handle different loading states
    switch (_loadingState) {
      case ListLoadingState.loading:
        return _buildLoadingState();
      case ListLoadingState.error:
        return _buildErrorState();
      case ListLoadingState.empty:
        return _buildEmptyState();
      case ListLoadingState.none:
        return _buildListContent();
    }
  }

  Widget _buildListContent() {
    if (_items.isEmpty) {
      return _buildEmptyState();
    }

    final listView = ListView.separated(
      padding: _padding,
      physics: _scrollPhysics,
      shrinkWrap: _shrinkWrap,
      controller: _scrollController,
      scrollDirection: _scrollDirection,
      reverse: _reverse,
      primary: _primary,
      itemCount: _items.length,
      itemBuilder: (context, index) {
        if (_itemBuilder != null) {
          return _itemBuilder!(context, _items[index], index);
        }
        return _buildDefaultItem(context, _items[index], index);
      },
      separatorBuilder: (context, index) {
        if (_separatorBuilder != null) {
          return _separatorBuilder!(context, index);
        }
        return _buildDefaultSeparator(context, index);
      },
    );

    return listView;
  }

  Widget _buildDefaultItem(BuildContext context, T item, int index) {
    return ListTile(
      title: Text(item.toString()),
      leading: CircleAvatar(
        backgroundColor: DesignSystem.primary,
        child: Text(
          (index + 1).toString(),
          style: DesignSystem.labelSmall.copyWith(
            color: DesignSystem.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultSeparator(BuildContext context, int index) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: DesignSystem.border,
      indent: DesignSystem.spacingMD,
      endIndent: DesignSystem.spacingMD,
    );
  }

  Widget _buildEmptyState() {
    return _emptyWidget ?? _buildDefaultEmptyState();
  }

  Widget _buildDefaultEmptyState() {
    return Container(
      padding: _padding ?? const EdgeInsets.all(DesignSystem.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 64,
            color: DesignSystem.onSurfaceVariant,
          ),
          const SizedBox(height: DesignSystem.spacingLG),
          Text(
            _emptyMessage ?? 'No items found',
            style: DesignSystem.titleMedium.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return _loadingWidget ?? _buildDefaultLoadingState();
  }

  Widget _buildDefaultLoadingState() {
    return Container(
      padding: _padding ?? const EdgeInsets.all(DesignSystem.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(DesignSystem.primary),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingLG),
          Text(
            _loadingMessage ?? 'Loading...',
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return _errorWidget ?? _buildDefaultErrorState();
  }

  Widget _buildDefaultErrorState() {
    return Container(
      padding: _padding ?? const EdgeInsets.all(DesignSystem.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: DesignSystem.error,
          ),
          const SizedBox(height: DesignSystem.spacingLG),
          Text(
            'Something went wrong',
            style: DesignSystem.titleMedium.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignSystem.spacingSM),
          Text(
            _errorMessage ?? 'Please check your connection and try again',
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (_onRetry != null) ...[
            const SizedBox(height: DesignSystem.spacingXL),
            ElevatedButton.icon(
              onPressed: _onRetry,
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: DesignSystem.primary,
                foregroundColor: DesignSystem.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading states for the list
enum ListLoadingState {
  /// Normal state with items displayed
  none,

  /// Loading state - showing loading indicator
  loading,

  /// Empty state - no items to display
  empty,

  /// Error state - error occurred while loading
  error,
}

/// Extension for quick list creation
extension ListBuilderExtension<T> on List<T> {
  /// Creates a ListBuilder with this list as items
  ListBuilder<T> get list => ListBuilder<T>().withItems(this);
}