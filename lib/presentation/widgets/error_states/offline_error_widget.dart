import 'dart:async';
import 'package:flutter/material.dart';

/// Widget to show when the app is in offline mode or API calls fail
class OfflineErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onUseMockData;
  final bool showMockDataOption;
  final IconData icon;

  const OfflineErrorWidget({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.onUseMockData,
    this.showMockDataOption = true,
    this.icon = Icons.cloud_off,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            
            // Action buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                if (onRetry != null)
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                
                if (showMockDataOption && onUseMockData != null)
                  OutlinedButton.icon(
                    onPressed: onUseMockData,
                    icon: const Icon(Icons.preview),
                    label: const Text('Preview Mode'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
              ],
            ),
            
            if (showMockDataOption)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Preview mode uses sample data for development',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Specific error widget for network connectivity issues
class NetworkErrorWidget extends OfflineErrorWidget {
  const NetworkErrorWidget({
    super.key,
    super.onRetry,
    super.onUseMockData,
  }) : super(
          title: 'Connection Issue',
          message: 'Unable to connect to MusicBud servers.\nCheck your internet connection and try again.',
          icon: Icons.wifi_off,
        );
}

/// Specific error widget for server unavailable
class ServerErrorWidget extends OfflineErrorWidget {
  const ServerErrorWidget({
    super.key,
    super.onRetry,
    super.onUseMockData,
  }) : super(
          title: 'Server Unavailable',
          message: 'MusicBud servers are temporarily unavailable.\nWe\'re working to fix this issue.',
          icon: Icons.dns,
        );
}

/// Specific error widget for timeout errors
class TimeoutErrorWidget extends OfflineErrorWidget {
  const TimeoutErrorWidget({
    super.key,
    super.onRetry,
    super.onUseMockData,
  }) : super(
          title: 'Request Timed Out',
          message: 'The request took too long to complete.\nPlease try again.',
          icon: Icons.timer_off,
        );
}

/// Loading widget with offline fallback
class LoadingWithOfflineFallback extends StatefulWidget {
  final String loadingMessage;
  final Duration timeoutDuration;
  final VoidCallback onTimeout;
  final Widget Function()? mockDataBuilder;

  const LoadingWithOfflineFallback({
    super.key,
    this.loadingMessage = 'Loading...',
    this.timeoutDuration = const Duration(seconds: 10),
    required this.onTimeout,
    this.mockDataBuilder,
  });

  @override
  State<LoadingWithOfflineFallback> createState() => _LoadingWithOfflineFallbackState();
}

class _LoadingWithOfflineFallbackState extends State<LoadingWithOfflineFallback> {
  late final Timer _timeoutTimer;
  bool _hasTimedOut = false;

  @override
  void initState() {
    super.initState();
    _timeoutTimer = Timer(widget.timeoutDuration, () {
      if (mounted) {
        setState(() {
          _hasTimedOut = true;
        });
        widget.onTimeout();
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasTimedOut && widget.mockDataBuilder != null) {
      return widget.mockDataBuilder!();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            widget.loadingMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Falling back to preview mode if this takes too long...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Empty state widget when no data is available
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel ?? 'Get Started'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

