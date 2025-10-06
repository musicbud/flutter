import 'dart:async';
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
    logger.e(
      'Flutter Error',
      details.exception,
      details.stack,
    );

    // Log additional context
    logger.w('Error Context: ${details.context}');
    if (details.library != null) {
      logger.w('Library: ${details.library}');
    }
    if (details.informationCollector != null) {
      final info = details.informationCollector!();
      logger.w('Additional Info: $info');
    }
  }

  /// Handles errors in the root zone
  static void handleZoneError(Object error, StackTrace stack) {
    logger.e(
      'Zone Error',
      error,
      stack,
    );
  }

  /// Logs navigation errors
  static void logNavigationError(String route, Object error, StackTrace stack) {
    logger.e(
      'Navigation Error for route: $route',
      error,
      stack,
    );
  }

  /// Logs content loading errors
  static void logContentLoadingError(String screen, String contentType, Object error, StackTrace stack) {
    logger.e(
      'Content Loading Error - Screen: $screen, Type: $contentType',
      error,
      stack,
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