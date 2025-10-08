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

Future<void> startProxyServer() async {
  Logger.root.level = Level.INFO;
  _loggingSubscription = Logger.root.onRecord.listen((record) {
    try {
      _logger.info('${record.level.name}: ${record.time}: ${record.message}');
    } catch (e) {
      // Handle case where logging fails (e.g., subscription closed)
      debugPrint('Logging failed: $e');
    }
  });

  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(proxyHandler(_targetUrl));

  final server = await io.serve(handler, 'localhost', _proxyPort);
  _logger.info('Proxy server running on localhost:${server.port}');
}

/// Stops the proxy server and cleans up resources
Future<void> stopProxyServer() async {
  if (_loggingSubscription != null) {
    await _loggingSubscription!.cancel();
    _loggingSubscription = null;
    _logger.info('Logging subscription cancelled');
  }
}