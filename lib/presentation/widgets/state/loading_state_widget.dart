import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

/// A unified widget for handling loading, error, and empty states.
/// Provides consistent UI and behavior across the app for different states.
///
/// Features:
/// - Loading state with customizable indicator
/// - Error state with retry functionality
/// - Empty state with custom messaging
/// - Consistent styling and animations
/// - Flexible content customization
class LoadingStateWidget extends StatelessWidget {
  /// The current state of the widget
  final LoadingState state;

  /// Message to display in empty state
  final String? emptyMessage;

  /// Message to display in error state
  final String? errorMessage;

  /// Callback when retry button is pressed in error state
  final VoidCallback? onRetry;

  /// Custom loading indicator widget
  final Widget? loadingIndicator;

  /// Custom empty state widget
  final Widget? emptyWidget;

  /// Custom error state widget
  final Widget? errorWidget;

  /// Size of the loading indicator
  final double loadingSize;

  /// Icon for empty state
  final IconData? emptyIcon;

  /// Icon for error state
  final IconData? errorIcon;

  /// Whether to show a retry button in error state
  final bool showRetryButton;

  /// Custom padding for the entire widget
  final EdgeInsetsGeometry? padding;

  const LoadingStateWidget({
    super.key,
    required this.state,
    this.emptyMessage,
    this.errorMessage,
    this.onRetry,
    this.loadingIndicator,
    this.emptyWidget,
    this.errorWidget,
    this.loadingSize = 48,
    this.emptyIcon,
    this.errorIcon,
    this.showRetryButton = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(DesignSystem.spacingXL),
      child: Center(
        child: _buildStateContent(context),
      ),
    );
  }

  Widget _buildStateContent(BuildContext context) {
    switch (state) {
      case LoadingState.loading:
        return _buildLoadingState();
      case LoadingState.empty:
        return emptyWidget ?? _buildDefaultEmptyState();
      case LoadingState.error:
        return errorWidget ?? _buildDefaultErrorState();
    }
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        loadingIndicator ?? SizedBox(
          width: loadingSize,
          height: loadingSize,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(DesignSystem.primary),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Loading...',
          style: DesignSystem.bodyMedium.copyWith(
            color: DesignSystem.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultEmptyState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(DesignSystem.spacingXL),
          decoration: BoxDecoration(
            color: DesignSystem.surfaceContainer,
            borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
          ),
          child: Icon(
            emptyIcon ?? Icons.inbox_outlined,
            size: 64,
            color: DesignSystem.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingLG),
        Text(
          emptyMessage ?? 'No items found',
          style: DesignSystem.titleMedium.copyWith(
            color: DesignSystem.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        if (emptyMessage != null) ...[
          const SizedBox(height: DesignSystem.spacingSM),
          Text(
            emptyMessage!,
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultErrorState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(DesignSystem.spacingXL),
          decoration: BoxDecoration(
            color: DesignSystem.error.withAlpha((255 * 0.1).round()),
            borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
          ),
          child: Icon(
            errorIcon ?? Icons.error_outline,
            size: 64,
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
          errorMessage ?? 'Please check your connection and try again',
          style: DesignSystem.bodyMedium.copyWith(
            color: DesignSystem.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        if (showRetryButton && onRetry != null) ...[
          const SizedBox(height: DesignSystem.spacingXL),
          ElevatedButton.icon(
            onPressed: onRetry,
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
}

/// Enum representing the different loading states
enum LoadingState {
  /// Content is currently being loaded
  loading,

  /// No content available to display
  empty,

  /// An error occurred while loading content
  error,
}
