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
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Padding(
      padding: padding ?? EdgeInsets.all(design.designSystemSpacing.xl),
      child: Center(
        child: _buildStateContent(context, design),
      ),
    );
  }

  Widget _buildStateContent(BuildContext context, DesignSystemThemeExtension design) {
    switch (state) {
      case LoadingState.loading:
        return _buildLoadingState(design);
      case LoadingState.empty:
        return emptyWidget ?? _buildDefaultEmptyState(design);
      case LoadingState.error:
        return errorWidget ?? _buildDefaultErrorState(design);
    }
  }

  Widget _buildLoadingState(DesignSystemThemeExtension design) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        loadingIndicator ?? SizedBox(
          width: loadingSize,
          height: loadingSize,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(design.designSystemColors.primary),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Loading...',
          style: design.designSystemTypography.bodyMedium.copyWith(
            color: design.designSystemColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultEmptyState(DesignSystemThemeExtension design) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(design.designSystemSpacing.xl),
          decoration: BoxDecoration(
            color: design.designSystemColors.surfaceContainer,
            borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
          ),
          child: Icon(
            emptyIcon ?? Icons.inbox_outlined,
            size: 64,
            color: design.designSystemColors.onSurfaceVariant,
          ),
        ),
        SizedBox(height: design.designSystemSpacing.lg),
        Text(
          emptyMessage ?? 'No items found',
          style: design.designSystemTypography.titleMedium.copyWith(
            color: design.designSystemColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        if (emptyMessage != null) ...[
          SizedBox(height: design.designSystemSpacing.sm),
          Text(
            emptyMessage!,
            style: design.designSystemTypography.bodyMedium.copyWith(
              color: design.designSystemColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultErrorState(DesignSystemThemeExtension design) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(design.designSystemSpacing.xl),
          decoration: BoxDecoration(
            color: design.designSystemColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
          ),
          child: Icon(
            errorIcon ?? Icons.error_outline,
            size: 64,
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
          errorMessage ?? 'Please check your connection and try again',
          style: design.designSystemTypography.bodyMedium.copyWith(
            color: design.designSystemColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        if (showRetryButton && onRetry != null) ...[
          SizedBox(height: design.designSystemSpacing.xl),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text('Try Again'),
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