import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';

/// A dynamic list component that integrates with BLoC pattern
/// Supports pagination, pull-to-refresh, and loading states
class BlocList<TBloc extends Bloc<TEvent, TState>, TState, TEvent, TItem> extends StatefulWidget {
  final String title;
  final TEvent loadEvent;
  final TEvent? refreshEvent;
  final TEvent? loadMoreEvent;
  final List<TItem> Function(TState state) getItems;
  final bool Function(TState state) isLoading;
  final bool Function(TState state)? isLoadingMore;
  final bool Function(TState state) isError;
  final bool Function(TState state)? hasReachedEnd;
  final String Function(TState state)? getErrorMessage;
  final Widget Function(BuildContext context, TItem item, int index) itemBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData? emptyIcon;
  final bool showAppBar;
  final List<Widget>? appBarActions;
  final EdgeInsetsGeometry? padding;
  final Widget Function(TState state)? customStateWidget;

  const BlocList({
    Key? key,
    required this.title,
    required this.loadEvent,
    required this.getItems,
    required this.isLoading,
    required this.isError,
    required this.itemBuilder,
    this.refreshEvent,
    this.loadMoreEvent,
    this.isLoadingMore,
    this.hasReachedEnd,
    this.getErrorMessage,
    this.emptyBuilder,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon,
    this.showAppBar = true,
    this.appBarActions,
    this.padding,
    this.customStateWidget,
  }) : super(key: key);

  @override
  State<BlocList<TBloc, TState, TEvent, TItem>> createState() =>
      _BlocListState<TBloc, TState, TEvent, TItem>();
}

class _BlocListState<TBloc extends Bloc<TEvent, TState>, TState, TEvent, TItem>
    extends State<BlocList<TBloc, TState, TEvent, TItem>> with PageMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TBloc>().add(widget.loadEvent);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && widget.loadMoreEvent != null) {
      final state = context.read<TBloc>().state;
      final isLoadingMore = widget.isLoadingMore?.call(state) ?? false;
      final hasReachedEnd = widget.hasReachedEnd?.call(state) ?? false;

      if (!isLoadingMore && !hasReachedEnd) {
        context.read<TBloc>().add(widget.loadMoreEvent as TEvent);
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _onRefresh() async {
    if (widget.refreshEvent != null) {
      context.read<TBloc>().add(widget.refreshEvent as TEvent);
    } else {
      context.read<TBloc>().add(widget.loadEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(widget.title, style: AppConstants.headingStyle),
              actions: widget.appBarActions,
              backgroundColor: AppConstants.backgroundColor,
              elevation: 0,
            )
          : null,
      body: BlocBuilder<TBloc, TState>(
        builder: (context, state) => _buildContent(state),
      ),
    );
  }

  Widget _buildContent(TState state) {
    // Handle custom state widget
    if (widget.customStateWidget != null) {
      final customWidget = widget.customStateWidget!(state);
      return customWidget;
        }

    // Handle loading state
    if (widget.isLoading(state)) {
      return const Center(child: CircularProgressIndicator());
    }

    // Handle error state
    if (widget.isError(state)) {
      final errorMessage = widget.getErrorMessage?.call(state) ?? 'An error occurred';
      return _buildErrorWidget(errorMessage);
    }

    final items = widget.getItems(state);

    // Handle empty state
    if (items.isEmpty) {
      return _buildEmptyWidget();
    }

    // Build list
    return _buildList(items, state);
  }

  Widget _buildList(List<TItem> items, TState state) {
    final hasLoadMore = widget.loadMoreEvent != null;
    final isLoadingMore = widget.isLoadingMore?.call(state) ?? false;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
        controller: _scrollController,
        padding: widget.padding ?? const EdgeInsets.all(16),
        itemCount: hasLoadMore ? items.length + 1 : items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            // Load more indicator
            return _buildLoadMoreIndicator(isLoadingMore);
          }
          return widget.itemBuilder(context, items[index], index);
        },
      ),
    );
  }

  Widget _buildLoadMoreIndicator(bool isLoadingMore) {
    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return const SizedBox(height: 16);
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppConstants.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: AppConstants.headingStyle.copyWith(
                color: AppConstants.errorColor,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppConstants.captionStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<TBloc>().add(widget.loadEvent),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    if (widget.emptyBuilder != null) {
      return widget.emptyBuilder!(context);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.emptyIcon ?? Icons.inbox_outlined,
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              widget.emptyTitle ?? 'No items found',
              style: AppConstants.headingStyle.copyWith(
                color: AppConstants.textSecondaryColor,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.emptySubtitle ?? 'There are no items to display',
              style: AppConstants.captionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Simplified list component for basic use cases
class SimpleBlocList<TBloc extends Bloc<dynamic, TState>, TState, TItem> extends StatelessWidget {
  final List<TItem> Function(TState state) getItems;
  final bool Function(TState state) isLoading;
  final bool Function(TState state) isError;
  final Widget Function(BuildContext context, TItem item, int index) itemBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final String Function(TState state)? getErrorMessage;
  final EdgeInsetsGeometry? padding;

  const SimpleBlocList({
    Key? key,
    required this.getItems,
    required this.isLoading,
    required this.isError,
    required this.itemBuilder,
    this.emptyBuilder,
    this.getErrorMessage,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TBloc, TState>(
      builder: (context, state) {
        if (isLoading(state)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (isError(state)) {
          final errorMessage = getErrorMessage?.call(state) ?? 'An error occurred';
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppConstants.errorColor,
                ),
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: AppConstants.captionStyle.copyWith(
                    color: AppConstants.errorColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final items = getItems(state);

        if (items.isEmpty) {
          return emptyBuilder?.call(context) ??
              const Center(
                child: Text(
                  'No items found',
                  style: AppConstants.captionStyle,
                ),
              );
        }

        return ListView.separated(
          padding: padding ?? const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => itemBuilder(context, items[index], index),
        );
      },
    );
  }
}