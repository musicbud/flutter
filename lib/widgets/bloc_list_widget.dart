import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/widgets/enhanced/utils/snackbar_utils.dart';

/// A reusable list widget that integrates with BLoC pattern.
///
/// This widget handles common list scenarios including:
/// - Loading states with progress indicators
/// - Empty states with custom messages
/// - Error states with retry capability
/// - Pull-to-refresh functionality
/// - Infinite scroll pagination
/// - Grid and list layouts
///
/// Example usage:
/// ```dart
/// BlocListWidget<MyListBloc, MyListState, MyItem>(
///   getItems: (state) => state is MyListLoadedState ? state.items : [],
///   isLoading: (state) => state is MyListLoadingState,
///   isError: (state) => state is MyListErrorState,
///   getErrorMessage: (state) => (state as MyListErrorState).message,
///   itemBuilder: (context, item) => ListTile(
///     title: Text(item.name),
///     subtitle: Text(item.description),
///   ),
///   onRefresh: () async {
///     context.read<MyListBloc>().add(RefreshList());
///   },
///   onLoadMore: () {
///     context.read<MyListBloc>().add(LoadMoreItems());
///   },
///   emptyMessage: 'No items found',
/// )
/// ```
class BlocListWidget<B extends StateStreamableSource<S>, S, T>
    extends StatefulWidget {
  /// Function to extract items list from state
  final List<T> Function(S state) getItems;

  /// Function to determine if state represents loading
  final bool Function(S state) isLoading;

  /// Function to determine if state represents error
  final bool Function(S state) isError;

  /// Function to extract error message from error state
  final String Function(S state) getErrorMessage;

  /// Builder function for individual list items
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Optional callback for pull-to-refresh
  final Future<void> Function()? onRefresh;

  /// Optional callback for loading more items (infinite scroll)
  final void Function()? onLoadMore;

  /// Optional callback for retry on error
  final void Function()? onRetry;

  /// Message to display when list is empty
  final String emptyMessage;

  /// Optional custom empty state widget
  final Widget? emptyWidget;

  /// Optional custom loading widget
  final Widget? loadingWidget;

  /// Optional custom error widget builder
  final Widget Function(BuildContext context, String errorMessage)? errorBuilder;

  /// Whether to use grid layout instead of list
  final bool useGridLayout;

  /// Number of columns for grid layout (only used if useGridLayout is true)
  final int gridCrossAxisCount;

  /// Spacing between grid items
  final double gridSpacing;

  /// Aspect ratio for grid items
  final double gridChildAspectRatio;

  /// Optional scroll controller
  final ScrollController? scrollController;

  /// Padding for the list
  final EdgeInsetsGeometry? padding;

  /// Whether to enable pull-to-refresh
  final bool enableRefresh;

  /// Whether to enable infinite scroll
  final bool enableInfiniteScroll;

  /// Threshold for triggering load more (distance from bottom in pixels)
  final double loadMoreThreshold;

  /// Optional separator builder for list items
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Whether list items should be shrink-wrapped
  final bool shrinkWrap;

  /// Whether list should have physics
  final ScrollPhysics? physics;

  const BlocListWidget({
    super.key,
    required this.getItems,
    required this.isLoading,
    required this.isError,
    required this.getErrorMessage,
    required this.itemBuilder,
    this.onRefresh,
    this.onLoadMore,
    this.onRetry,
    this.emptyMessage = 'No items available',
    this.emptyWidget,
    this.loadingWidget,
    this.errorBuilder,
    this.useGridLayout = false,
    this.gridCrossAxisCount = 2,
    this.gridSpacing = 8.0,
    this.gridChildAspectRatio = 1.0,
    this.scrollController,
    this.padding,
    this.enableRefresh = true,
    this.enableInfiniteScroll = false,
    this.loadMoreThreshold = 200.0,
    this.separatorBuilder,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  State<BlocListWidget<B, S, T>> createState() =>
      _BlocListWidgetState<B, S, T>();
}

class _BlocListWidgetState<B extends StateStreamableSource<S>, S, T>
    extends State<BlocListWidget<B, S, T>> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();

    if (widget.enableInfiniteScroll) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = widget.loadMoreThreshold;

    if (maxScroll - currentScroll <= threshold) {
      setState(() => _isLoadingMore = true);
      widget.onLoadMore?.call();
      // Reset loading more flag after a delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _isLoadingMore = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      listener: (context, state) {
        if (widget.isError(state)) {
          SnackbarUtils.showError(
            context,
            widget.getErrorMessage(state),
          );
        }
      },
      builder: (context, state) {
        final items = widget.getItems(state);
        final isLoading = widget.isLoading(state);
        final isError = widget.isError(state);

        // Show loading indicator on initial load
        if (isLoading && items.isEmpty) {
          return Center(
            child: widget.loadingWidget ??
                const CircularProgressIndicator(),
          );
        }

        // Show error state
        if (isError && items.isEmpty) {
          return _buildErrorWidget(context, widget.getErrorMessage(state));
        }

        // Show empty state
        if (items.isEmpty) {
          return _buildEmptyWidget(context);
        }

        // Build list content
        Widget listContent = widget.useGridLayout
            ? _buildGridView(items)
            : _buildListView(items);

        // Wrap with RefreshIndicator if enabled
        if (widget.enableRefresh && widget.onRefresh != null) {
          listContent = RefreshIndicator(
            onRefresh: widget.onRefresh!,
            child: listContent,
          );
        }

        return listContent;
      },
    );
  }

  Widget _buildListView(List<T> items) {
    if (widget.separatorBuilder != null) {
      return ListView.separated(
        controller: _scrollController,
        padding: widget.padding,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        itemCount: items.length + (widget.enableInfiniteScroll ? 1 : 0),
        separatorBuilder: widget.separatorBuilder!,
        itemBuilder: (context, index) {
          if (index < items.length) {
            return widget.itemBuilder(context, items[index]);
          } else {
            return _buildLoadMoreIndicator();
          }
        },
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemCount: items.length + (widget.enableInfiniteScroll ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < items.length) {
          return widget.itemBuilder(context, items[index]);
        } else {
          return _buildLoadMoreIndicator();
        }
      },
    );
  }

  Widget _buildGridView(List<T> items) {
    return GridView.builder(
      controller: _scrollController,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.gridCrossAxisCount,
        crossAxisSpacing: widget.gridSpacing,
        mainAxisSpacing: widget.gridSpacing,
        childAspectRatio: widget.gridChildAspectRatio,
      ),
      itemCount: items.length + (widget.enableInfiniteScroll ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < items.length) {
          return widget.itemBuilder(context, items[index]);
        } else {
          return _buildLoadMoreIndicator();
        }
      },
    );
  }

  Widget _buildLoadMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    if (widget.emptyWidget != null) {
      return widget.emptyWidget!;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64.0,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.emptyMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String errorMessage) {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!(context, errorMessage);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.0,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            if (widget.onRetry != null) ...[
              const SizedBox(height: 24.0),
              FilledButton.icon(
                onPressed: widget.onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
