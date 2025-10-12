import 'package:flutter/material.dart';
import '../../../core/design_system/design_system.dart';

/// Reusable error widget with consistent styling
class ErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final IconData? icon;
  final Color? iconColor;

  const ErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(MusicBudSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: iconColor ?? theme.colorScheme.error,
            ),
            const SizedBox(height: MusicBudSpacing.lg),
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MusicBudSpacing.md),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: MusicBudSpacing.xl),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: MusicBudSpacing.lg,
                    vertical: MusicBudSpacing.md,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state widget for when there's no data
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final Widget? action;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.action,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(MusicBudSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.music_off,
              size: 64,
              color: iconColor ?? theme.colorScheme.outline,
            ),
            const SizedBox(height: MusicBudSpacing.lg),
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MusicBudSpacing.md),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: MusicBudSpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Network error widget specifically for network issues
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? customMessage;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      title: 'Connection Error',
      message: customMessage ??
          'Unable to connect to the server. Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }
}

/// Server error widget for server-side errors
class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? customMessage;

  const ServerErrorWidget({
    super.key,
    this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      title: 'Server Error',
      message: customMessage ??
          'Something went wrong on our end. Please try again later.',
      icon: Icons.error,
      iconColor: Theme.of(context).colorScheme.error,
      onRetry: onRetry,
    );
  }
}

/// Generic error dialog
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (actionText != null && onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionText!),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  /// Show error dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        actionText: actionText,
        onAction: onAction,
      ),
    );
  }
}

/// Error snackbar for quick error messages
class ErrorSnackbar extends StatelessWidget {
  final String message;
  final Duration duration;
  final VoidCallback? onAction;
  final String? actionLabel;

  const ErrorSnackbar({
    super.key,
    required this.message,
    this.duration = const Duration(seconds: 4),
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SnackBar(
      content: Text(message),
      duration: duration,
      backgroundColor: theme.colorScheme.error,
      action: onAction != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel!,
              textColor: theme.colorScheme.onError,
              onPressed: onAction!,
            )
          : null,
    );
  }

  /// Show error snackbar
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: Theme.of(context).colorScheme.error,
        action: onAction != null && actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Theme.of(context).colorScheme.onError,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }
}
