import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

/// A builder class for composing state displays with proper fallbacks.
/// Provides a fluent API for building consistent state-based UI components.
///
/// **Features:**
/// - Support for loading, error, empty, and success states
/// - Customizable state-specific widgets and messages
/// - Built-in retry functionality for error states
/// - Consistent styling with design system
/// - Flexible state management and transitions
/// - Support for custom animations and transitions
///
/// **Usage:**
/// ```dart
/// final stateWidget = StateBuilder()
///   .withState(StateType.loading)
///   .withLoadingMessage('Fetching your data...')
///   .withLoadingIndicator(CircularProgressIndicator())
///   .withEmptyMessage('No items found')
///   .withEmptyIcon(Icons.inbox_outlined)
///   .withErrorMessage('Something went wrong')
///   .withOnRetry(() => loadData())
///   .withPadding(EdgeInsets.all(DesignSystem.spacingLG))
///   .build();
/// ```
class StateBuilder {
  StateType _state = StateType.loading;
  String? _loadingMessage;
  String? _emptyMessage;
  String? _errorMessage;
  String? _successMessage;
  Widget? _loadingWidget;
  Widget? _emptyWidget;
  Widget? _errorWidget;
  Widget? _successWidget;
  IconData? _emptyIcon;
  IconData? _errorIcon;
  IconData? _successIcon;
  VoidCallback? _onRetry;
  EdgeInsetsGeometry? _padding;
  bool _showRetryButton = true;
  double _iconSize = 64.0;
  Duration _animationDuration = const Duration(milliseconds: 300);

  /// Creates a new StateBuilder instance
  StateBuilder();

  /// Sets the current state
  StateBuilder withState(StateType state) {
    _state = state;
    return this;
  }

  /// Sets custom loading message
  StateBuilder withLoadingMessage(String message) {
    _loadingMessage = message;
    return this;
  }

  /// Sets custom empty state message
  StateBuilder withEmptyMessage(String message) {
    _emptyMessage = message;
    return this;
  }

  /// Sets custom error state message
  StateBuilder withErrorMessage(String message) {
    _errorMessage = message;
    return this;
  }

  /// Sets custom success state message
  StateBuilder withSuccessMessage(String message) {
    _successMessage = message;
    return this;
  }

  /// Sets custom loading widget
  StateBuilder withLoadingWidget(Widget widget) {
    _loadingWidget = widget;
    return this;
  }

  /// Sets custom empty state widget
  StateBuilder withEmptyWidget(Widget widget) {
    _emptyWidget = widget;
    return this;
  }

  /// Sets custom error state widget
  StateBuilder withErrorWidget(Widget widget) {
    _errorWidget = widget;
    return this;
  }

  /// Sets custom success state widget
  StateBuilder withSuccessWidget(Widget widget) {
    _successWidget = widget;
    return this;
  }

  /// Sets icon for empty state
  StateBuilder withEmptyIcon(IconData icon) {
    _emptyIcon = icon;
    return this;
  }

  /// Sets icon for error state
  StateBuilder withErrorIcon(IconData icon) {
    _errorIcon = icon;
    return this;
  }

  /// Sets icon for success state
  StateBuilder withSuccessIcon(IconData icon) {
    _successIcon = icon;
    return this;
  }

  /// Sets retry callback for error state
  StateBuilder withOnRetry(VoidCallback onRetry) {
    _onRetry = onRetry;
    return this;
  }

  /// Sets custom padding for the state widget
  StateBuilder withPadding(EdgeInsetsGeometry padding) {
    _padding = padding;
    return this;
  }

  /// Sets whether to show retry button in error state
  StateBuilder withShowRetryButton(bool show) {
    _showRetryButton = show;
    return this;
  }

  /// Sets icon size for state icons
  StateBuilder withIconSize(double size) {
    _iconSize = size;
    return this;
  }

  /// Sets animation duration for state transitions
  StateBuilder withAnimationDuration(Duration duration) {
    _animationDuration = duration;
    return this;
  }

  /// Builds and returns the final state widget
  Widget build() {
    return AnimatedSwitcher(
      duration: _animationDuration,
      child: Container(
        key: ValueKey<StateType>(_state),
        padding: _padding ?? const EdgeInsets.all(DesignSystem.spacingXL),
        child: _buildStateContent(),
      ),
    );
  }

  Widget _buildStateContent() {
    switch (_state) {
      case StateType.loading:
        return _loadingWidget ?? _buildDefaultLoadingState();
      case StateType.empty:
        return _emptyWidget ?? _buildDefaultEmptyState();
      case StateType.error:
        return _errorWidget ?? _buildDefaultErrorState();
      case StateType.success:
        return _successWidget ?? _buildDefaultSuccessState();
    }
  }

  Widget _buildDefaultLoadingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(DesignSystem.spacingLG),
          decoration: BoxDecoration(
            color: DesignSystem.surfaceContainer,
            borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
          ),
          child: const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(DesignSystem.primary),
            ),
          ),
        ),
        const SizedBox(height: DesignSystem.spacingLG),
        Text(
          _loadingMessage ?? 'Loading...',
          style: DesignSystem.bodyMedium.copyWith(
            color: DesignSystem.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDefaultEmptyState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(DesignSystem.spacingLG),
          decoration: BoxDecoration(
            color: DesignSystem.surfaceContainer,
            borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
          ),
          child: Icon(
            _emptyIcon ?? Icons.inbox_outlined,
            size: _iconSize,
            color: DesignSystem.onSurfaceVariant,
          ),
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
    );
  }

  Widget _buildDefaultErrorState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(DesignSystem.spacingLG),
          decoration: BoxDecoration(
            color: DesignSystem.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
          ),
          child: Icon(
            _errorIcon ?? Icons.error_outline,
            size: _iconSize,
            color: DesignSystem.error,
          ),
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
        if (_showRetryButton && _onRetry != null) ...[
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
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacingLG,
                vertical: DesignSystem.spacingMD,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultSuccessState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(DesignSystem.spacingLG),
          decoration: BoxDecoration(
            color: DesignSystem.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
          ),
          child: Icon(
            _successIcon ?? Icons.check_circle_outline,
            size: _iconSize,
            color: DesignSystem.success,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingLG),
        Text(
          _successMessage ?? 'Success!',
          style: DesignSystem.titleMedium.copyWith(
            color: DesignSystem.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// State types for the state builder
enum StateType {
  /// Loading state - showing loading indicator
  loading,

  /// Empty state - no content to display
  empty,

  /// Error state - error occurred
  error,

  /// Success state - operation completed successfully
  success,
}

/// Extension for quick state widget creation
extension StateBuilderExtension on StateType {
  /// Creates a StateBuilder with this state pre-selected
  StateBuilder get builder => StateBuilder().withState(this);
}