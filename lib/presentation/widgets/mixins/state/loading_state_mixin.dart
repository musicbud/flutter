import 'package:flutter/material.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

/// A mixin that provides consistent loading state management for widgets.
///
/// This mixin handles:
/// - Loading state tracking with enum-based state management
/// - Animation controllers for smooth loading transitions
/// - Consistent loading indicators with theme integration
/// - Loading state callbacks and notifications
/// - Memory management for animation controllers
///
/// Usage:
/// ```dart
/// class MyWidget extends StatefulWidget {
///   // ...
/// }
///
/// class _MyWidgetState extends State<MyWidget>
///     with LoadingStateMixin {
///
///   void _loadData() {
///     setLoadingState(LoadingState.loading);
///     // ... load data ...
///     setLoadingState(LoadingState.loaded);
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return buildLoadingState(
///       context,
///       loadedWidget: _buildContent(),
///       loadingWidget: _buildLoadingWidget(),
///     );
///   }
/// }
/// ```
mixin LoadingStateMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  /// Current loading state
  LoadingState _loadingState = LoadingState.idle;

  /// Animation controller for loading animations
  late AnimationController _loadingAnimationController;

  /// Animation for the loading indicator
  late Animation<double> _loadingAnimation;

  /// Duration for loading animations
  final Duration loadingAnimationDuration = const Duration(milliseconds: 200);

  /// Gets the current loading state
  LoadingState get loadingState => _loadingState;

  /// Whether currently in loading state
  bool get isLoading => _loadingState == LoadingState.loading;

  /// Whether in idle state (not loading, no error)
  bool get isIdle => _loadingState == LoadingState.idle;

  /// Whether in error state
  bool get hasError => _loadingState == LoadingState.error;

  /// Whether successfully loaded
  bool get isLoaded => _loadingState == LoadingState.loaded;

  @override
  void initState() {
    super.initState();
    _initializeLoadingAnimations();
  }

  @override
  void dispose() {
    _disposeLoadingAnimations();
    super.dispose();
  }

  /// Initialize loading animations
  void _initializeLoadingAnimations() {
    _loadingAnimationController = AnimationController(
      duration: loadingAnimationDuration,
      vsync: this,
    );

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  /// Dispose of loading animations
  void _disposeLoadingAnimations() {
    _loadingAnimationController.dispose();
  }

  /// Set the loading state and trigger appropriate animations
  void setLoadingState(LoadingState state) {
    if (_loadingState == state) return;

    final previousState = _loadingState;
    _loadingState = state;

    _handleLoadingStateChange(previousState, state);
  }

  /// Handle loading state changes with animations
  void _handleLoadingStateChange(LoadingState previous, LoadingState current) {
    switch (current) {
      case LoadingState.loading:
        _startLoadingAnimation();
        onLoadingStarted?.call();
        break;
      case LoadingState.loaded:
        _stopLoadingAnimation();
        onLoadingCompleted?.call();
        break;
      case LoadingState.error:
        _stopLoadingAnimation();
        onLoadingError?.call();
        break;
      case LoadingState.idle:
        _stopLoadingAnimation();
        break;
    }
  }

  /// Start the loading animation
  void _startLoadingAnimation() {
    if (!_loadingAnimationController.isAnimating) {
      _loadingAnimationController.repeat(reverse: true);
    }
  }

  /// Stop the loading animation
  void _stopLoadingAnimation() {
    if (_loadingAnimationController.isAnimating) {
      _loadingAnimationController.stop();
      _loadingAnimationController.value = 1.0;
    }
  }

  /// Build a widget based on the current loading state
  Widget buildLoadingState({
    required BuildContext context,
    required Widget loadedWidget,
    Widget? loadingWidget,
    Widget? errorWidget,
    Widget? idleWidget,
  }) {
    switch (_loadingState) {
      case LoadingState.loading:
        return loadingWidget ?? _buildDefaultLoadingWidget(context);
      case LoadingState.error:
        return errorWidget ?? _buildDefaultErrorWidget(context);
      case LoadingState.loaded:
        return loadedWidget;
      case LoadingState.idle:
        return idleWidget ?? loadedWidget;
    }
  }

  /// Build the default loading widget with theme integration
  Widget _buildDefaultLoadingWidget(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      padding: EdgeInsets.all(design.designSystemSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                design.designSystemColors.primary,
              ),
            ),
          ),
          SizedBox(height: design.designSystemSpacing.lg),
          Text(
            'Loading...',
            style: design.designSystemTypography.bodyMedium.copyWith(
              color: design.designSystemColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Build the default error widget with retry functionality
  Widget _buildDefaultErrorWidget(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      padding: EdgeInsets.all(design.designSystemSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(design.designSystemSpacing.lg),
            decoration: BoxDecoration(
              color: design.designSystemColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: design.designSystemColors.error,
            ),
          ),
          SizedBox(height: design.designSystemSpacing.lg),
          Text(
            'Something went wrong',
            style: design.designSystemTypography.titleMedium.copyWith(
              color: design.designSystemColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: design.designSystemSpacing.sm),
          Text(
            'Please check your connection and try again',
            style: design.designSystemTypography.bodyMedium.copyWith(
              color: design.designSystemColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: design.designSystemSpacing.xl),
          ElevatedButton.icon(
            onPressed: () => retryLoading?.call(),
            icon: Icon(Icons.refresh, size: 20),
            label: Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: design.designSystemColors.primary,
              foregroundColor: design.designSystemColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(design.designSystemRadius.md),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: design.designSystemSpacing.lg,
                vertical: design.designSystemSpacing.md,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Callbacks for loading state changes
  VoidCallback? get onLoadingStarted => null;
  VoidCallback? get onLoadingCompleted => null;
  VoidCallback? get onLoadingError => null;
  VoidCallback? get retryLoading => null;
}

/// Loading states enum
enum LoadingState {
  /// Initial state, no loading in progress
  idle,

  /// Currently loading
  loading,

  /// Successfully loaded
  loaded,

  /// Loading failed with error
  error,
}