import 'package:flutter/material.dart';
import '../../utils/logger.dart';

/// Global error handler for catching all Flutter errors and exceptions
class ErrorHandler {
  static void initialize() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };
  }

  /// Handles Flutter framework errors
  static void _handleFlutterError(FlutterErrorDetails details) {
    final errorString = details.exception.toString();
    
    // Handle common UI errors more gracefully
    if (_isLayoutError(errorString)) {
      logger.w(
        '⚠️ Layout Error (handled gracefully)',
        error: details.exception,
      );
      // Don't crash the app for layout errors - they're often non-critical
      return;
    }
    
    if (_isTabControllerError(errorString)) {
      logger.w(
        '⚠️ TabController Error (handled gracefully)',
        error: details.exception,
      );
      // Don't crash the app for tab controller mismatches
      return;
    }
    
    logger.e(
      '⛔ Flutter Error',
      error: details.exception,
      stackTrace: details.stack,
    );

    // Log additional context
    logger.w('⚠️ Error Context: ${details.context}');
    if (details.library != null) {
      logger.w('⚠️ Library: ${details.library}');
    }
    if (details.informationCollector != null) {
      final info = details.informationCollector!();
      logger.w('⚠️ Additional Info: $info');
    }
  }
  
  /// Checks if the error is a layout-related error that can be handled gracefully
  static bool _isLayoutError(String errorString) {
    return errorString.contains('RenderFlex overflowed') ||
           errorString.contains('overflowed by') ||
           errorString.contains('overflow') ||
           errorString.contains('RenderBox');
  }
  
  /// Checks if the error is a TabController-related error
  static bool _isTabControllerError(String errorString) {
    return errorString.contains('TabController') ||
           errorString.contains('length property') ||
           errorString.contains('number of children') ||
           errorString.contains('number of tabs');
  }

  /// Handles errors in the root zone
  static void handleZoneError(Object error, StackTrace stack) {
    logger.e(
      'Zone Error',
      error: error,
      stackTrace: stack,
    );
  }

  /// Logs navigation errors
  static void logNavigationError(String route, Object error, StackTrace stack) {
    logger.e(
      'Navigation Error for route: $route',
      error: error,
      stackTrace: stack,
    );
  }

  /// Logs content loading errors
  static void logContentLoadingError(String screen, String contentType, Object error, StackTrace stack) {
    logger.e(
      'Content Loading Error - Screen: $screen, Type: $contentType',
      error: error,
      stackTrace: stack,
    );
  }

  /// Logs navigation events
  static void logNavigationEvent(String from, String to, {String? method}) {
    logger.i('Navigation Event: $from -> $to${method != null ? ' (method: $method)' : ''}');
  }

  /// Logs content loading events
  static void logContentLoadingEvent(String screen, String contentType, {String? status}) {
    logger.i('Content Loading Event - Screen: $screen, Type: $contentType${status != null ? ' (status: $status)' : ''}');
  }
}