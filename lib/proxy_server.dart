import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_proxy/shelf_proxy.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:logging/logging.dart';

final _logger = Logger('ProxyServer');
const _proxyPort = 8080;
const _targetUrl = 'http://localhost:3000';

// Store the logging subscription to manage its lifecycle
StreamSubscription<LogRecord>? _loggingSubscription;
bool _isLoggingActive = false;
StreamController<LogRecord>? _logController;

Future<void> startProxyServer() async {
  try {
    // Stop any existing proxy server first
    await stopProxyServer();
    
    Logger.root.level = Level.INFO;
    
    // Create a dedicated stream controller to prevent event conflicts
    _logController = StreamController<LogRecord>.broadcast();
    
    // Set up a single listener for the logger
    _loggingSubscription = _logController!.stream.listen((record) {
      if (!_isLoggingActive) {
        _isLoggingActive = true;
        try {
          // Use debugPrint instead of logger to avoid recursion
          if (kDebugMode) {
            debugPrint('ProxyServer ${record.level.name}: ${record.message}');
          }
        } catch (e) {
          // Silently handle any logging errors to prevent cascading failures
        } finally {
          _isLoggingActive = false;
        }
      }
    });
    
    // Set up the logger to use our controlled stream
    Logger.root.onRecord.listen((record) {
      if (_logController != null && !_logController!.isClosed && !_isLoggingActive) {
        try {
          _logController!.add(record);
        } catch (e) {
          // Ignore errors when adding to closed controller
        }
      }
    });

    final handler = const shelf.Pipeline()
        .addMiddleware(shelf.logRequests())
        .addHandler(proxyHandler(_targetUrl));

    final server = await io.serve(handler, 'localhost', _proxyPort);
    if (kDebugMode) {
      debugPrint('ProxyServer: Server running on localhost:${server.port}');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('ProxyServer: Failed to start server: $e');
    }
  }
}

/// Stops the proxy server and cleans up resources
Future<void> stopProxyServer() async {
  try {
    // Set flag to prevent new events while cleaning up
    _isLoggingActive = true;
    
    // Cancel subscription first
    if (_loggingSubscription != null) {
      await _loggingSubscription!.cancel();
      _loggingSubscription = null;
    }
    
    // Close the stream controller
    if (_logController != null && !_logController!.isClosed) {
      await _logController!.close();
      _logController = null;
    }
    
    _isLoggingActive = false;
    if (kDebugMode) {
      debugPrint('ProxyServer: Resources cleaned up');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('ProxyServer: Error during cleanup: $e');
    }
  }
}
