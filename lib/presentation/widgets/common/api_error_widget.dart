import 'package:flutter/material.dart';

/// A reusable widget for displaying API error states with retry functionality
class ApiErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final bool showRetryButton;

  const ApiErrorWidget({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.showRetryButton = true,
  });

  /// Factory constructor for network errors
  factory ApiErrorWidget.networkError({
    VoidCallback? onRetry,
  }) {
    return ApiErrorWidget(
      title: 'Network Error',
      message: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }

  /// Factory constructor for server errors
  factory ApiErrorWidget.serverError({
    VoidCallback? onRetry,
  }) {
    return ApiErrorWidget(
      title: 'Server Error',
      message: 'We\'re having trouble connecting to our servers. Please try again later.',
      icon: Icons.cloud_off,
      onRetry: onRetry,
    );
  }

  /// Factory constructor for authentication errors
  factory ApiErrorWidget.authError({
    VoidCallback? onRetry,
  }) {
    return ApiErrorWidget(
      title: 'Authentication Error',
      message: 'Your session has expired. Please log in again.',
      icon: Icons.lock_outline,
      onRetry: onRetry,
      showRetryButton: false,
    );
  }

  /// Factory constructor for no data available
  factory ApiErrorWidget.noData({
    String title = 'No Data Available',
    String message = 'There\'s no content to display at the moment.',
    VoidCallback? onRetry,
  }) {
    return ApiErrorWidget(
      title: title,
      message: message,
      icon: Icons.inbox,
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (showRetryButton && onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A widget that wraps content and shows error states
class ApiContentWrapper extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final bool isEmpty;

  const ApiContentWrapper({
    super.key,
    required this.child,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.onRetry,
    this.loadingWidget,
    this.emptyWidget,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ??
          const Center(
            child: CircularProgressIndicator(),
          );
    }

    if (hasError) {
      return ApiErrorWidget(
        message: errorMessage ?? 'An unexpected error occurred',
        onRetry: onRetry,
      );
    }

    if (isEmpty) {
      return emptyWidget ??
          ApiErrorWidget.noData(
            onRetry: onRetry,
          );
    }

    return child;
  }
}