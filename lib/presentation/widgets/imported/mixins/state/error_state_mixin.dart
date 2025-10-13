import 'package:flutter/material.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

/// A mixin that provides comprehensive error state management for widgets.
///
/// This mixin handles:
/// - Error state tracking with detailed error information
/// - Retry functionality with customizable retry strategies
/// - Error recovery mechanisms and callbacks
/// - Consistent error UI with theme integration
/// - Error logging and reporting capabilities
/// - Network error detection and handling
///
/// Usage:
/// ```dart
/// class MyWidget extends StatefulWidget {
///   // ...
/// }
///
/// class _MyWidgetState extends State<MyWidget>
///     with ErrorStateMixin {
///
///   void _loadData() {
///     try {
///       // ... load data ...
///     } catch (error) {
///       setError(error, stackTrace: StackTrace.current);
///     }
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return buildErrorState(
///       context,
///       errorWidget: _buildErrorContent(),
///       onRetry: _retryLoadData,
///     );
///   }
/// }
/// ```
mixin ErrorStateMixin<T extends StatefulWidget> on State<T> {
  /// Current error information
  ErrorInfo? _currentError;

  /// Whether currently in error state
  bool get hasError => _currentError != null;

  /// Gets the current error information
  ErrorInfo? get currentError => _currentError;

  /// Gets the error message for display
  String? get errorMessage => _currentError?.message;

  /// Gets the error type
  ErrorType? get errorType => _currentError?.type;

  /// Whether the error is retryable
  bool get canRetry => _currentError?.retryable ?? false;

  /// Set an error state with detailed error information
  void setError(
    dynamic error, {
    StackTrace? stackTrace,
    String? customMessage,
    ErrorType? type,
    bool retryable = true,
  }) {
    final errorInfo = ErrorInfo(
      error: error,
      stackTrace: stackTrace,
      message: customMessage ?? _getDefaultErrorMessage(error),
      type: type ?? _determineErrorType(error),
      retryable: retryable,
      timestamp: DateTime.now(),
    );

    _setErrorInfo(errorInfo);
  }

  /// Clear the current error state
  void clearError() {
    _currentError = null;
    onErrorCleared?.call();
  }

  /// Set error information directly
  void _setErrorInfo(ErrorInfo errorInfo) {
    _currentError = errorInfo;
    onErrorOccurred?.call(errorInfo);

    // Log error if logging is enabled
    _logError(errorInfo);
  }

  /// Get default error message based on error type
  String _getDefaultErrorMessage(dynamic error) {
    if (error is NetworkError) {
      return 'Please check your internet connection and try again';
    } else if (error is TimeoutError) {
      return 'Request timed out. Please try again';
    } else if (error is ServerError) {
      return 'Server error occurred. Please try again later';
    } else if (error is ValidationError) {
      return error.message ?? 'Invalid data provided';
    } else {
      return 'An unexpected error occurred';
    }
  }

  /// Determine error type from error object
  ErrorType _determineErrorType(dynamic error) {
    if (error is NetworkError || error.toString().contains('network')) {
      return ErrorType.network;
    } else if (error is TimeoutError || error.toString().contains('timeout')) {
      return ErrorType.timeout;
    } else if (error is ServerError || error.toString().contains('server')) {
      return ErrorType.server;
    } else if (error is ValidationError) {
      return ErrorType.validation;
    } else {
      return ErrorType.unknown;
    }
  }

  /// Log error for debugging and monitoring
  void _logError(ErrorInfo errorInfo) {
    // In a real app, you might want to use a logging service
    debugPrint('Error occurred: ${errorInfo.message}');
    debugPrint('Error type: ${errorInfo.type}');
    debugPrint('Error timestamp: ${errorInfo.timestamp}');

    if (errorInfo.stackTrace != null) {
      debugPrint('Stack trace: ${errorInfo.stackTrace}');
    }
  }

  /// Build a widget based on the current error state
  Widget buildErrorState({
    required BuildContext context,
    required Widget Function(BuildContext context) errorWidget,
    VoidCallback? onRetry,
    bool showRetryButton = true,
  }) {
    if (_currentError == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: _getErrorPadding(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildErrorIcon(context),
          SizedBox(height: _getErrorSpacing(context)),
          _buildErrorMessage(context),
          if (showRetryButton && canRetry && onRetry != null) ...[
            SizedBox(height: _getErrorSpacing(context) * 1.5),
            _buildRetryButton(context, onRetry),
          ],
        ],
      ),
    );
  }

  /// Build the default error widget
  Widget buildDefaultErrorWidget({
    required BuildContext context,
    VoidCallback? onRetry,
    bool showRetryButton = true,
  }) {
    return buildErrorState(
      context: context,
      errorWidget: (context) => _buildDefaultErrorContent(context),
      onRetry: onRetry,
      showRetryButton: showRetryButton,
    );
  }

  /// Build default error content
  Widget _buildDefaultErrorContent(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

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
            _getErrorIcon(),
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
          _currentError?.message ?? 'An unexpected error occurred',
          style: design.designSystemTypography.bodyMedium.copyWith(
            color: design.designSystemColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Get error icon based on error type
  IconData _getErrorIcon() {
    switch (_currentError?.type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.timeout:
        return Icons.timer_off;
      case ErrorType.server:
        return Icons.cloud_off;
      case ErrorType.validation:
        return Icons.warning;
      case ErrorType.unknown:
      default:
        return Icons.error_outline;
    }
  }

  /// Build error icon widget
  Widget _buildErrorIcon(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      padding: EdgeInsets.all(design.designSystemSpacing.lg),
      decoration: BoxDecoration(
        color: design.designSystemColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
      ),
      child: Icon(
        _getErrorIcon(),
        size: 48,
        color: design.designSystemColors.error,
      ),
    );
  }

  /// Build error message widget
  Widget _buildErrorMessage(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Column(
      children: [
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
          _currentError?.message ?? 'An unexpected error occurred',
          style: design.designSystemTypography.bodyMedium.copyWith(
            color: design.designSystemColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build retry button widget
  Widget _buildRetryButton(BuildContext context, VoidCallback onRetry) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return ElevatedButton.icon(
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
    );
  }

  /// Get error padding based on context
  EdgeInsetsGeometry _getErrorPadding(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;
    return EdgeInsets.all(design.designSystemSpacing.xl);
  }

  /// Get error spacing based on context
  double _getErrorSpacing(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;
    return design.designSystemSpacing.lg;
  }

  /// Callbacks for error state changes
  void Function(ErrorInfo errorInfo)? get onErrorOccurred => null;
  void Function()? get onErrorCleared => null;
}

/// Error information container
class ErrorInfo {
  /// The original error object
  final dynamic error;

  /// Stack trace if available
  final StackTrace? stackTrace;

  /// User-friendly error message
  final String message;

  /// Type of error
  final ErrorType type;

  /// Whether this error can be retried
  final bool retryable;

  /// When the error occurred
  final DateTime timestamp;

  const ErrorInfo({
    required this.error,
    this.stackTrace,
    required this.message,
    required this.type,
    this.retryable = true,
    required this.timestamp,
  });
}

/// Types of errors that can occur
enum ErrorType {
  /// Network connectivity issues
  network,

  /// Request timeout
  timeout,

  /// Server-side errors
  server,

  /// Data validation errors
  validation,

  /// Unknown or unexpected errors
  unknown,
}

/// Common error classes for type detection
class NetworkError extends Error {
  final String message;
  NetworkError(this.message);
}

class TimeoutError extends Error {
  final String message;
  TimeoutError(this.message);
}

class ServerError extends Error {
  final String message;
  ServerError(this.message);
}

class ValidationError extends Error {
  final String? message;
  ValidationError(this.message);
}