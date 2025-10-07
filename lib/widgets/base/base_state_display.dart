import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

/// Enum representing different display states
enum DisplayState {
  loading,
  error,
  empty,
  success,
}

/// Base widget for displaying different states (loading, error, empty, success)
class BaseStateDisplay extends StatelessWidget {
  const BaseStateDisplay({
    super.key,
    this.state,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.successWidget,
    this.errorMessage,
    this.emptyMessage,
    this.onRetry,
    this.onRefresh,
    this.padding = const EdgeInsets.all(16.0),
    // New parameters for EmptyState compatibility
    this.title,
    this.message,
    this.icon,
    this.actionCallback,
    this.actionText,
    this.iconSize = 64.0,
    this.backgroundColor,
    this.centerContent = true,
  });

  /// The current display state
  final DisplayState? state;

  /// Custom loading widget
  final Widget? loadingWidget;

  /// Custom error widget
  final Widget? errorWidget;

  /// Custom empty widget
  final Widget? emptyWidget;

  /// Custom success widget
  final Widget? successWidget;

  /// Error message to display
  final String? errorMessage;

  /// Empty state message to display
  final String? emptyMessage;

  /// Callback when retry button is pressed
  final VoidCallback? onRetry;

  /// Callback when refresh is triggered
  final VoidCallback? onRefresh;

  /// Padding around the content
  final EdgeInsets padding;

  /// Primary text content (for empty state)
  final String? title;

  /// Secondary descriptive text (for empty state)
  final String? message;

  /// Icon to display (for empty state)
  final IconData? icon;

  /// Callback for action button (for empty state)
  final VoidCallback? actionCallback;

  /// Text for action button (for empty state)
  final String? actionText;

  /// Size of the icon
  final double iconSize;

  /// Background color for the state display
  final Color? backgroundColor;

  /// Whether to center the content
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    // If title is provided, use the new empty state style (for EmptyState widget)
    if (title != null) {
      return _buildEmptyStateFromTitle();
    }

    // Otherwise, use the old state-based approach
    switch (state) {
      case DisplayState.loading:
        return _buildLoadingState();
      case DisplayState.error:
        return _buildErrorState();
      case DisplayState.empty:
        return _buildEmptyState();
      case DisplayState.success:
        return _buildSuccessState();
      default:
        return _buildEmptyState(); // fallback
    }
  }

  Widget _buildLoadingState() {
    if (loadingWidget != null) {
      return Padding(
        padding: padding,
        child: loadingWidget!,
      );
    }

    return Padding(
      padding: padding,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState() {
    if (errorWidget != null) {
      return Padding(
        padding: padding,
        child: errorWidget!,
      );
    }

    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: DesignSystem.error,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? 'Something went wrong',
              style: DesignSystem.bodyMedium.copyWith(
                color: DesignSystem.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    if (emptyWidget != null) {
      return Padding(
        padding: padding,
        child: emptyWidget!,
      );
    }

    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox,
              size: 64,
              color: DesignSystem.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage ?? 'No data available',
              style: DesignSystem.bodyMedium.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onRefresh,
                child: const Text('Refresh'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    if (successWidget != null) {
      return Padding(
        padding: padding,
        child: successWidget!,
      );
    }

    // For success state, we might not need a default widget
    // as the content would typically be provided by the parent
    return const SizedBox.shrink();
  }

  Widget _buildEmptyStateFromTitle() {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon section
        if (icon != null) ...[
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: DesignSystem.surfaceContainer,
              borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16),
        ],

        // Content section
        Text(
          title!,
          style: DesignSystem.titleMedium.copyWith(
            color: DesignSystem.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        if (message != null) ...[
          const SizedBox(height: 8),
          Text(
            message!,
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],

        // Action section
        if (actionText != null && actionCallback != null) ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: actionCallback,
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignSystem.primary,
              foregroundColor: DesignSystem.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              ),
            ),
            child: Text(
              actionText!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ],
    );

    if (centerContent) {
      content = Center(child: content);
    }

    return Padding(
      padding: padding,
      child: Container(
        color: backgroundColor,
        child: content,
      ),
    );
  }
}

/// Extension to easily create state displays
extension StateDisplayExtension on DisplayState {
  Widget toWidget({
    Widget? loadingWidget,
    Widget? errorWidget,
    Widget? emptyWidget,
    Widget? successWidget,
    String? errorMessage,
    String? emptyMessage,
    VoidCallback? onRetry,
    VoidCallback? onRefresh,
    EdgeInsets padding = const EdgeInsets.all(16.0),
  }) {
    return BaseStateDisplay(
      state: this,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
      emptyWidget: emptyWidget,
      successWidget: successWidget,
      errorMessage: errorMessage,
      emptyMessage: emptyMessage,
      onRetry: onRetry,
      onRefresh: onRefresh,
      padding: padding,
    );
  }
}