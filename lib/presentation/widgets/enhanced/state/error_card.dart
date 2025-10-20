import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A widget for displaying error states with icon, message, and retry button
/// 
/// Use this to show user-friendly error messages with recovery options.
/// 
/// Example:
/// ```dart
/// if (state is ErrorState) {
///   return ErrorCard(
///     error: state.message,
///     onRetry: () => context.read<MusicBloc>().add(LoadMusic()),
///   );
/// }
/// ```
class ErrorCard extends StatelessWidget {
  /// Error message to display
  final String error;

  /// Optional detailed error message
  final String? details;

  /// Retry callback
  final VoidCallback? onRetry;

  /// Custom error icon
  final IconData? icon;

  /// Icon size
  final double iconSize;

  /// Icon color
  final Color? iconColor;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Whether to show as a card (true) or full screen (false)
  final bool asCard;

  const ErrorCard({
    super.key,
    required this.error,
    this.details,
    this.onRetry,
    this.icon,
    this.iconSize = 64,
    this.iconColor,
    this.padding,
    this.asCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Error Icon
        Icon(
          icon ?? Icons.error_outline,
          size: iconSize,
          color: iconColor ?? DesignSystem.error,
        ),

        const SizedBox(height: DesignSystem.spacingLG),

        // Error Title
        Text(
          'Something went wrong',
          style: DesignSystem.headlineSmall.copyWith(
            color: DesignSystem.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: DesignSystem.spacingSM),

        // Error Message
        Text(
          error,
          style: DesignSystem.bodyMedium.copyWith(
            color: DesignSystem.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),

        // Details
        if (details != null) ...[
          const SizedBox(height: DesignSystem.spacingSM),
          Text(
            details!,
            style: DesignSystem.bodySmall.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],

        // Retry Button
        if (onRetry != null) ...[
          const SizedBox(height: DesignSystem.spacingLG),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignSystem.primary,
              foregroundColor: DesignSystem.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacingXL,
                vertical: DesignSystem.spacingMD,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              ),
            ),
          ),
        ],
      ],
    );

    if (asCard) {
      return Container(
        padding: padding ?? const EdgeInsets.all(DesignSystem.spacingXL),
        margin: const EdgeInsets.all(DesignSystem.spacingLG),
        decoration: BoxDecoration(
          color: DesignSystem.surfaceContainer,
          borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
          border: Border.all(
            color: DesignSystem.error.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: content,
      );
    }

    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(DesignSystem.spacingXL),
        child: content,
      ),
    );
  }

  /// Preset for network errors
  factory ErrorCard.networkError({
    VoidCallback? onRetry,
    bool asCard = false,
  }) {
    return ErrorCard(
      error: 'Unable to connect to the server',
      details: 'Please check your internet connection and try again',
      icon: Icons.wifi_off,
      onRetry: onRetry,
      asCard: asCard,
    );
  }

  /// Preset for not found errors
  factory ErrorCard.notFound({
    String? message,
    VoidCallback? onRetry,
    bool asCard = false,
  }) {
    return ErrorCard(
      error: message ?? 'Content not found',
      details: 'The content you\'re looking for doesn\'t exist or has been removed',
      icon: Icons.search_off,
      onRetry: onRetry,
      asCard: asCard,
    );
  }

  /// Preset for permission errors
  factory ErrorCard.permissionDenied({
    String? message,
    VoidCallback? onRetry,
    bool asCard = false,
  }) {
    return ErrorCard(
      error: message ?? 'Permission denied',
      details: 'You don\'t have permission to access this content',
      icon: Icons.lock_outline,
      onRetry: onRetry,
      asCard: asCard,
    );
  }

  /// Preset for generic errors
  factory ErrorCard.generic({
    String? message,
    String? details,
    VoidCallback? onRetry,
    bool asCard = false,
  }) {
    return ErrorCard(
      error: message ?? 'An unexpected error occurred',
      details: details,
      onRetry: onRetry,
      asCard: asCard,
    );
  }
}

/// A compact error banner for inline error displays
class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ErrorBanner({
    super.key,
    required this.message,
    this.onRetry,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      margin: const EdgeInsets.all(DesignSystem.spacingMD),
      decoration: BoxDecoration(
        color: DesignSystem.errorContainer,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: DesignSystem.error,
            size: 20,
          ),
          const SizedBox(width: DesignSystem.spacingSM),
          Expanded(
            child: Text(
              message,
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onErrorContainer,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: TextStyle(
                  color: DesignSystem.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: Icon(
                Icons.close,
                color: DesignSystem.onErrorContainer,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
