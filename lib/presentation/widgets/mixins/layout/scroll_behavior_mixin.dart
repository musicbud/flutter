import 'package:flutter/material.dart';

/// A mixin that provides comprehensive scroll behavior management for widgets.
///
/// This mixin handles:
/// - Scroll controller management and lifecycle
/// - Pagination and infinite scrolling
/// - Pull-to-refresh functionality
/// - Scroll position tracking and callbacks
/// - Auto-scrolling and programmatic scrolling
/// - Scroll physics and behavior customization
/// - Memory management for scroll controllers
///
/// Usage:
/// ```dart
/// class MyWidget extends StatefulWidget {
///   // ...
/// }
///
/// class _MyWidgetState extends State<MyWidget>
///     with ScrollBehaviorMixin {
///
///   @override
///   void initState() {
///     super.initState();
///     setupScrollController(
///       onScroll: _handleScroll,
///       onLoadMore: _loadMoreItems,
///     );
///   }
///
///   void _handleScroll() {
///     if (scrollController.position.pixels ==
///         scrollController.position.maxScrollExtent) {
///       loadMoreData();
///     }
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return ListView.builder(
///       controller: scrollController,
///       itemBuilder: (context, index) => _buildItem(index),
///     );
///   }
/// }
/// ```
mixin ScrollBehaviorMixin<T extends StatefulWidget> on State<T> {
  /// Scroll controller for managing scroll behavior
  late ScrollController _scrollController;

  /// Whether the scroll controller is initialized
  bool _isScrollControllerInitialized = false;

  /// Current scroll position
  double _currentScrollPosition = 0.0;

  /// Previous scroll position for direction detection
  double _previousScrollPosition = 0.0;

  /// Whether currently loading more items
  bool _isLoadingMore = false;

  /// Whether more items can be loaded
  bool _canLoadMore = true;

  /// Scroll direction
  ScrollDirection _scrollDirection = ScrollDirection.idle;

  /// Pagination configuration
  PaginationConfig? _paginationConfig;

  /// Scroll physics for scrollable widgets
  ScrollPhysics? _scrollPhysics;

  /// Gets the scroll controller
  ScrollController get scrollController => _scrollController;

  /// Gets the current scroll position
  double get currentScrollPosition => _currentScrollPosition;

  /// Gets the scroll direction
  ScrollDirection get scrollDirection => _scrollDirection;

  /// Whether currently loading more items
  bool get isLoadingMore => _isLoadingMore;

  /// Whether more items can be loaded
  bool get canLoadMore => _canLoadMore;

  /// Whether scroll controller is initialized
  bool get isScrollControllerInitialized => _isScrollControllerInitialized;

  @override
  void initState() {
    super.initState();
    _initializeScrollController();
  }

  @override
  void dispose() {
    _disposeScrollController();
    super.dispose();
  }

  /// Initialize the scroll controller
  void _initializeScrollController() {
    _scrollController = ScrollController();
    _isScrollControllerInitialized = true;

    _scrollController.addListener(_handleScrollChange);
  }

  /// Dispose of the scroll controller
  void _disposeScrollController() {
    if (_isScrollControllerInitialized) {
      _scrollController.removeListener(_handleScrollChange);
      _scrollController.dispose();
      _isScrollControllerInitialized = false;
    }
  }

  /// Handle scroll changes
  void _handleScrollChange() {
    _updateScrollPosition();
    _detectScrollDirection();
    _handlePagination();
    _notifyScrollCallbacks();
  }

  /// Update current scroll position
  void _updateScrollPosition() {
    _previousScrollPosition = _currentScrollPosition;
    _currentScrollPosition = _scrollController.position.pixels;
  }

  /// Detect scroll direction
  void _detectScrollDirection() {
    if (_currentScrollPosition > _previousScrollPosition) {
      _scrollDirection = ScrollDirection.forward;
    } else if (_currentScrollPosition < _previousScrollPosition) {
      _scrollDirection = ScrollDirection.reverse;
    } else {
      _scrollDirection = ScrollDirection.idle;
    }
  }

  /// Handle pagination logic
  void _handlePagination() {
    if (_paginationConfig == null || !_paginationConfig!.enabled) return;

    final position = _scrollController.position;
    final threshold = _paginationConfig!.threshold;

    if (position.pixels >= position.maxScrollExtent - threshold &&
        !_isLoadingMore &&
        _canLoadMore) {
      _loadMoreItems();
    }
  }

  /// Load more items for pagination
  void _loadMoreItems() {
    if (_paginationConfig?.onLoadMore != null) {
      _isLoadingMore = true;
      onLoadingMoreChanged?.call(true);

      _paginationConfig!.onLoadMore!().then((canLoadMore) {
        _canLoadMore = canLoadMore;
        _isLoadingMore = false;
        onLoadingMoreChanged?.call(false);
      }).catchError((error) {
        _isLoadingMore = false;
        onLoadingMoreChanged?.call(false);
        onLoadMoreError?.call(error);
      });
    }
  }

  /// Notify scroll callbacks
  void _notifyScrollCallbacks() {
    onScroll?.call(_currentScrollPosition, _scrollDirection);

    // Notify direction-specific callbacks
    switch (_scrollDirection) {
      case ScrollDirection.forward:
        onScrollForward?.call(_currentScrollPosition);
        break;
      case ScrollDirection.reverse:
        onScrollReverse?.call(_currentScrollPosition);
        break;
      case ScrollDirection.idle:
        onScrollIdle?.call(_currentScrollPosition);
        break;
    }
  }

  /// Setup scroll controller with configuration
  void setupScrollController({
    void Function(double position, ScrollDirection direction)? onScroll,
    void Function(double position)? onScrollForward,
    void Function(double position)? onScrollReverse,
    void Function(double position)? onScrollIdle,
    Future<bool> Function()? onLoadMore,
    void Function(bool loading)? onLoadingMoreChanged,
    void Function(dynamic error)? onLoadMoreError,
    PaginationConfig? paginationConfig,
    ScrollPhysics? physics,
    bool keepScrollOffset = false,
    String? debugLabel,
  }) {
    this.onScroll = onScroll;
    this.onScrollForward = onScrollForward;
    this.onScrollReverse = onScrollReverse;
    this.onScrollIdle = onScrollIdle;
    this.onLoadingMoreChanged = onLoadingMoreChanged;
    this.onLoadMoreError = onLoadMoreError;

    if (paginationConfig != null) {
      _paginationConfig = paginationConfig;
    }

    if (physics != null) {
       _scrollPhysics = physics;
     }

    _scrollController = ScrollController(
      keepScrollOffset: keepScrollOffset,
      debugLabel: debugLabel,
    );
  }

  /// Setup pagination configuration
  void setupPagination({
    required Future<bool> Function() onLoadMore,
    double threshold = 100.0,
    bool enabled = true,
  }) {
    _paginationConfig = PaginationConfig(
      onLoadMore: onLoadMore,
      threshold: threshold,
      enabled: enabled,
    );
  }

  /// Scroll to top
  void scrollToTop({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    if (!_isScrollControllerInitialized) return;

    _scrollController.animateTo(
      0,
      duration: duration,
      curve: curve,
    );
  }

  /// Scroll to bottom
  void scrollToBottom({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    if (!_isScrollControllerInitialized) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: duration,
      curve: curve,
    );
  }

  /// Scroll to specific position
  void scrollToPosition({
    required double position,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    if (!_isScrollControllerInitialized) return;

    _scrollController.animateTo(
      position,
      duration: duration,
      curve: curve,
    );
  }

  /// Scroll to specific item index
  void scrollToItem({
    required int index,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    double alignment = 0.0,
  }) {
    if (!_isScrollControllerInitialized) return;

    _scrollController.animateTo(
      index * 100.0, // Assuming average item height of 100
      duration: duration,
      curve: curve,
    );
  }

  /// Jump to top (immediate)
  void jumpToTop() {
    if (!_isScrollControllerInitialized) return;
    _scrollController.jumpTo(0);
  }

  /// Jump to bottom (immediate)
  void jumpToBottom() {
    if (!_isScrollControllerInitialized) return;
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  /// Jump to specific position (immediate)
  void jumpToPosition(double position) {
    if (!_isScrollControllerInitialized) return;
    _scrollController.jumpTo(position);
  }

  /// Enable/disable pagination
  void setPaginationEnabled(bool enabled) {
    if (_paginationConfig != null) {
      _paginationConfig = _paginationConfig!.copyWith(enabled: enabled);
    }
  }

  /// Set whether more items can be loaded
  void setCanLoadMore(bool canLoadMore) {
    _canLoadMore = canLoadMore;
  }

  /// Refresh the scroll controller
  void refreshScrollController() {
    _disposeScrollController();
    _initializeScrollController();
  }

  /// Get scroll position as percentage
  double getScrollPercentage() {
    if (!_isScrollControllerInitialized) return 0.0;

    final position = _scrollController.position;
    if (position.maxScrollExtent == 0) return 0.0;

    return (_currentScrollPosition / position.maxScrollExtent).clamp(0.0, 1.0);
  }

  /// Check if scrolled to top
  bool isAtTop() {
    if (!_isScrollControllerInitialized) return true;
    return _currentScrollPosition <= _scrollController.position.minScrollExtent;
  }

  /// Check if scrolled to bottom
  bool isAtBottom() {
    if (!_isScrollControllerInitialized) return true;
    return _currentScrollPosition >= _scrollController.position.maxScrollExtent;
  }

  /// Check if near bottom for pagination
  bool isNearBottom({double threshold = 100.0}) {
    if (!_isScrollControllerInitialized) return false;
    return _currentScrollPosition >=
           _scrollController.position.maxScrollExtent - threshold;
  }

  /// Check if near top for pull-to-refresh
  bool isNearTop({double threshold = 50.0}) {
    if (!_isScrollControllerInitialized) return false;
    return _currentScrollPosition <=
           _scrollController.position.minScrollExtent + threshold;
  }

  /// Get scroll velocity
  double getScrollVelocity() {
    if (!_isScrollControllerInitialized) return 0.0;
    return _scrollController.position.activity?.velocity ?? 0.0;
  }

  /// Check if scrolling
  bool isScrolling() {
    return _scrollDirection != ScrollDirection.idle;
  }

  /// Check if scrolling forward (down)
  bool isScrollingForward() {
    return _scrollDirection == ScrollDirection.forward;
  }

  /// Check if scrolling reverse (up)
  bool isScrollingReverse() {
    return _scrollDirection == ScrollDirection.reverse;
  }

  /// Build scrollable widget with pull-to-refresh
  Widget buildRefreshableScrollView({
    required List<Widget> children,
    RefreshCallback? onRefresh,
    bool reverse = false,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    Key? key,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: ListView(
        key: key,
        controller: _scrollController,
        physics: _scrollPhysics,
        reverse: reverse,
        padding: padding,
        shrinkWrap: shrinkWrap,
        children: children,
      ),
    );
  }

  /// Build scrollable widget with pagination
  Widget buildPaginatableScrollView({
    required NullableIndexedWidgetBuilder itemBuilder,
    required int itemCount,
    bool reverse = false,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    Key? key,
    Widget? loadingIndicator,
  }) {
    return ListView.builder(
      key: key,
      controller: _scrollController,
      physics: _scrollPhysics,
      reverse: reverse,
      padding: padding,
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        if (_paginationConfig?.enabled == true &&
            index == itemCount - 1 &&
            _canLoadMore) {
          // Show loading indicator for pagination
          if (loadingIndicator != null) {
            return loadingIndicator;
          }

          return Container(
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return itemBuilder(context, index);
      },
      itemCount: itemCount + (_shouldShowLoadingIndicator() ? 1 : 0),
    );
  }

  /// Check if loading indicator should be shown
  bool _shouldShowLoadingIndicator() {
    return _paginationConfig?.enabled == true &&
           _isLoadingMore &&
           _canLoadMore;
  }

  /// Build scrollable grid with pagination
  Widget buildPaginatableGridView({
    required SliverGridDelegate gridDelegate,
    required NullableIndexedWidgetBuilder itemBuilder,
    required int itemCount,
    bool reverse = false,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    Key? key,
    Widget? loadingIndicator,
  }) {
    return GridView.builder(
      key: key,
      controller: _scrollController,
      physics: _scrollPhysics,
      reverse: reverse,
      padding: padding,
      shrinkWrap: shrinkWrap,
      gridDelegate: gridDelegate,
      itemBuilder: (context, index) {
        if (_paginationConfig?.enabled == true &&
            index == itemCount - 1 &&
            _canLoadMore) {
          // Show loading indicator for pagination
          if (loadingIndicator != null) {
            return loadingIndicator;
          }

          return Container(
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return itemBuilder(context, index);
      },
      itemCount: itemCount + (_shouldShowLoadingIndicator() ? 1 : 0),
    );
  }

  /// Build custom scroll view with pagination
  Widget buildPaginatableCustomScrollView({
    required List<Widget> slivers,
    bool reverse = false,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    Key? key,
  }) {
    final List<Widget> updatedSlivers = List.from(slivers);

    // Add loading indicator if pagination is enabled
    if (_shouldShowLoadingIndicator()) {
      updatedSlivers.add(
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    return CustomScrollView(
      key: key,
      controller: _scrollController,
      physics: _scrollPhysics,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      slivers: updatedSlivers,
    );
  }

  /// Scroll callbacks
  void Function(double position, ScrollDirection direction)? _onScroll;
  void Function(double position)? _onScrollForward;
  void Function(double position)? _onScrollReverse;
  void Function(double position)? _onScrollIdle;
  void Function(bool loading)? _onLoadingMoreChanged;
  void Function(dynamic error)? _onLoadMoreError;

  void Function(double position, ScrollDirection direction)? get onScroll => _onScroll;
  set onScroll(void Function(double position, ScrollDirection direction)? callback) => _onScroll = callback;

  void Function(double position)? get onScrollForward => _onScrollForward;
  set onScrollForward(void Function(double position)? callback) => _onScrollForward = callback;

  void Function(double position)? get onScrollReverse => _onScrollReverse;
  set onScrollReverse(void Function(double position)? callback) => _onScrollReverse = callback;

  void Function(double position)? get onScrollIdle => _onScrollIdle;
  set onScrollIdle(void Function(double position)? callback) => _onScrollIdle = callback;

  void Function(bool loading)? get onLoadingMoreChanged => _onLoadingMoreChanged;
  set onLoadingMoreChanged(void Function(bool loading)? callback) => _onLoadingMoreChanged = callback;

  void Function(dynamic error)? get onLoadMoreError => _onLoadMoreError;
  set onLoadMoreError(void Function(dynamic error)? callback) => _onLoadMoreError = callback;
}

/// Scroll direction enumeration
enum ScrollDirection {
  /// Not scrolling
  idle,

  /// Scrolling forward (down)
  forward,

  /// Scrolling reverse (up)
  reverse,
}

/// Pagination configuration
class PaginationConfig {
  /// Callback when more items should be loaded
  final Future<bool> Function() onLoadMore;

  /// Distance from bottom to trigger load more
  final double threshold;

  /// Whether pagination is enabled
  final bool enabled;

  const PaginationConfig({
    required this.onLoadMore,
    this.threshold = 100.0,
    this.enabled = true,
  });

  /// Create a copy with modified values
  PaginationConfig copyWith({
    Future<bool> Function()? onLoadMore,
    double? threshold,
    bool? enabled,
  }) {
    return PaginationConfig(
      onLoadMore: onLoadMore ?? this.onLoadMore,
      threshold: threshold ?? this.threshold,
      enabled: enabled ?? this.enabled,
    );
  }
}